/* Copyright (c) 2011 Paul Meier
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.morepaul.pizzahut;

import hu.belicza.andras.sc2gearspluginapi.*;
import hu.belicza.andras.sc2gearspluginapi.api.*;
import hu.belicza.andras.sc2gearspluginapi.api.listener.*;
import hu.belicza.andras.sc2gearspluginapi.api.profile.*;
import hu.belicza.andras.sc2gearspluginapi.api.sc2replay.*;
import hu.belicza.andras.sc2gearspluginapi.impl.*;

import java.io.*;
import java.net.*;
import java.util.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;

import org.w3c.dom.*;

/**
 * A plugin that outputs data of the match most recently played into a 
 * plain-text file, to allow other programs (not plugged into Sc2Gears) to use
 * or display it.
 * 
 * This being my first Sc2Gears plugin, it borrows heavily from the example
 * source provided for developers.
 *
 * @author Paul Meier
 */
public class PizzaHutPluginMain extends BasePlugin
{

	/** Number of milliseconds we wait until sending the data
	    without a league. */
	private static final long PROFILE_WAIT_TIMEOUT = 15000;

	/** When we requested the profiles. Used to calculate timeouts. */
	private long m_profileQueryTime;

	/** The port we listen to for a connection. */
	private static final int PORT = 8080;

	/** Our writer to write out the XML data. */
	private Socket m_tacoBell;
	
	/** Reference to our new replay listener.  */
	private NewReplayListener m_newReplayListener;
	
	/** Replay Utils to calculate API. */
	private ReplayUtilsApi m_replayUtils;

	/** ProfileApi to fetch the player data. */
	private ProfileApi m_profileApi;

	/** XML tools. */
	private DocumentBuilderFactory m_docFactory; 
	private DocumentBuilder m_docBuilder; 

	/** Storage for fetched profiles. */
	private HashMap<String, IProfile> m_profiles;

	/** Convert DOM to XML */
	private Transformer m_transformer;

	/** Write the length of the transmission with this writer. */
	private PrintWriter m_socketWriter;

	/** Manages our network connections. */
	private PizzaHutSocketListener m_listener;

	/** Attributes we display for each player. */
	private enum PlayerAttribute 
	{
		NAME,
		RACE,
		LEAGUE,
		APM,
	}

	/** Attributes for the match itself */
	private enum MatchAttribute
	{
		TIME,
		MAP,
		LOSER_GG
	}


