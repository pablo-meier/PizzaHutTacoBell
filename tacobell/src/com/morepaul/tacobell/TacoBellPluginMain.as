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
	import flash.text.*;

	import com.morepaul.tacobell.display.*;
	import com.morepaul.tacobell.net.*;
	import com.morepaul.tacobell.data.*;
	import com.morepaul.tacobell.file.*;

	/**
	 * The class that holds it all together.  Initializes, communicates between classes.
	 */

	public class TacoBellPluginMain extends Sprite
	{
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
		private var m_curtain: TacoCurtain;


		private var m_debug : TextField;
		private var m_bg : Shape;

		/**
		 * Initialize the stage.
		 */
		public function TacoBellPluginMain():void
		{
			super();

			stage.scaleMode = StageScaleMode.NO_SCALE;

			m_debug = new TextField();
			m_debug.text = "started!";
			addChild(m_debug);

			debug("stage width is " + stage.stageWidth + ", height is " + stage.stageHeight);

			m_xmlParser = new TacoXmlParser();
			m_fileLoader = new TacoFileLoader(this);

			m_socket = new TacoSocket(this);
			m_socket.connect("localhost", PORT); 

			m_bg = new Shape();
			this.addChild(m_bg);

			m_media = new TacoMediaManager();

//			m_animation = new TacoMatchEndAnimation(0, 0, width, height);
//			this.addChild(m_animation);
//
//			m_curtain = new TacoCurtain(0, 0, width, height);
//			this.addChild(m_curtain);

			m_table = new TacoPlayerTable(this);
			this.addChild(m_table);
			m_table.media = m_media;

//			m_placard = new TacoMatchPlacard(5, 
//											m_table.y + m_table.height + 5, 
//											width - 10,
//											height * (1 / 4) - 10);
//			this.addChild(m_placard);
//			m_placard.media = m_media;

			addChild(m_debug);

			m_fileLoader.loadFile( "/Users/pmeier/tacobell_test1.xml" );
		} 


		public function positionElements():void
		{
			debug("positionElements called in TacoBellPluginMain!");
			m_debug.x = (stage.stageWidth / 2) - (m_debug.width / 2);
			m_debug.y = (stage.stageHeight / 2) - (m_debug.height / 2);

			m_bg.graphics.lineStyle();
			m_bg.graphics.beginFill(0x999999);
			m_bg.graphics.drawRect(0,0, stage.stageWidth, stage.stageHeight);
			m_bg.graphics.endFill();

			m_table.x = 5;
			m_table.y = 5;
			m_table.width = stage.stageWidth - 10;
			m_table.height = (stage.stageHeight * (3 / 4)) - 5;
		}


		// Should do this with events...
		public function render( data : TacoReplayInfo ):void
		{
//			m_animation.play(data);
//			m_curtain.display();
			m_table.display(data.players);
//			m_placard.display(data.match);
		}

		/**
		 * Gateway between our data-gathering (sockets,filesystem) and the actual
		 * rendering.
		 */
		public function renderXmlData( data : XML ):void
		{
			positionElements();
			debug("Calling renderXmlData! m_table w = " + m_table.width + ", h = " + m_table.height);
			debug("stageWidth, height = " +stage.stageWidth + ", " + stage.stageHeight);
			render(m_xmlParser.parse(data));
			debug("After renderXmlData... m_table w = " + m_table.width + ", h = " + m_table.height);
		}

		public function debug(msg : String):void
		{
			m_debug.appendText('\n' + msg);
		}
	}
}
