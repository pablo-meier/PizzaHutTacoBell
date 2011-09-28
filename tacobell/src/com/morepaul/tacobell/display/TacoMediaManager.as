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
	import flash.display.BitmapData;
//	import mx.core.BitmapAsset;

	/**
	 * Our renderer was doing a lot of grunt work that was bloating the
	 * class when it came to loading the various media this uses (league
	 * emblems, race icons, etc.). It'll only get worse with videos, so
	 * I've refactored all that junk out to this class.
	 */
	public class TacoMediaManager
	{
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

		private var m_shakuras  : BitmapData;
		private var m_antiga    : BitmapData;
		private var m_xelnaga   : BitmapData;
		private var m_taldarim  : BitmapData;
		private var m_backwater : BitmapData;
		private var m_searing   : BitmapData;
		private var m_shattered : BitmapData;
		private var m_typhon    : BitmapData;
		private var m_nerazim   : BitmapData;
		private var m_abyssal   : BitmapData;


		private var m_assets : Array;

		public function TacoMediaManager():void
		{
			super();

			linkWithEmbedded();

			m_assets = new Array(m_bronze, m_silver, m_gold, m_plat, m_diamond, m_master, m_grandmaster,
								 m_terran, m_zerg, m_protoss, m_random);
		}

		public function get terran() : BitmapData { return m_terran.icon  }
		public function get zerg()   : BitmapData { return m_zerg.icon    }
		public function get protoss(): BitmapData { return m_protoss.icon }
		public function get random() : BitmapData { return m_random.icon  }

		public function get bronze():TacoLeague      { return m_bronze      }
		public function get silver():TacoLeague      { return m_silver      }
		public function get gold():TacoLeague        { return m_gold        }
		public function get platinum():TacoLeague    { return m_plat        }
		public function get diamond():TacoLeague     { return m_diamond     }
		public function get master():TacoLeague      { return m_master      }
		public function get grandmaster():TacoLeague { return m_grandmaster }

		public function race( str:String ):Bitmap
		{
			var icon : BitmapData;
			switch(str)
			{
				case "Terran" : icon = this.terran;  break;
				case "Zerg"   : icon = this.zerg;    break;
				case "Protoss": icon = this.protoss; break;
				case "Random" : icon = this.random;  break;
			}
			return new Bitmap(icon);
		}

		public function league( name:String, rankInt:uint ):Bitmap
		{
			var league : TacoLeague;
			var icon : BitmapData;
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

			return new Bitmap(icon);
		}


		public function map( name : String ) : Bitmap
		{
			var img : BitmapData;
			switch (name)
			{
				case "Shakuras Plateau"     : img = m_shakuras; break;
				case "Antiga Shipyard "     : img = m_antiga; break;
				case "Xel'Naga Caverns"     : img = m_xelnaga; break;
				case "Tal'Darim Altar LE"   : img = m_taldarim; break;
				case "Backwater Gulch"      : img = m_backwater; break;
				case "Searing Crater"       : img = m_searing; break;
				case "The Shattered Temple" : img = m_shattered; break;
				case "Typhon Peaks"         : img = m_typhon; break;
				case "Nerazim Crypt"        : img = m_nerazim; break;
				case "Abyssal Caverns"      : img = m_abyssal; break;
			}
			return new Bitmap(img);
		}



		/* Embeds and their plumbing at the bottom, because they're ugly as hell. */
		private function linkWithEmbedded():void
		{
			var terIcon : BitmapData = new TerranIcon().bitmapData;
			m_terran  = new TacoRace(terIcon);

			var zerIcon : BitmapData = new ZergIcon().bitmapData;
			m_zerg    = new TacoRace(zerIcon);

			var tossIcon : BitmapData = new ProtossIcon().bitmapData;
			m_protoss = new TacoRace(tossIcon);

			var randIcon : BitmapData = new RandomIcon().bitmapData;
			m_random  = new TacoRace(randIcon);

			var bStd : BitmapData = new BronzeStandardIcon().bitmapData;
			var bt50 : BitmapData = new BronzeTopFiftyIcon().bitmapData;
			var bt25 : BitmapData = new BronzeTopTwentyFiveIcon().bitmapData;
			var bt8  : BitmapData = new BronzeTopEightIcon().bitmapData;
			m_bronze = new TacoLeague("bronze", bStd, bt50, bt25, bt8);

			var sStd : BitmapData = new SilverStandardIcon().bitmapData;
			var st50 : BitmapData = new SilverTopFiftyIcon().bitmapData;
			var st25 : BitmapData = new SilverTopTwentyFiveIcon().bitmapData;
			var st8  : BitmapData = new SilverTopEightIcon().bitmapData;
			m_silver = new TacoLeague("silver", sStd, st50, st25, st8);

			var gStd : BitmapData = new GoldStandardIcon().bitmapData;
			var gt50 : BitmapData = new GoldTopFiftyIcon().bitmapData;
			var gt25 : BitmapData = new GoldTopTwentyFiveIcon().bitmapData;
			var gt8  : BitmapData = new GoldTopEightIcon().bitmapData;
			m_gold = new TacoLeague("gold", gStd, gt50, gt25, gt8);

			var pStd : BitmapData = new PlatStandardIcon().bitmapData;
			var pt50 : BitmapData = new PlatTopFiftyIcon().bitmapData;
			var pt25 : BitmapData = new PlatTopTwentyFiveIcon().bitmapData;
			var pt8  : BitmapData = new PlatTopEightIcon().bitmapData;
			m_plat = new TacoLeague("platinum", pStd, pt50, pt25, pt8);

			var dStd : BitmapData = new DiamondStandardIcon().bitmapData;
			var dt50 : BitmapData = new DiamondTopFiftyIcon().bitmapData;
			var dt25 : BitmapData = new DiamondTopTwentyFiveIcon().bitmapData;
			var dt8  : BitmapData = new DiamondTopEightIcon().bitmapData;
			m_diamond = new TacoLeague("diamond", dStd, dt50, dt25, dt8);

			var mStd : BitmapData = new MasterStandardIcon().bitmapData;
			var mt50 : BitmapData = new MasterTopFiftyIcon().bitmapData;
			var mt25 : BitmapData = new MasterTopTwentyFiveIcon().bitmapData;
			var mt8  : BitmapData = new MasterTopEightIcon().bitmapData;
			m_master      = new TacoLeague("master", mStd, mt50, mt25, mt8);

			var gmStd : BitmapData = new GrandmasterStandardIcon().bitmapData;
			var gmt50 : BitmapData = new GrandmasterTopFiftyIcon().bitmapData;
			var gmt25 : BitmapData = new GrandmasterTopTwentyFiveIcon().bitmapData;
			var gmt8  : BitmapData = new GrandmasterTopEightIcon().bitmapData;
			m_grandmaster = new TacoLeague("grandmaster", gmStd, gmt50, gmt25, gmt8);

			m_shakuras = new ShakurasPlateau().bitmapData;
			m_antiga = new AntigaShipyard().bitmapData;
			m_xelnaga = new XelNagaCaverns().bitmapData;  
			m_taldarim = new TalDarimAltar().bitmapData;
			m_backwater = new BackwaterGulch().bitmapData;
			m_searing = new SearingCrater().bitmapData;
			m_shattered = new ShatteredTemple().bitmapData;
			m_typhon = new TyphonPeaks().bitmapData;
			m_nerazim = new NerazimCrypt().bitmapData;
			m_abyssal = new AbyssalCaverns().bitmapData;
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


		// MAPS -- 1v1
		[Embed(source="../../../../../assets/maps/1v1/xelnaga_caverns.png")]
		private var XelNagaCaverns : Class;
		[Embed(source="../../../../../assets/maps/1v1/taldarim_altar.png")]
		private var TalDarimAltar : Class;
		[Embed(source="../../../../../assets/maps/1v1/antiga_shipyard.png")]
		private var AntigaShipyard : Class;
		[Embed(source="../../../../../assets/maps/1v1/nerazim_crypt.png")]
		private var NerazimCrypt : Class;
		[Embed(source="../../../../../assets/maps/1v1/abyssal_caverns.png")]
		private var AbyssalCaverns : Class;
		[Embed(source="../../../../../assets/maps/1v1/backwater_gulch.png")]
		private var BackwaterGulch : Class;
		[Embed(source="../../../../../assets/maps/1v1/searing_crater.png")]
		private var SearingCrater : Class;
		[Embed(source="../../../../../assets/maps/1v1/shattered_temple.png")]
		private var ShatteredTemple : Class;
		[Embed(source="../../../../../assets/maps/1v1/typhon_peaks.png")]
		private var TyphonPeaks : Class;
		[Embed(source="../../../../../assets/maps/1v1/shakuras_plateau.png")]
		private var ShakurasPlateau : Class;
	}
}
