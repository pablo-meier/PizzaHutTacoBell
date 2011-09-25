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
	import mx.core.BitmapAsset;

	/**
	 * Our renderer was doing a lot of grunt work that was bloating the
	 * class when it came to loading the various media this uses (league
	 * emblems, race icons, etc.). It'll only get worse with videos, so
	 * I've refactored all that junk out to this class.
	 */
	public class TacoMediaManager
	{

		/** The renderer we communicate with. */
		private var m_renderer : TacoRenderer;

		/** Contains our league graphics. */
		private var m_bronze      : TacoLeague;
		private var m_silver      : TacoLeague;
		private var m_gold        : TacoLeague;
		private var m_plat        : TacoLeague;
		private var m_diamond     : TacoLeague;
		private var m_master      : TacoLeague;
		private var m_grandmaster : TacoLeague;

		private var m_terran  : TacoRace;
		private var m_zerg    : TacoRace;
		private var m_protoss : TacoRace;
		private var m_random  : TacoRace;

		private var m_assets : Array;

		public function TacoMediaManager( renderer : TacoRenderer ):void
		{
			super();

			m_renderer = renderer;
			linkWithEmbedded();

			m_assets = new Array(m_bronze, m_silver, m_gold, m_plat, m_diamond, m_master, m_grandmaster,
								 m_terran, m_zerg, m_protoss, m_random);
		}

		public function get terran() :Bitmap { return m_terran.icon  }
		public function get zerg()   :Bitmap { return m_zerg.icon    }
		public function get protoss():Bitmap { return m_protoss.icon }
		public function get random() :Bitmap { return m_random.icon  }

		public function get bronze():TacoLeague      { return m_bronze      }
		public function get silver():TacoLeague      { return m_silver      }
		public function get gold():TacoLeague        { return m_gold        }
		public function get platinum():TacoLeague    { return m_plat        }
		public function get diamond():TacoLeague     { return m_diamond     }
		public function get master():TacoLeague      { return m_master      }
		public function get grandmaster():TacoLeague { return m_grandmaster }

		public function race( str:String ):Bitmap
		{
			var icon : Bitmap;
			switch(str)
			{
				case "Terran" : icon = this.terran;  break;
				case "Zerg"   : icon = this.zerg;    break;
				case "Protoss": icon = this.protoss; break;
				case "Random" : icon = this.random;  break;
			}
			return icon;
		}

		public function league( name:String, rankInt:uint ):Bitmap
		{
			var league : TacoLeague;
			var icon : Bitmap;
			switch (name)
			{
				case "BRONZE"      : league = this.bronze;       break;
				case "SILVER"      : league = this.silver;       break;
				case "GOLD"        : league = this.gold;         break;
				case "PLATINUM"    : league = this.platinum;     break;
				case "DIAMOND"     : league = this.diamond;      break;
				case "MASTER"      : league = this.master;       break;
				case "GRANDMASTER" : league = this.grandmaster;  break;
			}

			if      (rankInt > 50) { icon = league.standard }
			else if (rankInt > 25) { icon = league.top50    }
			else if (rankInt >  8) { icon = league.top25    }
			else                   { icon = league.top8     }

			return icon;
		}



		/* Embeds and their plumbing at the bottom, because they're ugly as hell. */
		private function linkWithEmbedded():void
		{
			var terIcon : BitmapAsset = new TerranIcon();
			m_terran  = new TacoRace(terIcon);

			var zerIcon : BitmapAsset = new ZergIcon();
			m_zerg    = new TacoRace(zerIcon);

			var tossIcon : BitmapAsset = new ProtossIcon();
			m_protoss = new TacoRace(tossIcon);

			var randIcon : BitmapAsset = new RandomIcon();
			m_random  = new TacoRace(randIcon);

			var bStd : BitmapAsset = new BronzeStandardIcon();
			var bt50 : BitmapAsset = new BronzeTopFiftyIcon();
			var bt25 : BitmapAsset = new BronzeTopTwentyFiveIcon();
			var bt8  : BitmapAsset = new BronzeTopEightIcon();
			m_bronze = new TacoLeague("bronze", bStd, bt50, bt25, bt8);

			var sStd : BitmapAsset = new SilverStandardIcon();
			var st50 : BitmapAsset = new SilverTopFiftyIcon();
			var st25 : BitmapAsset = new SilverTopTwentyFiveIcon();
			var st8  : BitmapAsset = new SilverTopEightIcon();
			m_silver = new TacoLeague("silver", sStd, st50, st25, st8);

			var gStd : BitmapAsset = new GoldStandardIcon();
			var gt50 : BitmapAsset = new GoldTopFiftyIcon();
			var gt25 : BitmapAsset = new GoldTopTwentyFiveIcon();
			var gt8  : BitmapAsset = new GoldTopEightIcon();
			m_gold = new TacoLeague("gold", gStd, gt50, gt25, gt8);

			var pStd : BitmapAsset = new PlatStandardIcon();
			var pt50 : BitmapAsset = new PlatTopFiftyIcon();
			var pt25 : BitmapAsset = new PlatTopTwentyFiveIcon();
			var pt8  : BitmapAsset = new PlatTopEightIcon();
			m_plat = new TacoLeague("platinum", pStd, pt50, pt25, pt8);

			var dStd : BitmapAsset = new DiamondStandardIcon();
			var dt50 : BitmapAsset = new DiamondTopFiftyIcon();
			var dt25 : BitmapAsset = new DiamondTopTwentyFiveIcon();
			var dt8  : BitmapAsset = new DiamondTopEightIcon();
			m_diamond = new TacoLeague("diamond", dStd, dt50, dt25, dt8);

			var mStd : BitmapAsset = new MasterStandardIcon();
			var mt50 : BitmapAsset = new MasterTopFiftyIcon();
			var mt25 : BitmapAsset = new MasterTopTwentyFiveIcon();
			var mt8  : BitmapAsset = new MasterTopEightIcon();
			m_master      = new TacoLeague("master", mStd, mt50, mt25, mt8);

			var gmStd : BitmapAsset = new GrandmasterStandardIcon();
			var gmt50 : BitmapAsset = new GrandmasterTopFiftyIcon();
			var gmt25 : BitmapAsset = new GrandmasterTopTwentyFiveIcon();
			var gmt8  : BitmapAsset = new GrandmasterTopEightIcon();
			m_grandmaster = new TacoLeague("grandmaster", gmStd, gmt50, gmt25, gmt8);
		}

		// RACES
		[Embed(source="../../../../../assets/races/terran.png")]
		private var TerranIcon : Class;
		[Embed(source="../../../../../assets/races/zerg.png")]
		private var ZergIcon : Class;
		[Embed(source="../../../../../assets/races/protoss.png")]
		private var ProtossIcon : Class;
		[Embed(source="../../../../../assets/races/random.png")]
		private var RandomIcon : Class;

		// LEAGUES
		[Embed(source="../../../../../assets/leagues/bronze/standard.png")]
		private var BronzeStandardIcon : Class;
		[Embed(source="../../../../../assets/leagues/bronze/top50.png")]
		private var BronzeTopFiftyIcon : Class;
		[Embed(source="../../../../../assets/leagues/bronze/top25.png")]
		private var BronzeTopTwentyFiveIcon : Class;
		[Embed(source="../../../../../assets/leagues/bronze/top8.png")]
		private var BronzeTopEightIcon : Class;

		[Embed(source="../../../../../assets/leagues/silver/standard.png")]
		private var SilverStandardIcon : Class;
		[Embed(source="../../../../../assets/leagues/silver/top50.png")]
		private var SilverTopFiftyIcon : Class;
		[Embed(source="../../../../../assets/leagues/silver/top25.png")]
		private var SilverTopTwentyFiveIcon : Class;
		[Embed(source="../../../../../assets/leagues/silver/top8.png")]
		private var SilverTopEightIcon : Class;

		[Embed(source="../../../../../assets/leagues/gold/standard.png")]
		private var GoldStandardIcon : Class;
		[Embed(source="../../../../../assets/leagues/gold/top50.png")]
		private var GoldTopFiftyIcon : Class;
		[Embed(source="../../../../../assets/leagues/gold/top25.png")]
		private var GoldTopTwentyFiveIcon : Class;
		[Embed(source="../../../../../assets/leagues/gold/top8.png")]
		private var GoldTopEightIcon : Class;

		[Embed(source="../../../../../assets/leagues/platinum/standard.png")]
		private var PlatStandardIcon : Class;
		[Embed(source="../../../../../assets/leagues/platinum/top50.png")]
		private var PlatTopFiftyIcon : Class;
		[Embed(source="../../../../../assets/leagues/platinum/top25.png")]
		private var PlatTopTwentyFiveIcon : Class;
		[Embed(source="../../../../../assets/leagues/platinum/top8.png")]
		private var PlatTopEightIcon : Class;

		[Embed(source="../../../../../assets/leagues/diamond/standard.png")]
		private var DiamondStandardIcon : Class;
		[Embed(source="../../../../../assets/leagues/diamond/top50.png")]
		private var DiamondTopFiftyIcon : Class;
		[Embed(source="../../../../../assets/leagues/diamond/top25.png")]
		private var DiamondTopTwentyFiveIcon : Class;
		[Embed(source="../../../../../assets/leagues/diamond/top8.png")]
		private var DiamondTopEightIcon : Class;

		[Embed(source="../../../../../assets/leagues/master/standard.png")]
		private var MasterStandardIcon : Class;
		[Embed(source="../../../../../assets/leagues/master/top50.png")]
		private var MasterTopFiftyIcon : Class;
		[Embed(source="../../../../../assets/leagues/master/top25.png")]
		private var MasterTopTwentyFiveIcon : Class;
		[Embed(source="../../../../../assets/leagues/master/top8.png")]
		private var MasterTopEightIcon : Class;

		[Embed(source="../../../../../assets/leagues/grandmaster/standard.png")]
		private var GrandmasterStandardIcon : Class;
		[Embed(source="../../../../../assets/leagues/grandmaster/top50.png")]
		private var GrandmasterTopFiftyIcon : Class;
		[Embed(source="../../../../../assets/leagues/grandmaster/top25.png")]
		private var GrandmasterTopTwentyFiveIcon : Class;
		[Embed(source="../../../../../assets/leagues/grandmaster/top8.png")]
		private var GrandmasterTopEightIcon : Class;
	}
}
