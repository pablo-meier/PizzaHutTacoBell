/*
 *  Copyright (c) 2011 Paul Meier
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

package com.morepaul.tacobell.data
{

	import com.morepaul.tacobell.TacoBellPluginMain;

	/**
	 * Reads the PIZZAHUT XML and creates data structure we can render from.
	 */
	public class TacoXmlParser
	{
		public function TacoXmlParser():void { super(); }

		public function parse( data : XML ):TacoReplayInfo
		{
			var players : XMLList = data.players;
			
			var playerArray : Array = new Array();

			for (var i : uint = 0; i < players.children().length(); ++i)
			{
				var this_player : XML = players.player[i];

				var nameStr : String = this_player.name.text();
				var leagueStr : String = this_player.league.text();
				var raceStr : String = this_player.race.text();

				var rank : uint = Number(this_player.rank.text());
				var apm : uint = Number(this_player.apm.text());

				var winner : Boolean = Boolean(this_player.winner.text());

				var playerData : TacoPlayer = new TacoPlayer();
				playerData.name = nameStr;
				playerData.race = raceStr;
				playerData.league = leagueStr;
				playerData.rank = rank;
				playerData.apm = apm;
				playerData.winner = winner;

				playerArray.push(playerData);
			}

			var mapName : String = data.map.name.text();
			var time : String = data.time.text();

			var loserGG : Boolean = Boolean(data.loser_gg.text());

			var matchData : TacoMatch = new TacoMatch();

			matchData.time = time;
			matchData.map = mapName;
			matchData.loserGG = loserGG;

			return new TacoReplayInfo(playerArray, matchData);
		}
	}
}
