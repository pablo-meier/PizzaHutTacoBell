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
	import flash.text.TextField;

	/**
	 * The class that holds it all together.  Initializes, communicates between classes.
	 */

	public class TacoBellPluginMain extends Sprite
	{
		/** Hard-coded LIKE A BAWS */
		private var PORT : int = 8080;

		/** Where we debug since we don't have a damn stdout print. */
		private var m_debug : TextField;

		/** Our communication friend! */
		private var m_socket : TacoSocket;

		/** Our painter friend! */
		private var m_renderer: TacoRenderer;

		/**
		 * Initialize the stage.
		 */
		public function TacoBellPluginMain():void
		{
			super();
			stage.stageWidth = 600;
			stage.stageHeight = 800;

			setupDebug();

			m_renderer = new TacoRenderer();
			this.addChild(m_renderer);
			// m_socket = new TacoSocket("localhost", PORT, this);
			m_renderer.renderFile("/Users/pmeier/tacobell_test1.xml");
		} 


		public function renderXmlData( data : XML ):void
		{
			m_renderer.renderXmlData(data);
		}

		/**
		 * Actionscript has this wonderful property where you can't write to 
		 * stdout with the language's tools -- you can use trace() to write,
		 * but only to the output consoles of Flash Pro and Flash Builder.
		 *
		 * Since we're in a graphical environment anyways, there is a TF that only
		 * serves to display debug data. Other classes can call it as necessary.
		 */
        public function debug( str : String ):void
        {
			m_debug.text = str;
        }


		private function setupDebug():void
		{
			m_debug = new TextField();
			m_debug.text = "Debug lolololololol";
			this.addChild(m_debug);
			m_debug.x = (stage.stageWidth / 2 ) - (m_debug.width / 2);
			m_debug.y = (stage.stageHeight / 2 ) - (m_debug.height / 2);
		}
	}
}
