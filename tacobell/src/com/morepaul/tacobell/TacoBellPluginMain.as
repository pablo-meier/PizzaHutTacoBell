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
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.text.*;

	import com.morepaul.tacobell.display.*;
	import com.morepaul.tacobell.net.*;
	import com.morepaul.tacobell.data.*;
	import com.morepaul.tacobell.file.*;



	public class TacoBellPluginMain extends Sprite
	{
		private static const BG_COLOR : uint = 0x350b0b;
		
		/** Hard-coded LIKE A BAWS */
		private var PORT : int = 8080;

		/** Our communication friend! */
		private var m_socket : TacoSocket;

		/** Our filesystem friend! */
		private var m_fileLoader : TacoFileLoader;

		/** Yo fuck this guy... */
		private var m_xmlParser : TacoXmlParser;

		/** Loads + stores all our images + video */
		private var m_media : TacoMediaManager;

		/** Graphical components. */
		private var m_placard : TacoMatchPlacard;
		private var m_animation: TacoMatchEndAnimation;
		private var m_table: TacoPlayerTable;

		private var m_debug : TextField;
		private var m_bg : Shape;

		/** For XSplit communication. */
		private var m_localConn : LocalConnection;

		/**
		 * Initialize the stage.
		 */
		public function TacoBellPluginMain():void
		{
			super();
			if (stage != null)
			{
				addedToStageListener();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, addedToStageListener);
			}
		}


		private function addedToStageListener(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageListener);

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			stage.addEventListener(Event.RESIZE, resizeListener);

			createExternalCalls();


			m_xmlParser = new TacoXmlParser();
			m_fileLoader = new TacoFileLoader(this);
			m_socket = new TacoSocket(this);

			m_debug = new TextField();
			m_debug.text = "TacoBell --- CHALUPA LOADED!";
			addChild(m_debug);

			debug("[TacoBellPluginMain]: Constructor.  stage width is " + stage.stageWidth + ", height is " + stage.stageHeight);

			m_bg = new Shape();
			m_media = new TacoMediaManager();
		
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			m_debug.x = (stage.stageWidth / 2) - (m_debug.width / 2);
			m_debug.y = (stage.stageHeight / 2) - (m_debug.height / 2);
			m_debug.alpha = 0;

			m_table = new TacoPlayerTable(this);
			m_table.media = m_media;

			m_placard = new TacoMatchPlacard(this);
			m_placard.media = m_media;

			setHeightsAndWidths();

			addChild(m_debug);
			m_socket.connect("localhost", PORT); 
//			m_fileLoader.loadFile( "/Users/pmeier/tacobell_test1.xml" );
		}


		private function createExternalCalls():void
		{
			if (ExternalInterface.available)
			{
				// For XSplit Broadcaster...
				ExternalInterface.addCallback("SetConfiguration", setConfiguration); 			
				// To set up the right LC with the Config SWF
				ExternalInterface.addCallback("SetConnectionChannel", createLocalConnection);

				ExternalInterface.addCallback("SetVolume", setVolume);
				ExternalInterface.addCallback("SetBackgroundColor", setBG);

				ExternalInterface.addCallback("Play", mPlay);
				ExternalInterface.addCallback("Pause", mPause);
				ExternalInterface.addCallback("Stop", mStop);
				ExternalInterface.addCallback("StepForward", mStep);
				ExternalInterface.addCallback("StepBackward", mStepBackward);
				ExternalInterface.addCallback("GetPlayState", mGetPlayState);
			}
		}
		
		// Re-draws the Plugin's components so they scale nicely.
		private function resizeListener(e:Event):void
		{
			m_debug.text = "";
			debug("Resize called! Width is now " + stage.stageWidth +", height = " + stage.stageHeight);
			drawBG(BG_COLOR);	

			this.clearComponents();
			setHeightsAndWidths();

			m_table.resize();
			m_placard.resize();
			this.addChild(m_debug);

		}

		private function drawBG( color : uint ) : void
		{
			m_bg.graphics.lineStyle();
			m_bg.graphics.beginFill(color);
			m_bg.graphics.drawRect(0,0, stage.stageWidth, stage.stageHeight);
			m_bg.graphics.endFill();
			this.addChild(m_bg);
		}


		private function setHeightsAndWidths():void
		{
			m_table.x = 5;
			m_table.y = 5;
			m_table.width = stage.stageWidth - 10;
			m_table.height = (stage.stageHeight * (1 / 2)) - 5;
			this.addChild(m_table);

			m_placard.x = 5;
			m_placard.y = 5 + m_table.height;
			m_placard.width = stage.stageWidth - 10;
			m_placard.height= (stage.stageHeight * (1 / 2)) - 5;
			m_placard.resize();
			this.addChild(m_placard);
		}

		// Should do this with events...
		public function render( data : TacoReplayInfo ):void
		{
			m_table.display(data.players);
			m_placard.display(data.match);
		}

		public function clearComponents():void
		{
			m_table.clear();
			m_placard.clear();
		}

		/**
		 * Gateway between our data-gathering (sockets,filesystem) and the actual
		 * rendering.
		 */
		public function renderXmlData( data : XML ):void
		{
			render(m_xmlParser.parse(data));
		}

		public function debug(msg : String):void
		{
			m_debug.appendText('\n' + msg);
		}


		//////////////////////////////////////////////////////////////////// 
		// XSPLIT BIDDNESS
		//////////////////////////////////////////////////////////////////// 

		public function setConfiguration( config : String ):void
		{
			// Do nothing, methinks. Good place to redraw?
			debug("Called setConfiguration! config string is " + config);
		}

		private function createLocalConnection( lid : String ):String
		{
			m_localConn = new LocalConnection();
			try {
				m_localConn.connect(lid);
				m_localConn.client = this;
			} catch (e : ArgumentError) {}
			return "";
		}

		public function setBG( color : String, remove : Boolean ) : void
		{
			drawBG(uint("0x" + color));
		}

		public function setVolume( vol : int ):void { }
		public function mPlay():void { }
		public function mPause():void { }
		public function mStop():void { }
		public function mStep():void { }
		public function mStepForward():void { }
		public function mStepBackward():void { }
		public function mGetPlayState():int { return 1; }
	}
}
