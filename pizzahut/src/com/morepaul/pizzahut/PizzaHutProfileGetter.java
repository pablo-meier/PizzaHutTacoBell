/* Copyright (c) 2011 Paul Meier
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.morepaul.pizzahut;

import hu.belicza.andras.sc2gearspluginapi.*;
import hu.belicza.andras.sc2gearspluginapi.api.*;
import hu.belicza.andras.sc2gearspluginapi.api.listener.*;
import hu.belicza.andras.sc2gearspluginapi.api.profile.*;
import hu.belicza.andras.sc2gearspluginapi.api.sc2replay.*;
import hu.belicza.andras.sc2gearspluginapi.impl.*;


public class PizzaHutProfileGetter implements ProfileListener
{
	
	/** Reference back to Papa so we can set da dataz. */
	private PizzaHutPluginMain m_plugin;

	/** The player's name (who we are fetching) */
	private String m_playerName;

	private PizzaHutNewReplayListener m_parent;

	public PizzaHutProfileGetter(PizzaHutPluginMain plugin, PizzaHutNewReplayListener parent, String name)
	{
		m_plugin = plugin;
		m_parent = parent;
		m_playerName = name;
	}

	@Override
	public void profileReady(IProfile profile, boolean isAnotherRetrievingInProgress)
	{
		if (profile != null)
		{
			m_plugin.addToProfiles(m_playerName, profile);
		}

		// Possible race condition ... in _theory_, you could fetch all the profiles and try to call the parent
		// before the parent is done with the matchInfo, etc.  But let's face it -- this isn't gonna happen.
		if (!m_plugin.lackingProfiles())
		{
//			m_parent.sendData();
		}
	}
}
