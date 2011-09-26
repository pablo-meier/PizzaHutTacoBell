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

package com.morepaul.tacobell.display
{

	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import com.morepaul.tacobell.data.TacoMatch;
	import com.morepaul.tacobell.data.TacoPlayer;
	import com.morepaul.tacobell.TacoBellPluginMain;

	public class TacoPlayerTable extends Sprite
	{
		private static const Y_INCREMENT : Number = 60;
		private static const Y_START : Number = 20;

		private static const BG_COLOR : uint = 0x4036FF;
		private static const WINNER_COLOR : uint = 0x5147FF;
		private static const DIVIDER_COLOR : uint = 0x00FF00;
		private static const DIVIDER_THICKNESS : uint = 10;

		private var m_media : TacoMediaManager;
		private var m_prettyFormat : TextFormat;
		private var m_background : Shape;
		private var m_dividers : Shape;

		private var m_main : TacoBellPluginMain;
		private var m_table_debug : TextField;

		public function TacoPlayerTable(m : TacoBellPluginMain):void
		{ 
			super(); 
			
			m_background = new Shape();
			this.addChild(m_background);
			m_dividers = new Shape();
			this.addChild(m_dividers);

			m_main = m;

			m_table_debug = new TextField();
			m_table_debug.text = "";
			addChild(m_table_debug);

			m_prettyFormat = new TextFormat();
			m_prettyFormat.align = TextFormatAlign.CENTER;
			m_prettyFormat.bold = true;
			m_prettyFormat.color = 0x6BF8FF;
			m_prettyFormat.font = "Arial";
			m_prettyFormat.size = 24;
		}

		public function set media( m : TacoMediaManager ):void
		{ 
			m_media = m;
		}


		public function positionElements():void
		{
			m_background.graphics.lineStyle();
			m_background.graphics.beginFill(BG_COLOR);
			m_main.debug("[PlayerTable] width = " + this.width + ", height = " + this.height);

			var width_sandbox : Number = this.width;
			var height_sandbox : Number = this.height;

			m_background.graphics.drawRect(0,0, width_sandbox, height_sandbox);

			this.width = width_sandbox;
			this.height = height_sandbox;
			m_main.debug("[PlayerTable] width = " + this.width + ", height = " + this.height);

			m_table_debug.x = (width / 2) - (m_table_debug.width / 2);
			m_table_debug.y = 0;
			addChild(m_table_debug);
		}


		/**
		 * The main functionality, displays a table presenting all the 
		 * player-specific data of a match. Sc2Gears only really gives us
		 * apm, race, and usually league.  Maybe we can include portraits?
		 */
		public function display( players : Array ):void
		{
			positionElements();
			m_main.debug("Called PositionElements!");

			var numCols : Number = players.length;
			var colWidth : Number = (this.width / numCols);

			var leftColBoundary : Number = 0;
			var rightColBoundary : Number = colWidth;

			m_main.debug("[PlayerTable] x =  " + this.x + ", y = " + this.y);
			m_main.debug("[PlayerTable] numCols = " + numCols + ", colWidth = " + colWidth );
			m_main.debug("[PlayerTable] rightColBoundary = " + rightColBoundary + ", leftColBoundary = " + leftColBoundary);
			for (var i:int = 0; i < players.length; ++i)
			{
				var yValue : Number = Y_START;

				var thisPlayer : TacoPlayer = players[i];

				// Define the boundaries of the column...
				var colIncrement : Number = (rightColBoundary - leftColBoundary) / 4;
				var xCol1 : Number = leftColBoundary + colIncrement;
				var xCol2 : Number = leftColBoundary + (2 * colIncrement);
				var xCol3 : Number = leftColBoundary + (3 * colIncrement);

				// Draw the boundary lines, if necessary

				if ( i != (players.length - 1) )
				{
					m_dividers.graphics.moveTo(rightColBoundary, 0);
					m_dividers.graphics.lineStyle(DIVIDER_THICKNESS, DIVIDER_COLOR);
					m_dividers.graphics.lineTo(rightColBoundary, this.y + this.height);
					this.addChild(m_dividers);
				}
				if ( thisPlayer.winner )
				{
					var winnerBack : Shape = new Shape();
					winnerBack.graphics.moveTo(0,0);
					winnerBack.graphics.lineStyle();
					winnerBack.graphics.beginFill(WINNER_COLOR);
					winnerBack.graphics.drawRect(leftColBoundary,0, rightColBoundary - leftColBoundary, this.height);
					this.addChild(winnerBack);
				}

				var nameStr   : String = thisPlayer.name;
				var leagueStr : String = thisPlayer.league;
				var raceStr : String = thisPlayer.race;
				var rank : Number = thisPlayer.rank;

				var raceImg : Bitmap = m_media.race(raceStr);
				var nameTF : TextField = createPrettyTextField(nameStr);
				var leagueImg : Bitmap = m_media.league(leagueStr, rank);

				addChild(raceImg);
				addChild(nameTF);
				addChild(leagueImg);

				raceImg.width = 20;
				raceImg.height = 20;

				leagueImg.width = 20;
				leagueImg.height = 20;

				// place the name row...
				raceImg.x   = xCol1 - (raceImg.width / 2);
				nameTF.x    = xCol2 - (nameTF.width / 2);
				leagueImg.x = xCol3 - (raceImg.width / 2 );

				raceImg.y   = yValue;
				nameTF.y    = yValue;
				leagueImg.y = yValue;


				yValue += Y_INCREMENT;

				// Place the APM -- 
				var apmStr : String = thisPlayer.apm.toString();

				var apmTF : TextField = createPrettyTextField(apmStr);

				apmTF.x = xCol2 - (apmTF.width / 2);
				apmTF.y = yValue;

				addChild(apmTF);

				leftColBoundary += colWidth;
				rightColBoundary += colWidth;
			}

			var yStop : Number = Y_START + (Y_INCREMENT - Y_START);
			m_dividers.graphics.moveTo(0,yStop);
			m_dividers.graphics.lineStyle(DIVIDER_THICKNESS, DIVIDER_COLOR);
			m_dividers.graphics.lineTo(this.x + this.width, yStop);
			this.addChild(m_dividers);
		}


		/** 
		 * Makes a new TextField the way we want it! Initializes styles, sets contents, etc.
		 */
		private function createPrettyTextField( contents : String ):TextField
		{
			var tf : TextField = new TextField();

			tf.text = contents;
			tf.setTextFormat(m_prettyFormat);

			tf.antiAliasType = AntiAliasType.ADVANCED;

			return tf;
		}
	}
}
