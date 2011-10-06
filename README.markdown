I'm at the Pizza Hut!
=====================

I'm at the Taco Bell!
=====================	

[I'm at the Combination Pizza Hut and Taco Bell!](http://www.youtube.com/watch?v=EQ8ViYIeH04)
=================================================


What is it?
-----------
PizzaHutTacoBell is a hacky toy to get cute replay stats up on 
[my stream][4] after ladder matches. Xsplit allows you to 
include SWFs as display media, and Sc2Gears allows you to write plugins that 
can activate when a new replay is generated.

Combining these two, this pair of tools includes a) an Sc2Gears plugin that
parses relevant statistics from replays as soon as they are created, and b) a
SWF that renders these statistics for display in XSplit. The idea is to have
them run near-instantaneously after every ladder match.

The hope was to originally do this with IPL-like post-match stats (Resources 
Spent, Workers Built) but this turns out to be impossible with the data present 
in a replay (through no fault of Sc2Gears). Still, the plugin pair will 
(hopefully!) show APM, Player league, winner, match time, map, and keep track 
of how many games I've won and lost in a session. And with any luck, we'll have 
cute animations :-p

Why the name?
-------------
I couldn't get over the hacktacular-ness of having to develop two plugins on two
different cross-platform frameworks, using two plugin SDKs to achieve this
common task.  I also had the song linked above caught in my head while walking
to work.  

Pizza Hut is the SC2Gears Java plugin.

Taco Bell is the XSplit SWF plugin.

Together, the are the COMBINATION PIZZA HUT AND TACO BELL. Which is to say,
delicious.

How to use?
-----------
Currently this is pretty hard-coded to my own setup, and I make no guarantees.
I started this with the idea that this would only be a fun project that I don't 
want to "release" or support in a way requiring nontrivial time commitment (if 
you'd like to fork it and make it respectable, by all means! Just please give 
me a shout-out :-p).

If you'd like this in your own stream setup, here's what I do when I 'deploy'
a new 'build':

* From the top-level, run `ant`. If you have all the dependencies ([Ant][1], a 
[Flex SDK][2], with FLEX\_HOME set to point to your SDK), it should create 
two directories in COMBINATION\_PIZZAHUT\_AND\_TACOBELL.
* Drop the PIZZAHUT directory into &lt;Sc2Gears&gt;/Plugins.
* From Sc2Gears, enable PIZZAHUT from Tools -> Plugin Manager. You'll know it 
worked if the file "&lt;Sc2Gears&gt;\\User Content\\system\_messages.log" contains
the line "[PIZZAHUT]: initing"!
* Drop TACOBELL.swf into your Xsplit Application folder, probably under 
"C:\\Program Files\\Splitmedia Labs\\Xsplit". If you're running 64-bit Windows, 
s/Program Files/Program Files (x86)/.  
* From your XSplit scene, import SWF plugin -> TACOBELL.swf.

  **Note: Do not import TACOBELL from anywhere other than the XSplit folder.** 
  I pulled out enough hair trying to get this to work with the wrapper SWF before
  throwing in the towel and just importing it raw. Maybe I'll figure it out and
  get it to work later, but chances are I won't care enough.

You should be good to go. If you want to be sure things are connected, you can 
check &lt;Sc2Gears&gt;\\User Content\\system\_messages.log, where connection
triggers additional output lines like "[PIZZAHUT] Established a new connection!"

There's a lot of manual fudging going around, particularly for checking 
connections, as well as the hard-coded port 8080. The hope is to write actual 
config interfaces for these plugins at some point. Again, no guarantees :-p

Also
----
Bless the creator of [Sc2Gears][3] - András Belicza - for writing such an
awesome program, and allowing it to be extended with plugins!

Bless the creators of [XSplit][7] - [Splitmedia labs][6] - for recognizing the 
coolnees of Flash and allowing _their_ program to be extended with SWF plugins!


   [1]: http://ant.apache.org/
   [2]: http://opensource.adobe.com/wiki/display/flexsdk/Flex+SDK
   [3]: http://sites.google.com/site/sc2gears/
   [4]: http://twitch.tv/sicp
   [5]: http://sites.google.com/site/sc2gears/home
   [6]: http://www.splitmedialabs.com/
   [7]: http://www.xsplit.com/
