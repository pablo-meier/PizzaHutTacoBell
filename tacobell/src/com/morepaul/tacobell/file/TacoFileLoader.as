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

package com.morepaul.tacobell.file
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import com.morepaul.tacobell.TacoBellPluginMain;

	public class TacoFileLoader
	{
		private var m_main : TacoBellPluginMain;

		public function TacoFileLoader( main : TacoBellPluginMain ):void
		{
			super();
			m_main = main;
		}

		/**
		 * 	While the major use case of our data is coming through the socket, this is 
		 * used for testing, etc.
		 */
		public function loadFile( filename : String ):void
		{
			var xmlLoader:URLLoader = new URLLoader();
			xmlLoader.addEventListener(Event.COMPLETE, onFileReadComplete, false, 0, true);
			xmlLoader.load(new URLRequest(filename));
		}

		
		private function onFileReadComplete( evt : Event ):void
		{
			m_main.renderXmlData(new XML(evt.target.data));
		}
	}
}
