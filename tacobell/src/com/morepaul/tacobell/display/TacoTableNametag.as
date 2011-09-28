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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.*;

	public class TacoTableNametag extends Sprite
	{
		private static const IMG_SIZE : Number = 50;

		private var m_race : Bitmap;
		private var m_name : TextField;
		private var m_league : Bitmap;
		
		public function TacoTableNametag(race : Bitmap, league : Bitmap, name : TextField):void
		{
			super();
			m_race = race;
			m_league = league;
			m_name = name;

			addEventListener(Event.ADDED_TO_STAGE, addedListener);
		}

		private function addedListener( e : Event ):void
		{
			m_race.width = IMG_SIZE;
			m_race.height = IMG_SIZE;

			m_league.width = IMG_SIZE;
			m_league.height = IMG_SIZE;

			var totalWidth : Number = m_race.width + m_league.width + m_name.width;
			var maxHeight : Number = max(m_race.height, m_league.height, m_name.height);

			this.addChild(m_race);
			m_race.x = 0;
			m_race.y = 3 + (maxHeight / 2) - (m_race.height / 2);

			this.addChild(m_league);
			m_league.x = m_race.width + 3;
			m_league.y = 3 + (maxHeight / 2) - (m_league.height / 2);

			this.addChild(m_name);
			m_name.x = m_race.width + m_league.width + 3;
			m_name.y = 3 + (maxHeight / 2); // - (m_name.height / 2);

			this.width = totalWidth + 6;
			this.height = maxHeight + 6;
		}

		private function max( x : Number, y : Number, z : Number ):Number
		{
			if ( x > y )
			{
				if ( x > z ) { return x; }
				else { return z; }
			}
			else
			{
				if ( y > z ) { return y; }
				else { return z; }
			}
		}
	}
}
