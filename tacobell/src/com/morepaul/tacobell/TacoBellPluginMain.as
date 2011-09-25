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
	import flash.events.Event;
	import flash.text.*;

	import com.morepaul.tacobell.display.TacoRenderer;
	import com.morepaul.tacobell.net.TacoSocket;
	import com.morepaul.tacobell.data.TacoXmlParser;
	import com.morepaul.tacobell.file.TacoFileLoader;

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

		/** Our painter friend! */
		private var m_renderer: TacoRenderer;

		/** Yo fuck this guy... */
		private var m_xmlParser : TacoXmlParser;

		private var m_debug : TextField;

		/**
		 * Initialize the stage.
		 */
		public function TacoBellPluginMain():void
		{
			super();

			stage.scaleMode = StageScaleMode.SHOW_ALL;

			m_debug = new TextField();
			m_debug.text = "started!";
			m_debug.x = (stage.stageWidth / 2) - (m_debug.width / 2);
			m_debug.y = (stage.stageHeight / 2) - (m_debug.height / 2);
			addChild(m_debug);

			m_renderer = new TacoRenderer(this, 0, 0, stage.stageWidth, stage.stageHeight);
			this.addChild(m_renderer);

			debug("stage width is " + stage.stageWidth + ", height is " + stage.stageHeight);

			m_xmlParser = new TacoXmlParser();

			m_socket = new TacoSocket(this);
			m_socket.connect("localhost", PORT); 
			completeRendererListener();
		} 


		public function debug(msg : String):void
		{
			m_debug.appendText('\n' + msg);
		}


		public function completeRendererListener():void
		{
			debug("Stats are x = " + m_renderer.x + ", y = " + m_renderer.y + ", w " + m_renderer.width + ", h = " + m_renderer.height);
			// For testing...
			m_fileLoader = new TacoFileLoader(this);
			m_fileLoader.loadFile("/Users/pmeier/tacobell_test1.xml");
		}


		/**
		 * Gateway between our data-gathering (sockets,filesystem) and the actual
		 * rendering.
		 */
		public function renderXmlData( data : XML ):void
		{
			m_renderer.render(m_xmlParser.parse(data));
		}
	}
}
