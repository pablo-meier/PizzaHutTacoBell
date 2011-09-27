I'm at the Pizza Hut!
=====================

I'm at the Taco Bell!
=====================	

[I'm at the Combination Pizza Hut and Taco Bell!](http://www.youtube.com/watch?v=EQ8ViYIeH04)
=================================================


What is it?
-----------
PizzaHutTacoBell is a hacky toy to get cute replay stats up on 
[my stream](http://twitch.tv/sicp) after ladder matches. Xsplit allows you to 
include SWFs as display media, and Sc2Gears allows you to write plugins that 
can activate when a new replay is generated.

Combining these two, this pair of tools includes a) an Sc2Gears plugin that
parses relevant statistics from replays as soon as they are created, and b) a
SWF that renders these statistics for display in XSplit. The idea is to have
them run near-instantaneously after every ladder match.

The hope was to originally do this with IPL-like after-match 
stats (Resources Spent, Workers Built) but this turns out to be impossible 
with the data present in a replay (through no fault of Sc2Gears). Still, the 
plugin pair will (hopefully!) show APM, Player league, winner, match time, 
map, and keep track of how many games I've won and lost in a session. And with
any luck, we'll have cute animations :-p

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

Also
----
Bless the creator of Sc2Gears - [András
Belicza](http://sites.google.com/site/sc2gears/home) - for writing such an
awesome program, and allowing it to be extended with plugins!

Bless the creators of [XSplit](http://www.xsplit.com/) - [Splitmedia
labs](http://www.splitmedialabs.com/) - for recognizing the coolnees of Flash
and allowing _their_ program to be extended with SWF plugins!
