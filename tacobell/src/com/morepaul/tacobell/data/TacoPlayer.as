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

package com.morepaul.tacobell.data
{

	/**
	 * Data representing a player and their performance in a game.
	 */
	public class TacoPlayer
	{
		public function TacoPlayer():void { super(); }

		// How many rows will you need to display this content?
		public static const NUM_ROWS : uint = 2;

		private var m_name : String;
		private var m_apm : uint;
		private var m_race : String;
		private var m_league : String;
		private var m_rank: uint;
		private var m_winner : Boolean;
	
		public function get name()   :String  { return m_name;   }
		public function get apm()    :uint    { return m_apm;    }
		public function get race()   :String  { return m_race;   }
		public function get league() :String  { return m_league; }
		public function get rank()   :uint    { return m_rank;   }
		public function get winner() :Boolean { return m_winner;   }

		public function set name(name:String):void       { m_name = name;     }
		public function set apm(apm : uint):void         { m_apm = apm;       }
		public function set race(race : String):void     { m_race = race;     }
		public function set league(league : String):void { m_league = league; }
		public function set rank(rank : uint):void       { m_rank = rank;     }
		public function set winner(win : Boolean):void   { m_winner = win;    }
	}
}
