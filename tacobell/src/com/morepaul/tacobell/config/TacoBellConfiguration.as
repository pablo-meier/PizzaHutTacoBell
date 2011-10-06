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
	// This is the main class for the accompanying config SWF, which currently 
	// doesn't really configure anything. In time though, I imagine it would be 
	// nice to have some interface to check socket connectivity, set port number,
	// alter the color scheme, etc.

	// Until then, I'm just trying to make it minimally compliant so I can get
	// it running on XSplit.

	import flash.display.*;
	import flash.events.*;
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

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			m_localConn = new LocalConnection();
			m_localConn.addEventListener(StatusEvent.STATUS, onStatus);

			createExternalCalls()

			var tf : TextField = new TextField();
			tf.text = "Hello Configuration World!";
			this.addChild(tf);
		}


		private function createExternalCalls():void
		{
			if (ExternalInterface.available)
			{
				//called by broadcaster and will pass config string 
				//so that you can show current configuration on the config window
				ExternalInterface.addCallback("SetConfiguration",setConfiguration);			
				
				//called by broadcaster and will pass the LocalConnection id of the base
				//we need the connection ID of the base so that we can send data TO the base swf (in the broadcaster stage)
				ExternalInterface.addCallback("SetConnectionChannel",setConnectionChannel);		
				
				//called by C# when the file dialog box is closed using the "OK" button
				//the only parameter which will passed will be the list of files (as string), separated by "||"
				ExternalInterface.addCallback("SetSelectedFiles",setSelectedFiles);
				
				ExternalInterface.addCallback("SetLoadStatus", setLoadStatus);
			}
		}
	
		
		private function setConfiguration( config : String ):void
		{
			// do nothing...
		}

		private function setConnectionChannel( lid : String ):void
		{
			m_lid = lid;
		}

		private function setSelectedFiles( files : String ):void
		{
			// Do nothing!
		}

		private function setLoadStatus():void
		{

		}

		private function onStatus( event : StatusEvent ):void
		{

		}
	}
}
