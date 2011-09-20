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

package com.morepaul.tacobell
{

	import flash.display.Bitmap;

	import com.demonsters.debugger.MonsterDebugger;

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

		public function TacoMediaManager(renderer : TacoRenderer):void
		{
			super();
			MonsterDebugger.trace(this, "Entered media manager!");

			m_renderer = renderer;

			m_bronze      = new TacoLeague("bronze", this);
			m_silver      = new TacoLeague("silver", this);
			m_gold        = new TacoLeague("gold", this);
			m_plat        = new TacoLeague("platinum", this);
			m_diamond     = new TacoLeague("diamond", this);
			m_master      = new TacoLeague("master", this);
			m_grandmaster = new TacoLeague("grandmaster", this);
			MonsterDebugger.trace(this, "Loading leagues!");

			m_terran  = new TacoRace("terran", this);
			m_zerg    = new TacoRace("zerg", this);
			m_protoss = new TacoRace("protoss", this);
			m_random  = new TacoRace("random", this);
			MonsterDebugger.trace(this, "Loading races!");

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


		public function newLoaded():void
		{
			MonsterDebugger.trace(this, "");

			if (this.loaded())
			{
				m_renderer.onLoaded();
			}
		}

		public function loaded():Boolean
		{
			var test : Function = function (t:TacoMediaLoader,i:int,a:Array):Boolean { MonsterDebugger.trace(this, "Loaded " + t.name); return t.loaded(); };
			return m_assets.every(test);
		}

		public function race(str:String):Bitmap
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

		public function league(name:String, rank:String):Bitmap
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

			var rankInt : uint = Number(rank);

			if      (rankInt > 50) { icon = league.standard }
			else if (rankInt > 25) { icon = league.top50    }
			else if (rankInt >  8) { icon = league.top25    }
			else                   { icon = league.top8     }

			return icon;
		}
	}
}
