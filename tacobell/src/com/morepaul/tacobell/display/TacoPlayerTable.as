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

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;

	import com.morepaul.tacobell.data.*;
	import com.morepaul.tacobell.TacoBellPluginMain;

	public class TacoPlayerTable extends Sprite
	{
		private static const BG_COLOR : uint = 0xd88888;
		private static const WINNER_COLOR : uint = 0xffb2b2;

		private static const DIVIDER_COLOR : uint = 0x350b0b;
		private static const DIVIDER_THICKNESS : uint = 10;
		private static const DEFAULT_TF_SIZE : uint = 24

		private static const TEXT_COLOR : uint = 0x501818;

		private var m_media : TacoMediaManager;
		private var m_prettyFormat : TextFormat;
		private var m_background : Shape;
		private var m_dividers : Shape;

		private var m_players : Array;

		private var m_main : TacoBellPluginMain;
		private var m_placeholder : TextField;

		public function TacoPlayerTable(m : TacoBellPluginMain):void
		{ 
			super(); 
			
			m_players = new Array();

			m_background = new Shape();
			safelyAddToStage(m_background);
			m_dividers = new Shape();
			safelyAddToStage(m_dividers);

			m_main = m;

			m_placeholder = new TextField();
			m_placeholder.text = "Awaiting Match!";
			safelyAddToStage(m_placeholder);

			m_prettyFormat = new TextFormat();
			m_prettyFormat.align = TextFormatAlign.CENTER;
			m_prettyFormat.bold = true;
			m_prettyFormat.color = TEXT_COLOR;
			m_prettyFormat.font = "Arial";
			m_prettyFormat.size = DEFAULT_TF_SIZE;

			this.addEventListener(Event.ADDED_TO_STAGE, addedListener);
		}

		private function addedListener(e:Event):void
		{
			this.drawBackground();
			m_placeholder.x = (this.width / 2) - (m_placeholder.width / 2);
			m_placeholder.y = (this.height / 2) - (m_placeholder.height / 2);
		}

		public function set media( m : TacoMediaManager ):void
		{ 
			m_media = m;
		}

		public function resize():void
		{
			draw(m_players);
		}


		private function drawBackground():void
		{
			m_background.graphics.lineStyle();
			m_background.graphics.beginFill(BG_COLOR);

			var width_sandbox : Number = this.width;
			var height_sandbox : Number = this.height;

			m_background.graphics.drawRect(0,0, width_sandbox, height_sandbox);

			this.width = width_sandbox;
			this.height = height_sandbox;

			m_placeholder.x = (width / 2) - (m_placeholder.width / 2);
			m_placeholder.y = 0;
			safelyAddToStage(m_placeholder);
		}


		public function display( players : Array ):void
		{
			m_players = players;
			draw(players);
		}


		/**
		 * The main functionality, displays a table presenting all the 
		 * player-specific data of a match. Sc2Gears only really gives us
		 * apm, race, and usually league.  Maybe we can include portraits?
		 */
		private function draw( players : Array ):void
		{
			this.drawBackground();

			var numCols : Number = players.length;
			var colWidth : Number = (this.width / numCols);

			var leftColBoundary : Number = 0;
			var rightColBoundary : Number = colWidth;

			var yStart : Number = (this.height / (TacoPlayer.NUM_ROWS * 2));
			var yIncrement : Number = this.height / TacoPlayer.NUM_ROWS;
			
			m_main.debug("w = " + this.width + ", h = " + this.height);

			for (var i:int = 0; i < players.length; ++i)
			{
				var yValue : Number = yStart;

				var thisPlayer : TacoPlayer = players[i];

				var xColMid : Number = ((rightColBoundary - leftColBoundary) / 2) + leftColBoundary; 

				// Draw the boundary lines, if necessary

				if ( i != (players.length - 1) )
				{
					m_dividers.graphics.moveTo(rightColBoundary, 0);
					m_dividers.graphics.lineStyle(DIVIDER_THICKNESS, DIVIDER_COLOR, 1.0, false, 
													LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
					m_dividers.graphics.lineTo(rightColBoundary, this.y + this.height);
					safelyAddToStage(m_dividers);
				}
				var bg_color : uint = thisPlayer.winner ? WINNER_COLOR : BG_COLOR;
				var colBack : Shape = new Shape();
				colBack.graphics.moveTo(0,0);
				colBack.graphics.lineStyle();
				colBack.graphics.beginFill(bg_color);
				colBack.graphics.drawRect(leftColBoundary,0, rightColBoundary - leftColBoundary, this.height);
				safelyAddToStage(colBack);

				var nameStr   : String = thisPlayer.name;
				var leagueStr : String = thisPlayer.league;
				var raceStr : String = thisPlayer.race;
				var rank : Number = thisPlayer.rank;

				var raceImg : Bitmap = m_media.race(raceStr);
				var nameTF : TextField = createPrettyTextField(nameStr);
				var leagueImg : Bitmap = m_media.league(leagueStr, rank);

				scaleOnY(raceImg, yValue);
				raceImg.x = xColMid - raceImg.width;
				raceImg.y = 0;
				safelyAddToStage(raceImg);

				scaleOnY(leagueImg, yValue);
				leagueImg.x = xColMid;
				leagueImg.y = 0;
				safelyAddToStage(leagueImg);

				var yDivider : Number = yValue / 2;
				scaleTextField(nameTF, yValue + yDivider, yValue);
				nameTF.x = xColMid - (nameTF.width / 2);
				nameTF.y = yValue + yDivider - (nameTF.height / 2);
				safelyAddToStage(nameTF);


				yValue += yIncrement;

				// Place the APM -- 
				var apmStr : String = thisPlayer.apm.toString();
				var apmTF : TextField = createPrettyTextField(apmStr);
				scaleTextField(apmTF, yValue, yValue - yStart);

				apmTF.x = xColMid - (apmTF.width / 2);
				apmTF.y = yValue - (apmTF.height / 2);

				safelyAddToStage(apmTF);

				leftColBoundary += colWidth;
				rightColBoundary += colWidth;
			}
			m_main.debug("w = " + this.width + ", h = " + this.height);

			// Draw the divider between the player names and Stats
			var yStop : Number = this.height / TacoPlayer.NUM_ROWS;
			m_dividers.graphics.moveTo(0,yStop);
			m_dividers.graphics.lineStyle(DIVIDER_THICKNESS, DIVIDER_COLOR, 1.0, false, 
											LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);
			m_dividers.graphics.lineTo(this.x + this.width, yStop);
			safelyAddToStage(m_dividers);

			// APM Label
			var apmLabelTF : TextField = createPrettyTextField("APM");
			var xVal : Number = (this.width / 2) - (apmLabelTF.width / 2);
			var yVal : Number = yStop + (yStop / 2) - (apmLabelTF.height / 2);
			apmLabelTF.x = xVal;
			apmLabelTF.y = yVal;
			apmLabelTF.opaqueBackground = DIVIDER_COLOR;
			apmLabelTF.textColor = WINNER_COLOR;
			safelyAddToStage(apmLabelTF);
		}


		private function scaleOnY( img : Bitmap, target : Number ):void
		{
			var scaleValue : Number = target / img.height;

			img.width  *= scaleValue;
			img.height *= scaleValue;
		}



		private function scaleTextField( tf : TextField, startY : Number, topWall : Number ):void
		{
			var optimistic : Number = startY - topWall;
			m_prettyFormat.size = optimistic;
			tf.setTextFormat(m_prettyFormat);
			while (startY - (tf.height / 2) < topWall)
			{
				optimistic -= 4;
				m_prettyFormat.size = optimistic;
				tf.setTextFormat(m_prettyFormat);
			}
			m_prettyFormat.size = DEFAULT_TF_SIZE;
		}


		/** 
		 * Makes a new TextField the way we want it! Initializes styles, sets contents, etc.
		 */
		private function createPrettyTextField( contents : String ):TextField
		{
			var tf : TextField = new TextField();

			tf.text = contents;
			tf.setTextFormat(m_prettyFormat);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.antiAliasType = AntiAliasType.ADVANCED;

			return tf;
		}

		/**
		 * ANTIPATTERN FLASH Y U NO PRESERVE WIDTH + HEIGHT WHEN ADDING?!?!?
		 */
		private function safelyAddToStage( d:DisplayObject ):void
		{
			var width_sandbox : Number = this.width;
			var height_sandbox : Number = this.height;

			this.addChild(d);

			this.width = width_sandbox;
			this.height = height_sandbox;
		}

		/**
		 * Clears the table of any data, separators, etc. To be done before we load
		 * replays...
		 */
		public function clear():void
		{
			while ( this.numChildren > 0 )
			{
				removeChildAt(0);
			}
			// the old ones would still be drawn...
			m_dividers = new Shape();
			safelyAddToStage(m_placeholder);
		}
	}
}
