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
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	import com.demonsters.debugger.MonsterDebugger;

	/**
	 * A few abstractions that serve media do a similar "load on creation, send
	 * message back to caller." This class abstracts that.
	 */
	public class TacoMediaLoader
	{
		protected static const ASSET_PATH : String = "assets/";

		private var m_bitmapsLoaded : uint;
		private var m_numToLoad : uint;
		private var m_loaded : Boolean;

		private var m_main : TacoMediaManager;

		private var m_name : String;

		public function TacoMediaLoader(howMany : uint, main : TacoMediaManager, name : String)
		{
			super();

			m_bitmapsLoaded = 0;
			m_numToLoad = howMany;
			m_main = main;
			m_name = name;
		}

		public function loaded():Boolean  { return m_loaded; }
		public function get name():String { return m_name; }


		protected function makeLoader(callback : Function, path : String):void
		{
			MonsterDebugger.trace(this, "[MAKELOADER] path is " + path + ", name is " + m_name);
			var imgLoader:Loader = new Loader();
			var betterCallback : Function = function(evt:Event):void { incr(); callback(evt); check(); };

			imgLoader.addEventListener(Event.COMPLETE, betterCallback, false, 0, true);
			imgLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIoError);
			imgLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);

			imgLoader.load(new URLRequest(path));
		}

		private function incr():void
		{
			m_bitmapsLoaded += 1;
		}

		private function check():void
		{
			if (m_bitmapsLoaded == m_numToLoad) 
			{
				m_loaded = true;
				m_main.newLoaded();
			}
		}

		private function handleIoError(evt : IOErrorEvent):void
		{
			MonsterDebugger.trace(this, "SHIT WENT DOWN ON IO = " + m_name);
		}

		private function handleSecurityError(evt : SecurityErrorEvent):void
		{
			MonsterDebugger.trace(this, "SHIT WENT DOWN ON SECURITY" + m_name);
		}
	}
}
