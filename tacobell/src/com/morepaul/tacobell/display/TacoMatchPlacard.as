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

	import com.morepaul.tacobell.data.TacoMatch;


	/**
	 * The MatchPlacard lies at the bottom of the render area, and displays 
	 * information about the match that is not specific to any player.  In this
	 * case, we're displaying the time of the match, the map that was played, and
	 * (maybe) whether or not the loser(s) gg-ed.
	 */
	public class TacoMatchPlacard extends Sprite
	{

		public function TacoMatchPlacard():void
		{ super(); }

		/**
		 * The primary functionality -- we render the MatchPlacard to render 
		 * matches with the following name and time.
		 */
		public function display( matchData : TacoMatch ):void
		{

		}
	}
}
