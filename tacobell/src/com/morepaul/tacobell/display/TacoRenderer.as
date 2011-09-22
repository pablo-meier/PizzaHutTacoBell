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

	import flash.display.Sprite;

	import com.demonsters.debugger.MonsterDebugger;

	import com.morepaul.tacobell.data.TacoReplayInfo;
	import com.morepaul.tacobell.TacoBellPluginMain;

	/**
	 * Handles all the display logic.
	 */
	public class TacoRenderer extends Sprite
	{
		
		/** Our connection back to main! And the surface we draw on. */
		private var m_main : TacoBellPluginMain;

		
		/** Our displayable components. */
		private var m_placard : TacoMatchPlacard;
		private var m_animation: TacoMatchEndAnimation;
		private var m_table: TacoPlayerTable;
		private var m_curtain: TacoCurtain;


		/** Loads + stores all our images + video */
		private var m_media : TacoMediaManager;

		public function TacoRenderer():void
		{
			super();
			MonsterDebugger.initialize(this);

			m_media = new TacoMediaManager(this);
			
			m_animation = new TacoMatchEndAnimation();
			m_animation.x = this.x;
			m_animation.y = this.y;
			m_animation.width = this.width;
			m_animation.height = this.height;
			this.addChild(m_animation);

			m_curtain = new TacoCurtain();
			m_curtain.x = this.x;
			m_curtain.y = this.y;
			m_curtain.width = this.width;
			m_curtain.height = this.height;
			this.addChild(m_curtain);

			m_table = new TacoPlayerTable(m_media);
			m_table.x = this.x + 5;
			m_table.y = this.y + 5;
			m_table.width = this.width - 10;
			m_table.height = this.height * (3 / 4);
			this.addChild(m_table);

			m_placard = new TacoMatchPlacard(m_media);
			m_placard.x = this.x + 5;
			m_placard.y = m_table.y + m_table.height + 5;
			m_placard.width = this.width - 10;
			m_placard.height = this.height - (this.y - 10);
			this.addChild(m_placard);
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

		private function println( str:String ):void
		{
			MonsterDebugger.trace(this, str);
		}
	}
}
