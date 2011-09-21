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

	public class TacoLeague
	{

		// League Icon types.
		private var m_standard : Bitmap;
		private var m_top50    : Bitmap;
		private var m_top25    : Bitmap;
		private var m_top8     : Bitmap;

		public function TacoLeague( name : String, 
									standard : Bitmap, 
									top50    : Bitmap, 
									top25    : Bitmap, 
									top8     : Bitmap )
		{
			super();
			m_standard = standard;
			m_top50 = top50;
			m_top25 = top25;
			m_top8 = top8;
		}

		// PUBLIC INTERFACE
		public function get standard():Bitmap { return m_standard; }
		public function get top50():Bitmap    { return m_top50;    }
		public function get top25():Bitmap    { return m_top25;    }
		public function get top8():Bitmap     { return m_top8;     }
	}
}
