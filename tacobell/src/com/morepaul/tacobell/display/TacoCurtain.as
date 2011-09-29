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

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	import com.morepaul.tacobell.TacoBellPluginMain;

	/**
	 * Class that separates the various phases of the show -- like a curtain 
	 * separating scenes.  We raise and lower the curtain between the end of
	 * match animation and the displaying of the Placard and Table. The current
	 * thinking is that this will be done by simply raising and lowering opacity
	 * on a shape that covers the animation.
	 */
	public class TacoCurtain extends Sprite
	{

		private var m_background : Shape;
		private var m_main : TacoBellPluginMain;
		private var m_placeHolder : TextField;

		public function TacoCurtain( main : TacoBellPluginMain ):void
		{
			super();

			m_main = main;

			m_background = new Shape();
			this.addChild(m_background);

			m_placeHolder = new TextField();
			m_placeHolder.text = "Curtain Lowered!";
			this.addChild(m_placeHolder);

			this.addEventListener(Event.ADDED_TO_STAGE, addedListener);
		}

		private function addedListener(e:Event):void
		{
			var widthSandbox : Number = this.width;
			var heightSandbox : Number = this.height;

			m_background.graphics.lineStyle();
			m_background.graphics.beginFill(0x00000000);
			m_background.graphics.drawRect(0,0, this.width, this.height);

			this.width = widthSandbox;
			this.height = heightSandbox;
		}

		/**
		 * Lowers the curtain -- covers the animation.	}
		 */
		public function display():void
		{
			var widthSandbox : Number = this.width;
			var heightSandbox : Number = this.height;

			m_background.graphics.lineStyle();
			m_background.graphics.beginFill(0xAA000000);
			m_background.graphics.drawRect(0,0, this.width, this.height);

			this.width = widthSandbox;
			this.height = heightSandbox;

			m_placeHolder.text = "";
		}
	}
}
