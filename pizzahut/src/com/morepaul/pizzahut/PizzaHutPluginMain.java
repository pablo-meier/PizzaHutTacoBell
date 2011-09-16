/*
 * Copyright (c) 2011 Paul Meier
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
import hu.belicza.andras.sc2gearspluginapi.api.SettingsApi;
import hu.belicza.andras.sc2gearspluginapi.api.listener.DiagnosticTestFactory;
import hu.belicza.andras.sc2gearspluginapi.api.listener.NewReplayListener;
import hu.belicza.andras.sc2gearspluginapi.api.sc2replay.IPlayer;
import hu.belicza.andras.sc2gearspluginapi.api.sc2replay.IReplay;
import hu.belicza.andras.sc2gearspluginapi.impl.BasePlugin;
import hu.belicza.andras.sc2gearspluginapi.impl.BaseSettingsControl;
import hu.belicza.andras.sc2gearspluginapi.impl.DiagnosticTest;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.ArrayList;
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
	
	/** Reference to our new replay listener.     */
	private NewReplayListener _newReplayListener;
	
	/** Reference to our diagnostic test factory. */
	private DiagnosticTestFactory _diagnosticTestFactory;

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
		
		// Register a diagnostic test to check the pre-conditions of this plugin:
		generalServices.getCallbackApi().addDiagnosticTestFactory( _diagnosticTestFactory = new DiagnosticTestFactory() {
			@Override
			public DiagnosticTest createDiagnosticTest() {
				return new DiagnosticTest( generalServices.getLanguageApi().getText( "tsovplugin.diagnosticTest.name" ) ) {
					@Override
					public void execute() {
						if ( !generalServices.getInfoApi().isReplayAutoSaveEnabled() ) {
							result  = Result.WARNING;
							details = generalServices.getLanguageApi().getText( "tsovplugin.diagnosticTest.warning.autoSaveDisabled" );
						}
						else {
							result  = Result.OK;
						}
					}
				};
			}
		} );
		
		// Register a new replay listener
		generalServices.getCallbackApi().addNewReplayListener( _newReplayListener = new NewReplayListener() {
			@Override
			public void newReplayDetected( final File replayFile ) {

				// Cached info is enough for us: we acquire replay with ReplayFactory.getReplay()
				final IReplay replay = generalServices.getReplayFactoryApi().getReplay( replayFile.getAbsolutePath(), null );
				if ( replay == null )
				{
					return; // Failed to parse replay
				}
				
				IPlayer[] players = replay.getPlayers();
				int numPlayers = players.length;
	
				ArrayList<HashMap<PlayerAttribute, String>> playerInfo = new ArrayList<HashMap<PlayerAttribute,String>>(numPlayers);

				for (int i = 0; i < playerInfo.size(); ++i)
				{
					HashMap<PlayerAttribute, String> thisSet = new HashMap<PlayerAttribute, String>();
					thisSet.put(PlayerAttribute.NAME, players[i].getPlayerId().getName());
					thisSet.put(PlayerAttribute.RACE, players[i].getRaceString());
					thisSet.put(PlayerAttribute.APM, "100");
					thisSet.put(PlayerAttribute.WORKERS_BUILT, "15");

					playerInfo.set(i, thisSet);
				}

				HashMap<MatchAttribute,String> matchInfo = new HashMap<MatchAttribute,String>();
				matchInfo.put(MatchAttribute.TIME, "15:06");
				matchInfo.put(MatchAttribute.MAP, "Shakuras Plateau");
				matchInfo.put(MatchAttribute.LOSER_GG, "false");

				printXmlFile(playerInfo, matchInfo);
			}
		} );
	}
	

	@Override
	public void destroy()
	{
		// Remove our diagnostic test factory
		generalServices.getCallbackApi().removeDiagnosticTestFactory( _diagnosticTestFactory );
		// Remove our new replay listener
		generalServices.getCallbackApi().removeNewReplayListener( _newReplayListener );
	}
	
	/**
	 * Checks if the string setting specified by its key is missing.
	 * A string setting is missing if its value is null or its length is zero.
	 * @param key key of the setting to check
	 * @return true if the setting specified by its key is missing; false otherwise
	 */
	private boolean isStringSettingMissing( final String key )
	{
		final String value = pluginServices.getSettingsApi().getString( key );
		return value == null || value.length() == 0;
	}


	/**
	 * Print the game data to an XML file for TACOBELL to read/render.
	 */
	private void printXmlFile(ArrayList<HashMap<PlayerAttribute, String>> players, HashMap<MatchAttribute,String> match)
	{
	  try {
			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();
			
			// root element
			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("replay");
			doc.appendChild(rootElement);

			Element playersElement = doc.createElement("players");
			
			for (int i = 0; i < players.size(); ++i)
			{
				HashMap<PlayerAttribute, String> player = players.get(i);

				Element playerElem = doc.createElement("player");

				Element nameElem = doc.createElement("name");
				nameElem.appendChild(doc.createTextNode(player.get(PlayerAttribute.NAME)));

				Element raceElem = doc.createElement("race");
				raceElem.appendChild(doc.createTextNode(player.get(PlayerAttribute.RACE)));

				Element apmElem = doc.createElement("apm");
				apmElem.appendChild(doc.createTextNode(player.get(PlayerAttribute.APM)));

				Element workersElem = doc.createElement("workersBuilt");
				workersElem.appendChild(doc.createTextNode(player.get(PlayerAttribute.WORKERS_BUILT)));

				playerElem.appendChild(nameElem);
				playerElem.appendChild(raceElem);
				playerElem.appendChild(apmElem);
				playerElem.appendChild(workersElem);

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
			StreamResult result = new StreamResult(new File(System.getProperty("user.home"), "PIZZAHUT.txt"));
			
			// Output to console for testing
			// StreamResult result = new StreamResult(System.out);
			
			transformer.transform(source, result);
			System.out.println("I'M AT THE PIZZA HUT");
		} 
		catch (ParserConfigurationException pce)
		{
			pce.printStackTrace();
		} 
		catch (TransformerException tfe)
		{
			tfe.printStackTrace();
		}
	}
}
