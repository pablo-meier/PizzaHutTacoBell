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

package com.morepaul.tacobell.config
{
	// XSplit doesn't seem to be loading my SWF, so I'm adding more crap to it.
	// This is the main class for the accompanying config SWF.

	import flash.display.*;
	import flash.external.*;
	import flash.net.*;
	import flash.text.*;

	public class TacoBellConfiguration extends Sprite
	{
		private var m_lid : String;
		private var m_localConn : LocalConnection;

		public function TacoBellConfiguration():void
		{
			super();

			var tf : TextField = new TextField();
			tf.text = "Hello Configuration World!";
			this.addChild(tf);

			ExternalInterface.addCallback("SetConfiguration", setConfiguration);
			ExternalInterface.addCallback("SetConnectionChannel", setConnectionChannel);
		}

		
		private function setConfiguration( config : String ):void
		{
			// do nothing...
		}

		private function setConnectionChannel( lid : String ):void
		{
			m_lid = lid;
		}

	}
}
