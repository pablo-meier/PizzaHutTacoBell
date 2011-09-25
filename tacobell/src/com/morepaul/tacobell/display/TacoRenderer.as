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

	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;

	import com.morepaul.tacobell.data.TacoReplayInfo;
	import com.morepaul.tacobell.TacoBellPluginMain;

	/**
	 * Handles all the display logic.
	 */
	public class TacoRenderer extends Sprite
	{
		public static const COMPLETE : String = "rendererComplete";
		
		/** Our connection back to main! And the surface we draw on. */
		private var m_main : TacoBellPluginMain;

		
		/** Our displayable components. */
		private var m_placard : TacoMatchPlacard;
		private var m_animation: TacoMatchEndAnimation;
		private var m_table: TacoPlayerTable;
		private var m_curtain: TacoCurtain;


		/** Loads + stores all our images + video */
		private var m_media : TacoMediaManager;

		public function TacoRenderer(main : TacoBellPluginMain, xPos : Number, 
									yPos : Number, 
									widthSet : Number, 
									heightSet : Number):void
		{
			super();

			main.debug("Entered Renderer!");

			this.x = xPos;
			this.y = yPos;
			this.width = widthSet;
			this.height = heightSet;
			main.debug("Width is " + this.width + ", height is " + this.height);
			main.debug("WidthSet is " + widthSet + ", height is " + heightSet);

			var m_text : TextField = new TextField();
			m_text.text = "TacoRenderer here!";
			m_text.x = (this.width / 2) - (m_text.width / 2);
			m_text.y = (this.height/ 2) - (m_text.height / 2) + 5;
			this.addChild(m_text);

			m_media = new TacoMediaManager(this);

			m_animation = new TacoMatchEndAnimation(this.x, this.y, this.width, this.height);
			this.addChild(m_animation);

			m_curtain = new TacoCurtain(this.x, this.y, this.width, this.height);
			this.addChild(m_curtain);

			m_table = new TacoPlayerTable(this.x + 5, this.y + 5, this.width - 10, this.height * (3 / 4));
			this.addChild(m_table);
			m_table.media = m_media;

			m_placard = new TacoMatchPlacard(this.x + 5, 
											m_table.y + m_table.height + 5, 
											this.width - 10,
											this.height - (this.y - 10));
			this.addChild(m_placard);
			m_placard.media = m_media;


			var bg : Shape = new Shape();
			this.addChild(bg);
			bg.graphics.lineStyle();
			bg.graphics.beginFill(0x999999);
			bg.graphics.drawRect(0,0, this.width, this.height);
			bg.graphics.endFill();
		}

		public function render(data : TacoReplayInfo):void
		{
//			m_animation.play(data);
//			m_curtain.display();
			m_table.display(data.players);
			m_placard.display(data.match);
		}


		public function reset():void
		{

		}
	}
}
