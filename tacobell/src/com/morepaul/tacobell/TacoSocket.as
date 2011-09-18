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

		private var m_isReadingXml : Boolean;


		private var m_msgLength : uint;

		public function TacoSocket( host : String, port : uint, main : TacoBellPluginMain ):void 
		{
			super();
			configureListeners();

			m_main = main;
			m_isReadingXml = false;
			m_msgLength = 0;

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

		private function readResponse():void {
			if (m_isReadingXml)
			{
				var str : String = readUTFBytes(bytesAvailable);
				m_main.renderXmlData(new XML(str));
				m_isReadingXml = false;
			}
			else
			{
				m_msgLength = this.readInt();

				m_main.debug("Received length! It's " + length.toString());
				this.writeInt(1);
				this.flush();
		
				m_isReadingXml = true;
			}
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
			readResponse();
		}
	}
}
