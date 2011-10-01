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

		/** Tweak prettiness/layout settings here. */
		private static const BORDER_SIZE : Number = 5;
		private static const BG_COLOR : uint = 0x350b0b;
		private static const TEXT_COLOR : uint = 0xffb3b3;


		/** Duplicated from TacoPlayerTable, though both containers have their own 
		 * in case we'd like to style them differently. */
		private var m_prettyFormat : TextFormat;


		/** We cache these values in case of a resize event. */
		private var m_mapName : String;
		private var m_time : String;

		public function TacoMatchPlacard( main : TacoBellPluginMain ):void
		{
			super(); 

			m_main = main;
			m_background = new Shape();
			addChild(m_background);

			m_placeHolder = new TextField();
			m_placeHolder.text = "Awaiting Match!";
			this.addChild(m_placeHolder);

			m_prettyFormat = new TextFormat();
			m_prettyFormat.align = TextFormatAlign.CENTER;
			m_prettyFormat.bold = true;
			m_prettyFormat.color = TEXT_COLOR;
			m_prettyFormat.font = "Arial";
			m_prettyFormat.size = 24;

			m_mapName = "";
			m_time = "";

			addEventListener(Event.ADDED_TO_STAGE, addedListener);
		}


		public function set media( m : TacoMediaManager ):void 
		{ 
			m_media = m; 
		}

		private function addedListener(e:Event):void
		{
			drawBackground();
			m_placeHolder.x = (this.width / 2) - (m_placeHolder.width / 2);
			m_placeHolder.y = (this.height / 2) - (m_placeHolder.height / 2);
		}

		public function resize():void
		{
			draw(m_mapName, m_time);
		}

		public function display( matchData : TacoMatch ):void
		{
			var mapName : String = matchData.map;
			var time : String = matchData.time;

			m_mapName = mapName;
			m_time = time;
			draw(mapName, time);
		}


		/**
		 * The primary functionality -- we render the MatchPlacard to render 
		 * matches with the following name and time.
		 */
		private function draw( mapName : String, time : String ):void
		{
			drawBackground();

			// HACKHACKHACKHACK
			m_placeHolder.text = "";

			var mapImg : Bitmap = m_media.map(mapName);
			this.scaleOnY(mapImg);
			mapImg.x = BORDER_SIZE;
			mapImg.y = BORDER_SIZE;

			this.addToStage(mapImg);

			var midPointX : Number = (((this.width - BORDER_SIZE) - mapImg.width) / 2) + mapImg.width + BORDER_SIZE;
			var quartilePointY : Number = (this.height - (2 * BORDER_SIZE)) / 4;
			var leftWall : Number = mapImg.width + BORDER_SIZE;

			var mapTF : TextField = makePrettyTextField(mapName);
			resizeTextField(mapTF, midPointX, leftWall);
			mapTF.x = midPointX - (mapTF.width / 2);
			mapTF.y = (3 * quartilePointY) - (mapTF.height / 2);

			this.addToStage(mapTF);

			var timeTF : TextField = makePrettyTextField(time);
			resizeTextField(timeTF, midPointX, leftWall);
			timeTF.x = midPointX - (timeTF.width / 2);
			timeTF.y = quartilePointY - (mapTF.height / 2);

			this.addToStage(timeTF);
		}


		// We want the textfields to be as large as possible without overlapping the 
		// map graphic, or running off the side.  We optimitically make it big enough 
		// for half the height, then shrink it until it fits the width;
		private function resizeTextField( tf : TextField, midpoint : Number, leftWall : Number ):void
		{
			var optimistic : Number = ((this.height - (2 * BORDER_SIZE)) / 2) - 6;
			m_prettyFormat.size = optimistic;
			tf.setTextFormat(m_prettyFormat);

			while (midpoint - (tf.width / 2) < leftWall)
			{
				optimistic -= 4;
				m_prettyFormat.size = optimistic;
				tf.setTextFormat(m_prettyFormat);
			}
		}


		// WHAT THE FUCK IS THIS BROKEN FUCKING SEMANTIC MODEL THAT I HAVE 
		// TO DO THIS ANTIPATTERN!?!?!?
		//
		// If I don't do this, adding shit to the stage makes this Sprite think
		// it has a GIANT width.
		private function addToStage( d : DisplayObject ):void
		{
			var heightSandbox : Number = this.height;
			var widthSandbox : Number = this.width;
			this.addChild(d);
			this.height = heightSandbox;
			this.width = widthSandbox;
		}

		private function drawBackground():void
		{
			m_background.graphics.lineStyle();
			m_background.graphics.beginFill(BG_COLOR);

			var widthSandbox : Number = this.width;
			var heightSandbox : Number = this.height;

			m_background.graphics.drawRect(0,0, widthSandbox, heightSandbox);

			this.width = widthSandbox;
			this.height = heightSandbox;

			this.addToStage(m_background);
		}

		private function makePrettyTextField( str : String ):TextField
		{
			var tf : TextField = new TextField();
			tf.text = str;
			tf.setTextFormat(m_prettyFormat);
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.autoSize = TextFieldAutoSize.LEFT;
			return tf;
		}


		/**
		 * Scales the map graphic to fit the constraint of this container's
		 * y value. Stretches in the x-direction arbitrarily.
		 */
		private function scaleOnY( img : Bitmap ):void
		{
			var targetHeight : Number = this.height - (2 * BORDER_SIZE);
			var scaleValue : Number = targetHeight / img.height;

			img.width  *= scaleValue;
			img.height *= scaleValue;
		}


		/**
		 * We add the dummy child at the end, to prevent the runtime from zero-ing out the
		 * width and height.
		 */
		public function clear():void
		{
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			this.addChild(m_placeHolder);
		}
	}
}
