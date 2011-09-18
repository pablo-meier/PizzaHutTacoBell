package com.morepaul.tacobell
{

	import flash.errors.*;
	import flash.events.*;
	import flash.net.Socket;

	/**
	 * The example on the Socket docs worked, but mine doesn't! I haven't the foggiest
	 * clue why. In response, I just start trial-and-erroring what the examples are doing.
	 * In this case, I subclass socket rather than use it as a member.
	 */
	public class TacoSocket extends Socket {

		private var m_main : TacoBellPluginMain;

		public function TacoSocket( host : String, port : uint, main : TacoBellPluginMain ):void 
		{
			super();
			configureListeners();

			m_main = main;

			if (host && port)  {
				super.connect(host, port);
			}
		}

		private function configureListeners():void {
			addEventListener(Event.CLOSE, closeHandler);
			addEventListener(Event.CONNECT, connectHandler);
			addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}


		private function closeHandler(event:Event):void {
			m_main.debug("closeHandler: " + event);
		}

		private function connectHandler(event:Event):void {
			m_main.debug("connectHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			m_main.debug("ioErrorHandler: " + event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			m_main.debug("securityErrorHandler: " + event);
		}

		private function socketDataHandler(event:ProgressEvent):void {
			m_main.debug("socketDataHandler: " + event);
			var str : String = readUTFBytes(bytesAvailable);
			m_main.renderXmlData(new XML(str));
		}
	}
}
