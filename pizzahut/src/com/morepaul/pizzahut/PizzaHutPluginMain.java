/* * Copyright (c) 2011 Paul Meier
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

import hu.belicza.andras.sc2gearspluginapi.Configurable;
import hu.belicza.andras.sc2gearspluginapi.GeneralServices;
import hu.belicza.andras.sc2gearspluginapi.PluginDescriptor;
import hu.belicza.andras.sc2gearspluginapi.PluginServices;
import hu.belicza.andras.sc2gearspluginapi.SettingsControl;
import hu.belicza.andras.sc2gearspluginapi.api.LanguageApi;
import hu.belicza.andras.sc2gearspluginapi.api.ProfileApi;
import hu.belicza.andras.sc2gearspluginapi.api.ReplayUtilsApi;
import hu.belicza.andras.sc2gearspluginapi.api.SettingsApi;
import hu.belicza.andras.sc2gearspluginapi.api.listener.ProfileListener;
import hu.belicza.andras.sc2gearspluginapi.api.listener.NewReplayListener;
import hu.belicza.andras.sc2gearspluginapi.api.profile.IProfile;
import hu.belicza.andras.sc2gearspluginapi.api.sc2replay.IPlayer;
import hu.belicza.andras.sc2gearspluginapi.api.sc2replay.IPlayerId;
import hu.belicza.andras.sc2gearspluginapi.api.sc2replay.IReplay;
import hu.belicza.andras.sc2gearspluginapi.impl.BasePlugin;
import hu.belicza.andras.sc2gearspluginapi.impl.BaseSettingsControl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Iterator;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

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

	/** The port we listen to for a connection. */
	private static final int PORT = 8080;

	/** Our writer to write out the XML data. */
	private OutputStream m_tacoBellOut;
	
	/** Reference to our new replay listener.     */
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

	/** Attributes we display for each player. */
	private enum PlayerAttribute 
	{
		NAME,
		RACE,
		LEAGUE,
		APM,
		AVG_INCOME,
		WORKERS_BUILT,
		RESOURCES_GATHERED,
		RESOURCES_SPENT,
		UNITS_CREATED,
		UNITS_LOST
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
		
		m_replayUtils = generalServices.getReplayUtilsApi();
		m_profileApi = generalServices.getProfileApi();
		m_profiles = new HashMap<String, IProfile>();

		Socket tacobell = establishConnection();
		try
		{
			m_tacoBellOut = tacobell.getOutputStream();
		}
		catch (IOException e)
		{
			System.err.println("Couldn't get the socket's Outputstream.");
			e.printStackTrace();
			System.exit(-1);
		}

		System.out.println("[PIZZAHUT] initing!");
		try
		{
			// Initialize your XML components.
			m_docFactory = DocumentBuilderFactory.newInstance();
			m_docBuilder = m_docFactory.newDocumentBuilder();
		}
		catch (ParserConfigurationException pce)
		{
			pce.printStackTrace();
		} 
	
		// Register a new replay listener
		generalServices.getCallbackApi().addNewReplayListener( m_newReplayListener = new NewReplayListener() {
			@Override
			public void newReplayDetected( final File replayFile ) {
				m_profiles.clear();

				// Cached info is enough for us: we acquire replay with ReplayFactory.getReplay()
				final IReplay replay = generalServices.getReplayFactoryApi().getReplay( replayFile.getAbsolutePath(), null );
				if ( replay == null )
				{
					return; // Failed to parse replay
				}
				System.out.println("[PIZZAHUT] Got replay!");

				IPlayer[] players = replay.getPlayers();
//				for (int i = 0; i < players.length; ++i)
//				{
//					final IPlayerId id = players[i].getPlayerId();
//					final String name = id.getName();
//					m_profileApi.queryProfile(id,
//											new ProfileListener() {
//												@Override
//												public void profileReady(IProfile profile, boolean isAnotherRetrievingInProgress)
//												{
//													m_profiles.put(name, profile);
//												}
//											},
//											false,
//											false);
//				}
				int numPlayers = players.length;

				int gameLength = replay.getGameLengthSec();
				double minutes = gameLength / 60;
	
				System.out.println("numPlayers is "+numPlayers);
				ArrayList<HashMap<PlayerAttribute, String>> playerInfo = new ArrayList<HashMap<PlayerAttribute,String>>(numPlayers);

				for (int i = 0; i < numPlayers; ++i)
				{
					HashMap<PlayerAttribute, String> thisSet = new HashMap<PlayerAttribute, String>();
					thisSet.put(PlayerAttribute.NAME, players[i].getPlayerId().getName());
					thisSet.put(PlayerAttribute.RACE, players[i].getRaceString());

					int apm = m_replayUtils.calculatePlayerApm(replay, players[i]);
					thisSet.put(PlayerAttribute.APM, Integer.toString(apm));

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
	

	@Override
	public void destroy()
	{
		// Remove our new replay listener
		generalServices.getCallbackApi().removeNewReplayListener( m_newReplayListener );
	}


	/**
	 * Print the game data to an XML file for TACOBELL to read/render.
	 */
	private void printXmlFile(ArrayList<HashMap<PlayerAttribute, String>> players, HashMap<MatchAttribute,String> match)
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

//				// This next bit of douchery is safeguarding against the asynchronousness of 
//				// profile. Better to spin on containsKey?
//				Iterator<String> keys = m_profiles.keySet().iterator();
//				while (keys.hasNext()) {
//					String key = keys.next();
//					if (key.equals(name))
//					{
//						try 
//						{
//							IProfile profile = m_profiles.get(key);
//							Element leagueElem = doc.createElement("league");
//							String league = profile.getAllRankss()[0][0].getLeague().bnetString;
//							leagueElem.appendChild(doc.createTextNode(league));
//							playerElem.appendChild(leagueElem);
//						}
//						// Catch the Null Pointer, since it's not guaranteed all these chains lead to
//						// valid objects!
//						catch (NullPointerException ex)
//						{
//							System.err.println("Failed to retrieve data for " + name + ", better luck next time.");
//							ex.printStackTrace();
//						}
//
//					}
//				}

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
			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			DOMSource source = new DOMSource(doc);
			StreamResult result = new StreamResult(m_tacoBellOut);
			
			// Output to console for testing
			// StreamResult result = new StreamResult(System.out);
			
			transformer.transform(source, result);
			System.out.println("I'M AT THE PIZZA HUT");
		} 
		catch (TransformerException tfe)
		{
			tfe.printStackTrace();
		}
	}


	/**
	 * Actually connect to the instance of TacoBell, on the hard-coded PORT. 
	 * Also, Java verbosity/compile-time-exception-asshattery for the win.
	 * @return a socket that speaks to TACOBELL.
	 */
	private Socket establishConnection()
	{
		ServerSocket server = null;
		Socket client = null;
		try
		{
			server = new ServerSocket(PORT);
		}
		catch (IOException e)
		{
			System.err.println("Unable to connect on port " + PORT);
			System.exit(-1);
		}

		try
		{
			client = server.accept();
			return client;
		}
		catch (IOException e)
		{
			System.err.println("Unable to accept incoming socket request.");
			System.exit(-1);
		}

		return client;
	}

}
