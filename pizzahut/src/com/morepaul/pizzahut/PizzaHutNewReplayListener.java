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
import java.util.*;
import java.util.regex.*;

public class PizzaHutNewReplayListener implements NewReplayListener
{
	/** Kickback to Main. */
	private PizzaHutPluginMain m_main;

	/** Sc2Gears-provided magic sauce. */
	private ReplayUtilsApi m_replayUtils;
	private ProfileApi m_profileApi;
	private GeneralServices m_generalServices;
	private Pattern m_winnerSplitterPattern;


	public PizzaHutNewReplayListener(PizzaHutPluginMain main,
									ReplayUtilsApi replayUtils,
									ProfileApi profileApi,
									GeneralServices generalServices)
	{
		m_main = main;

		m_replayUtils = replayUtils;
		m_profileApi = profileApi;
		m_generalServices = generalServices;

		m_winnerSplitterPattern = Pattern.compile("([^,]+)");
	}

	@Override
	public void newReplayDetected( final File replayFile ) {

		// Start with a clean slate.
		m_main.clearProfiles();

		// Cached info is enough for us: we acquire replay with ReplayFactory.getReplay()
		final IReplay replay = m_generalServices.getReplayFactoryApi().getReplay( replayFile.getAbsolutePath(), null );
		if ( replay == null )
		{
			return; // Failed to parse replay
		}
		System.out.println("[PIZZAHUT] Got replay!");

		IPlayer[] players = replay.getPlayers();

		String winners = replay.getWinnerNames();
		Matcher winMatcher = m_winnerSplitterPattern.matcher(winners);
		winMatcher.matches();

		// Search for profiles!
		for (int i = 0; i < players.length; ++i)
		{
			final IPlayerId id = players[i].getPlayerId();
			final String name = id.getName();
			m_profileApi.queryProfile(id, new PizzaHutProfileGetter(m_main, name), false, false);
		}

		m_main.setTimeoutStart(System.currentTimeMillis());
		int numPlayers = players.length;

		ArrayList<HashMap<PlayerAttribute, String>> playerInfo = new ArrayList<HashMap<PlayerAttribute,String>>(numPlayers);

		for (int i = 0; i < numPlayers; ++i)
		{
			String playerName = players[i].getPlayerId().getName();

			HashMap<PlayerAttribute, String> thisSet = new HashMap<PlayerAttribute, String>();
			thisSet.put(PlayerAttribute.NAME, playerName);
			thisSet.put(PlayerAttribute.RACE, players[i].getRaceString());

			int apm = m_replayUtils.calculatePlayerApm(replay, players[i]);
			thisSet.put(PlayerAttribute.APM, Integer.toString(apm));
			thisSet.put(PlayerAttribute.LEAGUE, "UNKNOWN");
			thisSet.put(PlayerAttribute.RANK, "UNKNOWN");
			thisSet.put(PlayerAttribute.WINNER, "false");

			for ( int p = 1; p <= winMatcher.groupCount(); ++p)
			{
				if ( playerName.equals(winMatcher.group(p)) )
				{
					thisSet.put(PlayerAttribute.WINNER, "true");
				}
			}

			playerInfo.add(i, thisSet);
		}

		HashMap<MatchAttribute,String> matchInfo = new HashMap<MatchAttribute,String>();

		int gameLength = replay.getGameLengthSec();
		double minutes = gameLength / 60;
		int wholeMinutes = (int) Math.floor(minutes);
		String seconds = Integer.toString((int) gameLength - (wholeMinutes * 60));
		if (seconds.length() == 1)
			seconds = "0" + seconds;

		matchInfo.put(MatchAttribute.TIME, Integer.toString(wholeMinutes) + ":" + seconds);
		matchInfo.put(MatchAttribute.MAP, replay.getMapName());
		matchInfo.put(MatchAttribute.LOSER_GG, "true");

		System.out.println("[PIZZAHUT] Filled Hashes, now to XML!");
		m_main.printXmlFile(playerInfo, matchInfo);
		System.out.println("[PIZZAHUT] I'M AT THE PIZZA HUT!");
	}
} 
