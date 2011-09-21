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
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import com.demonsters.debugger.MonsterDebugger;

	import com.morepaul.tacobell.TacoBellPluginMain;

	/**
	 * Handles all the display logic.
	 */
	public class TacoRenderer extends DisplayObjectContainer
	{
		
		/** Our connection back to main! And the surface we draw on. */
		private var m_main : TacoBellPluginMain;

		/** Loads + stores all our images + video */
		private var m_media : TacoMediaManager;

		/** All text fields we render get placed here, so they can be replaced easily. */
		private var m_renderText : Array;
		 
		/** The default styling we use for all our text! */
		private var m_prettyFormat : TextFormat;

		private static const Y_INCREMENT : uint = 60;
		private static const Y_START : uint = 60;

		public function TacoRenderer():void
		{
			super();
			MonsterDebugger.initialize(this);

			m_media = new TacoMediaManager(this);

			drawBackground();
			setPrettiness()
		}


		/**
		 * Traverses the DOM and renders the relevant data to the stage as it does so.
		 */
		public function renderXmlData( xmlData : XML ):void
		{
			// Render the player data.
			var players : XMLList = xmlData.players.player;
			renderPlayers(players);

//			var halfway: uint = stage.stageWidth / 2;
//			var startX : uint = halfway / 2;
//			var incrementX : uint = startX;
//
//			var startY : uint = 0;
//
//		
//			// Render the match data.
//			var bottomLoc : uint = (stage.stageHeight - startY) - stage.stageHeight;
//
//			var mapName   : TextField = createPrettyTextField(xmlData.map.name.text());
//			var matchTime : TextField = createPrettyTextField(xmlData.time.text());
//			var loserGG   : TextField = createPrettyTextField(xmlData.loser_gg.text());
//
//			addChild(mapName);
//			addChild(matchTime);
//			addChild(loserGG);
//
//			mapName.x = halfway / 2;
//			matchTime.x = halfway / 2;
//			loserGG.x = halfway / 2;
//
//			mapName.y = bottomLoc + 10;
//			matchTime.y = bottomLoc + 30;
//			loserGG.y = bottomLoc + 50;
		}


		public function renderPlayers( players : XMLList ):void
		{
			println("called renderPlayers!");
			var xIncrementValue : uint = (stage.stageWidth / players.length());

			var rightBoundary : uint = xIncrementValue;
			var leftBoundary : uint = 0;

			var yValue : uint = Y_START;

			for (var i:int = 0; i < players.length(); ++i)
			{

				println("Entered loop for index " + i);
				// Define the boundaries of the column...
				var colIncrement : uint = (rightBoundary - leftBoundary) / 4;
				var xCol1 : uint = leftBoundary + colIncrement;
				var xCol2 : uint = leftBoundary + (2 * colIncrement);
				var xCol3 : uint = leftBoundary + (3 * colIncrement);

				println("LeftBoundary is " + leftBoundary + ", right is " + rightBoundary);
//				var nameStr   : String = players.player[i].name.text();
//				var leagueStr : String = players.player[i].league.text();
//				var raceStr : String = players.player[i].race.text();
//				var rankStr : String = players.player[i].rank.text();

				// fetch the data...
				var nameStr   : String = "SrPablo";
				var leagueStr : String = "DIAMOND";
				var raceStr : String = "Zerg";
				var rankStr : String = "24";

				
				println("trying to load images");
				var raceImg : Bitmap = m_media.race(raceStr);
				var nameTF : TextField = createPrettyTextField(nameStr);
				var leagueImg : Bitmap = m_media.league(leagueStr, rankStr);
				println("Loaded!");

				// place the name row...
				raceImg.x   = xCol1 - (raceImg.width / 2);
				nameTF.x    = xCol2 - (nameTF.width / 2);
				leagueImg.x = xCol3 - (raceImg.width / 2 );

				raceImg.y   = yValue;
				nameTF.y    = yValue;
				leagueImg.y = yValue;

				addChild(raceImg);
				addChild(nameTF);
				addChild(leagueImg);

				println("Added nameTF at (" + nameTF.x + ", " + nameTF.y + ") with text " + nameTF.text);

				yValue += Y_INCREMENT;

				// Place the APM -- 
//				var apmStr : String = players.player[i].apm.text();
				var apmStr : String = "150";

				var apmTF : TextField = createPrettyTextField(apmStr);

				apmTF.x = xCol2 - (apmTF.width / 2);
				apmTF.y = yValue;

				addChild(apmTF);

				leftBoundary += xIncrementValue;
				rightBoundary += xIncrementValue;
			}
		}


		public function setPrettiness():void
		{
			m_prettyFormat = new TextFormat();
			m_prettyFormat.align = TextFormatAlign.CENTER;
			m_prettyFormat.bold = true;
			m_prettyFormat.color = 0x6BF8FF;
			m_prettyFormat.font = "Arial";
			m_prettyFormat.size = 16;
		}


		public function drawBackground():void
		{
			var background : Shape = new Shape();
			background.graphics.lineStyle();
			background.graphics.beginFill(0x4036FF);
			background.graphics.drawRect(0,0, stage.stageWidth, stage.stageHeight);
			background.graphics.endFill();
			addChild(background);
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

		private function println(str:String):void
		{
			MonsterDebugger.trace(this, str);
		}
	}
}
