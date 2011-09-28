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
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;

	import com.morepaul.tacobell.data.TacoMatch;
	import com.morepaul.tacobell.TacoBellPluginMain;

	/**
	 * The MatchPlacard lies at the bottom of the render area, and displays 
	 * information about the match that is not specific to any player.  In this
	 * case, we're displaying the time of the match, the map that was played, and
	 * (maybe) whether or not the loser(s) gg-ed.
	 */
	public class TacoMatchPlacard extends Sprite
	{
		private var m_media : TacoMediaManager;
		private var m_main : TacoBellPluginMain;
		private var m_background : Shape;

		private var m_placeHolder : TextField;

		public function TacoMatchPlacard( main : TacoBellPluginMain ):void
		{
			super(); 

			m_main = main;
			m_background = new Shape();
			addChild(m_background);

			m_placeHolder = new TextField();
			m_placeHolder.text = "Awaiting Match!";
			this.addChild(m_placeHolder);

			addEventListener(Event.ADDED_TO_STAGE, addedListener);
		}


		public function set media( m : TacoMediaManager ):void 
		{ 
			m_media = m; 
		}

		private function addedListener(e:Event):void
		{
			m_background.graphics.lineStyle();
			m_background.graphics.beginFill(0x222222);

			var widthSandbox : Number = this.width;
			var heightSandbox : Number = this.height;

			m_background.graphics.drawRect(0,0, widthSandbox, heightSandbox);

			this.width = widthSandbox;
			this.height = heightSandbox;

			m_placeHolder.x = (this.width / 2) - (m_placeHolder.width / 2);
			m_placeHolder.y = (this.height / 2) - (m_placeHolder.height / 2);
		}


		/**
		 * The primary functionality -- we render the MatchPlacard to render 
		 * matches with the following name and time.
		 */
		public function display( matchData : TacoMatch ):void
		{
			var mapName : String = matchData.map;
			var mapImg : Bitmap = m_media.map(mapName);
			mapImg.width = 100;
			mapImg.height= 100;
			mapImg.x = 5;
			mapImg.y = 5;

			this.addChild(mapImg);

			var mapTF : TextField = new TextField();
			mapTF.text = mapName;
			mapTF.x = (this.width / 2) - (mapTF.width / 2);
			mapTF.y = (this.height / 2) - (mapTF.height / 2);
			this.addChild(mapTF);
		}
	}
}
