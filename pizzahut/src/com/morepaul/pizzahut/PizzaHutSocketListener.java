/** Copyright (c) 2011 Paul Meier
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

import java.io.IOException;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class PizzaHutSocketListener extends Thread implements Runnable
{

	/** The port we will listen on. */
	private int m_port;

	/** Our reference back to our parent, to set the OutputStream. */
	private PizzaHutPluginMain m_main;


	public PizzaHutSocketListener(PizzaHutPluginMain main, int port)
	{
		m_main = main;
		m_port = port;
	}


	/**
	 * Actually connect to the instance of TacoBell, on the provided port.
	 * Also, Java verbosity/compile-time-exception-asshattery for the win.
	 * @return a socket that speaks to TACOBELL.
	 */
	public void run()
	{
		ServerSocket server = null;
		Socket client = null;
		try
		{
			server = new ServerSocket(m_port);
		}
		catch (IOException e)
		{
			fail(e, "Unable to connect on port " + m_port);
		}

		try
		{
			client = server.accept();
		}
		catch (IOException e)
		{
			fail(e, "Unable to accept incoming socket request.");
		}

		OutputStream out = null;
		try
		{
			out = client.getOutputStream();
		}
		catch (IOException e)
		{
			fail(e, "Couldn't get the socket's Outputstream.");
		}


		if (out != null)
		{
			m_main.setOutputStream(out);
		}	
	}


	private void fail(Exception e, String msg)
	{
		System.err.println(msg);
		e.printStackTrace();
		System.exit(-1);
	}
}

