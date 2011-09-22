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

	import flash.display.DisplayObject;

	/**
	 * Class that separates the various phases of the show -- like a curtain 
	 * separating scenes.  We raise and lower the curtain between the end of
	 * match animation and the displaying of the Placard and Table. The current
	 * thinking is that this will be done by simply raising and lowering opacity
	 * on a shape that covers the animation.
	 */
	public class TacoCurtain extends DisplayObject
	{
		public function TacoCurtain():void
		{
			super();
		}

		/**
		 * Lowers the curtain -- covers the animation.	}
		 */
		public function lower():void
		{

		}

		/**
		 * Raise the curtian -- shows the animation.
		 */
		public function raise():void
		{

		}
	}
}