	@Override
	public void init( final PluginDescriptor pluginDescriptor, final PluginServices pluginServices, final GeneralServices generalServices ) 
	{
		// Call the init() implementation of the BasePlugin:
		super.init( pluginDescriptor, pluginServices, generalServices );

		PizzaHutSocketListener listener = new PizzaHutSocketListener(this, PORT);
		listener.start();
		
		m_replayUtils = generalServices.getReplayUtilsApi();
		m_profileApi = generalServices.getProfileApi();
		m_profiles = new HashMap<String, IProfile>();

		System.out.println("[PIZZAHUT] initing!");
		try
		{
			// Initialize your XML components.
			m_docFactory = DocumentBuilderFactory.newInstance();
			m_docBuilder = m_docFactory.newDocumentBuilder();

			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			m_transformer = transformerFactory.newTransformer();
		}
		catch (ParserConfigurationException pce)
		{
			pce.printStackTrace();
		} 
		catch (TransformerConfigurationException e)
		{
			e.printStackTrace();
		}

		// the 'l' stands for Y U NO LAMBDAS ?!?!?
		final PizzaHutPluginMain l_plugin = this;
	
		// Register a new replay listener
		generalServices.getCallbackApi().addNewReplayListener( m_newReplayListener = new NewReplayListener() {
			
			@Override
			public void newReplayDetected( final File replayFile ) {

				// Start with a clean slate.
				m_profiles.clear();

				// Cached info is enough for us: we acquire replay with ReplayFactory.getReplay()
				final IReplay replay = generalServices.getReplayFactoryApi().getReplay( replayFile.getAbsolutePath(), null );
				if ( replay == null )
				{
					return; // Failed to parse replay
				}
				System.out.println("[PIZZAHUT] Got replay!");

				IPlayer[] players = replay.getPlayers();

				// Search for profiles!
				for (int i = 0; i < players.length; ++i)
				{
					final IPlayerId id = players[i].getPlayerId();
					final String name = id.getName();
					m_profileApi.queryProfile(id, new PizzaHutProfileGetter(l_plugin, name), false, false);
				}
				m_profileQueryTime = System.currentTimeMillis();

				int numPlayers = players.length;

				int gameLength = replay.getGameLengthSec();
				double minutes = gameLength / 60;
	
				ArrayList<HashMap<PlayerAttribute, String>> playerInfo = new ArrayList<HashMap<PlayerAttribute,String>>(numPlayers);

				for (int i = 0; i < numPlayers; ++i)
				{
					HashMap<PlayerAttribute, String> thisSet = new HashMap<PlayerAttribute, String>();
					thisSet.put(PlayerAttribute.NAME, players[i].getPlayerId().getName());
					thisSet.put(PlayerAttribute.RACE, players[i].getRaceString());

					int apm = m_replayUtils.calculatePlayerApm(replay, players[i]);
					thisSet.put(PlayerAttribute.APM, Integer.toString(apm));
					thisSet.put(PlayerAttribute.LEAGUE, "unknown");

					playerInfo.add(i, thisSet);
				}

				HashMap<MatchAttribute,String> matchInfo = new HashMap<MatchAttribute,String>();

				int wholeMinutes = (int) Math.floor(minutes);
				int seconds = (int) gameLength - (wholeMinutes * 60);
				matchInfo.put(MatchAttribute.TIME, Integer.toString(wholeMinutes) + ":" + Integer.toString(seconds));

				matchInfo.put(MatchAttribute.MAP, replay.getMapName());

				matchInfo.put(MatchAttribute.LOSER_GG, "true");


				System.out.println("[PIZZAHUT] Filled Hashes, now to XML!");
				printXmlFile(playerInfo, matchInfo);
				System.out.println("[PIZZAHUT] I'M AT THE PIZZA HUT!");
			}
		} );
	}


	public void addToProfiles(String name, IProfile profile)
	{
		m_profiles.put(name, profile);
	}

	
	private boolean isProfileTimeout()
	{
		return (System.currentTimeMillis() - m_profileQueryTime) > PROFILE_WAIT_TIMEOUT;
	}


	/**
	 * Sets the OutputStream we send out New Replay data out of.
	 */
	public void setSocket(Socket out)
	{
		m_tacoBell = out;
	}

	public void setSocketListener(PizzaHutSocketListener listener)
	{
		m_listener = listener;
	}
	

	@Override
	public void destroy()
	{
		// Remove our new replay listener
		generalServices.getCallbackApi().removeNewReplayListener( m_newReplayListener );
		try
		{
			m_tacoBell.close();
		} catch (IOException e) { }
		m_listener.close();
		m_listener.stop();
		System.out.println("[PIZZAHUT] Destroyed!");
	}


