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
	import flash.display.Bitmap;
	import flash.events.Event;

	public class TacoLeague extends TacoMediaLoader
	{

		// League Icon types.
		private var m_standard : Bitmap;
		private var m_top50    : Bitmap;
		private var m_top25    : Bitmap;
		private var m_top8     : Bitmap;
		private var m_name : String;

		public function TacoLeague(name : String):void
		{
			super(4);
			m_name = name;
			loadBitmaps();
		}

		// PUBLIC INTERFACE
		public function get standard():Bitmap { return m_standard; }
		public function get top50():Bitmap    { return m_top50;    }
		public function get top25():Bitmap    { return m_top25;    }
		public function get top8():Bitmap     { return m_top8;     }

		public function get name():String     { return m_name;     }


		///// HELPERS
		private function loadBitmaps():void
		{
			makeLoader(handleStandard, ASSET_PATH + "leagues/" + m_name + "/standard.png");
			makeLoader(handleTop50,    ASSET_PATH + "leagues/" + m_name + "/top50.png");
			makeLoader(handleTop25,    ASSET_PATH + "leagues/" + m_name + "/top25.png");
			makeLoader(handleTop8,     ASSET_PATH + "leagues/" + m_name + "/top8.png");
		}

		private function handleStandard(evt:Event):void { m_standard = Bitmap(evt.target.data); }
		private function handleTop50   (evt:Event):void { m_top50    = Bitmap(evt.target.data); }
		private function handleTop25   (evt:Event):void { m_top25    = Bitmap(evt.target.data); }
		private function handleTop8    (evt:Event):void { m_top8     = Bitmap(evt.target.data); }
	}
}
