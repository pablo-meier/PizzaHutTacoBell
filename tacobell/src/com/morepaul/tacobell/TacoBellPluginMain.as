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

package com.morepaul.tacobell
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.xml.XMLNode;

	public class TacoBellPluginMain extends Sprite
	{
		/** Hard-coded LIKE A BAWS */
		private var PORT : int = 8080;

		/** All text fields we render get placed here, so they can be replaced easily. */
		private var m_renderText : Array;
		 
		/** The default styling we use for all our text! */
		private var m_prettyFormat : TextFormat;

		/** Where we debug since we don't have a damn stdout print. */
		private var m_debug : TextField;

		/** Our communication friend! */
		private var m_socket : TacoSocket;

		private var m_readingXml : Boolean;

		private var m_msgLength : int = 0;



		/**
		 * Initialize the stage.
		 */
		public function TacoBellPluginMain():void
		{
			super();
			stage.stageWidth = 300;
			stage.stageHeight = 500;

			drawBackground();
			setupDebug();
			setPrettiness()

			m_renderText = new Array();

			m_socket = new TacoSocket("localhost", PORT, this);
		} 



		/**
		 * 	While the major use case of our data is coming through the socket, this is 
		 * used for testing, etc.
		 */
		private function renderFile(filename : String):void
		{
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, onFileReadComplete, false, 0, true);
			xmlLoader.load(new URLRequest(filename));
		}

		private function onFileReadComplete(evt : Event):void
		{
			renderXmlData(new XML(evt.target.data));
		}



		/**
		 * Traverses the DOM and renders the relevant data to the stage as it does so.
		 */
		public function renderXmlData(xmlData : XML):void
		{
			// Render the player data.
			var players : XMLList = xmlData.players.player;

			var halfway: uint = stage.stageWidth / 2;
			var startX : uint = halfway / 2;
			var incrementX : uint = startX;

			var startY : uint = 0;

			for (var i:int = 0; i < players.length(); ++i)
			{
				startY = (stage.stageHeight / 2) / 2;
				var incrementY : uint = startY;

				var nameStr   : String = xmlData.players.player[i].name.text();
				var apmStr    : String = xmlData.players.player[i].apm.text();
				var workerStr : String = xmlData.players.player[i].workersBuilt.text();

				var playerName    : TextField = createPrettyTextField(nameStr);
				var playerApm     : TextField = createPrettyTextField(apmStr);
				var playerWorkers : TextField = createPrettyTextField(workerStr);

				playerName.x = startX;
				playerApm.x = startX;
				playerWorkers.x = startX;

				playerName.y = startY;
				startY += incrementY;

				playerApm.y = startY;
				startY += incrementY;

				playerWorkers.y = startY;
				startY += incrementY;

				this.addChild(playerName);
				this.addChild(playerApm);
				this.addChild(playerWorkers);

				startX += incrementX;
			}
			
			// Render the match data.
			var bottomLoc : uint = (stage.stageHeight - startY) - stage.stageHeight;

			var mapName   : TextField = createPrettyTextField(xmlData.map.name.text());
			var matchTime : TextField = createPrettyTextField(xmlData.time.text());
			var loserGG   : TextField = createPrettyTextField(xmlData.loser_gg.text());

			this.addChild(mapName);
			this.addChild(matchTime);
			this.addChild(loserGG);

			mapName.x = halfway / 2;
			matchTime.x = halfway / 2;
			loserGG.x = halfway / 2;

			mapName.y = bottomLoc + 10;
			matchTime.y = bottomLoc + 30;
			loserGG.y = bottomLoc + 50;
		}


        public function debug(str : String):void
        {
			m_debug.text = str;
        }


		public function drawBackground():void
		{
			var background : Shape = new Shape();
			background.graphics.lineStyle();
			background.graphics.beginFill(0x4036FF);
			background.graphics.drawRect(0,0, stage.stageWidth, stage.stageHeight);
			background.graphics.endFill();
			this.addChild(background);
		}



		public function setupDebug():void
		{
			m_debug = new TextField();
			m_debug.text = "Debug lolololololol";
			this.addChild(m_debug);
			m_debug.x = (stage.stageWidth / 2 ) - (m_debug.width / 2);
			m_debug.y = (stage.stageHeight / 2 ) - (m_debug.height / 2);
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


		/** 
		 * Makes a new TextField the way we want it! Initializes styles, sets contents, etc.
		 */
		private function createPrettyTextField(contents : String):TextField
		{
			var tf : TextField = new TextField();

			tf.text = contents;
			tf.setTextFormat(m_prettyFormat);

			tf.antiAliasType = AntiAliasType.ADVANCED;

			return tf;
		}
	}
}
