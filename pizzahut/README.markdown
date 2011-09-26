So I have an apology...
=======================

The first level README promised that we'd use Sc2Gears to get great stats from
replays, sort of like the post-match screen on IPL. Sadly, through no fault of
Sc2Gears but rather the replay file format, we can't gather most statistics from
a replay file alone. So many of the original stats (e.g. Resources Gathered,
Units Lost, etc.) have gone by the wayside.  The early Hello Worlds are really
only sending APM (along with other 'obvious' data, like Match time, the players,
map, etc.).

We\* still plan on going ahead with the project; we'll just make a big deal of
whether or not I won, and the league/race of my opponent.

Building + Dependencies
-----------------------
To build, just type 'ant' in this directory. It's very unlikely you'll need
anything else other than the standard JDK. And ant, obviously.

Bugs
----
There are probably many more, but if you disable then enable the plugin again
too quickly (within a few seconds), you'll crash Sc2Gears! Looks like they
didn't learn from web browsers and isolate the plugin process. This is because
the port is hard-coded, and won't be freed until a few seconds after you disable
the plugin. So if you disable it after having had it enabled, do wait a few
seconds :-p

I'll work on that bug... sometime.


\*= "We"? Who am I kidding, it's only me here /foreveralone...



