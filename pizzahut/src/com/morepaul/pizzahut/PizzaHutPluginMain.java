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

	/** When we requested the profiles. Used to calculate timeouts. */
	private long m_profileQueryTime;

	/** The port we listen to for a connection. */
	private static final int PORT = 8080;

	/** Our writer to write out the XML data. */
	private Socket m_tacoBell;
	
	/** Reference to our new replay listener.  */
	private PizzaHutNewReplayListener m_newReplayListener;
	
	/** XML tools. */
	private DocumentBuilderFactory m_docFactory; 
	private DocumentBuilder m_docBuilder; 

	/** Storage for fetched profiles. */
	private HashMap<String, IProfile> m_profiles;
	private int m_profile_count = 0;
	private boolean m_firedOff = false;

	/** Convert DOM to XML */
	private Transformer m_transformer;

	/** Write the length of the transmission with this writer. */
	private PrintWriter m_socketWriter;

	/** Manages our network connections. */
	private PizzaHutSocketListener m_listener;

	@Override
	public void init( final PluginDescriptor pluginDescriptor, final PluginServices pluginServices, final GeneralServices generalServices ) 
	{
		// Call the init() implementation of the BasePlugin:
		super.init( pluginDescriptor, pluginServices, generalServices );

		PizzaHutSocketListener listener = new PizzaHutSocketListener(this, PORT);
		listener.start();
		
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

		m_profiles = new HashMap<String, IProfile>();

		ReplayUtilsApi replayUtils = generalServices.getReplayUtilsApi();
		ProfileApi profileApi = generalServices.getProfileApi();
		m_newReplayListener = new PizzaHutNewReplayListener(this, replayUtils, profileApi, generalServices);
		generalServices.getCallbackApi().addNewReplayListener(m_newReplayListener);	
	}


	public void addToProfiles(String name, IProfile profile)
	{
		m_profiles.put(name, profile);
		++m_profile_count;
	}

	public void setProfileCount(int newCount)
	{
		m_profile_count = newCount;
	}
	
	public boolean lackingProfiles()
	{
		boolean expr = (m_profiles.size() < m_profile_count);
		System.out.println("Expr is evaluting to " + expr + ", with hashes at " + m_profiles.size() + " and m_profile_count at " + m_profile_count);
		return expr;
	}

	public boolean stillBeforeCallback()
	{
		return !m_firedOff;
	}



	public void setSocket(Socket out)
	{
		System.out.println("[PIZZAHUT] Socket set!");
		m_tacoBell = out;
	}

	public void setSocketListener(PizzaHutSocketListener listener)
	{
		m_listener = listener;
	}


	public void clearProfiles()
	{
		m_profiles.clear();
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
	public void printXmlFile(ArrayList<HashMap<PlayerAttribute, String>> players, 
								HashMap<MatchAttribute,String> match)
	{
		m_firedOff = true;
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

				String name = player.get(PlayerAttribute.NAME);
				addElementTo(doc, "name", name, playerElem);
				addElementTo(doc, "race", player.get(PlayerAttribute.RACE), playerElem);
				addElementTo(doc, "apm", player.get(PlayerAttribute.APM), playerElem);
				addElementTo(doc, "winner", player.get(PlayerAttribute.WINNER), playerElem);

				IProfile profile = m_profiles.get(name);
				try
				{
					if (profile != null)
					{
						String league = profile.getBestRanks()[0].getLeague().toString();
						player.put(PlayerAttribute.LEAGUE, league);
						int rank = profile.getBestRanks()[0].getDivisionRank();
						player.put(PlayerAttribute.RANK, Integer.toString(rank));
					}
				} 
				// Catch the Null Pointer, since it's not guaranteed all these chains lead to
				// valid objects!
				catch (NullPointerException ex)
				{
					System.err.println("Failed to retrieve data for " + name + ", better luck next time.");
					ex.printStackTrace();
				}

				addElementTo(doc, "league", player.get(PlayerAttribute.LEAGUE), playerElem);
				addElementTo(doc, "rank", player.get(PlayerAttribute.RANK), playerElem);

				playersElement.appendChild(playerElem);
			}
			
			rootElement.appendChild(playersElement);

			// time, map, losergg
			Element mapElem = doc.createElement("map");
			addElementTo(doc, "name", match.get(MatchAttribute.MAP), mapElem);
			rootElement.appendChild(mapElem);

			addElementTo(doc, "time", match.get(MatchAttribute.TIME), rootElement);
			addElementTo(doc, "loser_gg", match.get(MatchAttribute.LOSER_GG), rootElement);
			
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


	private void addElementTo(Document doc, String name, String value, Element parent)
	{
			Element newElement = doc.createElement(name);
			if ( value == null ) value = "EMPTY_NULL_NODE";
			newElement.appendChild(doc.createTextNode(value));
			parent.appendChild(newElement);
	}

	/**
	 * Informs the client (TACOBELL) how much data to read in the subsequent communication, in
	 * bytes.
	 */
	private void communicateResults(int length, DOMSource source)
	{
		try
		{
			OutputStream out = m_tacoBell.getOutputStream();
			InputStream in = m_tacoBell.getInputStream();

			StreamResult byteResult = new StreamResult(out);
			m_transformer.transform(source, byteResult);
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		m_firedOff = false;
		m_profile_count = 0;
		System.out.println("[PIZZAHUT] I'M AT THE PIZZA HUT!");
	}
}