	/**
	 * Print the game data to an XML file for TACOBELL to read/render.
	 */
	private void printXmlFile(ArrayList<HashMap<PlayerAttribute, String>> players, 
								HashMap<MatchAttribute,String> match)
	{
	  try {
			// root element
			Document doc = m_docBuilder.newDocument();
			Element rootElement = doc.createElement("replay");
			doc.appendChild(rootElement);

			Element playersElement = doc.createElement("players");
			
			for (int i = 0; i < players.size(); ++i)
			{
				HashMap<PlayerAttribute, String> player = players.get(i);

				Element playerElem = doc.createElement("player");

				Element nameElem = doc.createElement("name");
				String name = player.get(PlayerAttribute.NAME);
				nameElem.appendChild(doc.createTextNode(name));

				Element raceElem = doc.createElement("race");
				raceElem.appendChild(doc.createTextNode(player.get(PlayerAttribute.RACE)));

				Element apmElem = doc.createElement("apm");
				apmElem.appendChild(doc.createTextNode(player.get(PlayerAttribute.APM)));

				playerElem.appendChild(nameElem);
				playerElem.appendChild(raceElem);
				playerElem.appendChild(apmElem);

				// This next bit of douchery is safeguarding against the asynchronousness of 
				// profile fetching. Top-level while assures we stop after a timeout period.
				while (!isProfileTimeout())
				{
					// If we don't have the profiles, spin.
					if (m_profiles.size() == players.size())
					{
						Iterator<String> keys = m_profiles.keySet().iterator();
						while (keys.hasNext()) {
							String key = keys.next();
							if (key.equals(name))
							{
								try 
								{
									IProfile profile = m_profiles.get(key);
									System.out.println("Inside! profile==null -> " + (profile == null));
									String league = profile.getBestRanks()[0].getLeague().toString();
									player.put(PlayerAttribute.LEAGUE, league);
								}
								// Catch the Null Pointer, since it's not guaranteed all these chains lead to
								// valid objects!
								catch (NullPointerException ex)
								{
									System.err.println("Failed to retrieve data for " + name + ", better luck next time.");
									ex.printStackTrace();
								}
		
							}  // is this key match the player we're writing?
						} // is iterator empty
						break;

					} // to spin or not to spin.
				} //timeout check

				Element leagueElem = doc.createElement("league");
				leagueElem.appendChild(doc.createTextNode(player.get(PlayerAttribute.LEAGUE)));
				playerElem.appendChild(leagueElem);

				playersElement.appendChild(playerElem);
			}
			
			rootElement.appendChild(playersElement);

			// time, map, losergg
			Element mapElem = doc.createElement("map");

			Element mapNameElem = doc.createElement("name");
			mapNameElem.appendChild(doc.createTextNode(match.get(MatchAttribute.MAP)));
			mapElem.appendChild(mapNameElem);
			rootElement.appendChild(mapElem);

			Element timeElem = doc.createElement("time");
			timeElem.appendChild(doc.createTextNode(match.get(MatchAttribute.TIME)));
			rootElement.appendChild(timeElem);

			Element loserElem = doc.createElement("loser_gg");
			loserElem.appendChild(doc.createTextNode(match.get(MatchAttribute.LOSER_GG)));
			rootElement.appendChild(loserElem);
			
			// write the content into xml file
			DOMSource source = new DOMSource(doc);
			StringWriter writer = new StringWriter();
			StreamResult stringResult = new StreamResult(writer);
			m_transformer.transform(source, stringResult);

			communicateResults(stringResult.toString().length(), source);

			System.out.println("I'M AT THE PIZZA HUT");
		} 
		catch (TransformerException tfe)
		{
			tfe.printStackTrace();
		}
	}

	/**
	 * Informs the client (TACOBELL) how much data to read in the subsequent communication, in
	 * bytes.
	 */
	private void communicateResults(int length, DOMSource source)
	{
		try
		{
//			byte[] bLength = intToByteArray(length);
//			System.out.println("Length = " + length +", bLength = " + bLength);
			OutputStream out = m_tacoBell.getOutputStream();
			System.out.println("Got output stream");
			InputStream in = m_tacoBell.getInputStream();
			System.out.println("Got input stream");
		//	out.write(bLength);
		//	System.out.println("Wrote out data! Reading incoming...");
		//	int response = in.read();

		//	if (response != 0)
		//	{

			StreamResult byteResult = new StreamResult(out);
			m_transformer.transform(source, byteResult);

		//	}
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
	}


//	/**
//	 *  Y U NO C?!???
//	 */
//	private byte[] intToByteArray(int in)
//	{
//		return new byte[] {
//			(byte) (in >>> 24),
//			(byte) (in >>> 16),
//			(byte) (in >>> 8),
//			(byte) in};
//	}
}
