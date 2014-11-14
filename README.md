[CENTER][B][SIZE=4]ZBE_Caching[/SIZE][/B]

[B]What does it do?[/B]
This caching script/addon enablesimulation false & hideobject true all AI units but Team Leaders if players are not within X distance OR enemy AI units are not within X distance. Also empty vehicles are enablesimulation false if no unit near (including AI) allowing the mission dev to spawn thousands of vehicles with minimal server/client FPS drop.

[B]Why?[/B]
I was toying with an ambient vehicle spawn script and found empty vehicles still simulated Physx on all clients and killed framerate when spawning 100s/1000s of vehicles. AI caching greatly improves server performance in Co-Op if mission is heavy on AI.

[B]A3 Feedback Tickets resolved in relation[/B]
I first found that Physx wasn't disabled for enablesimulation false and was fixed:
[url]http://feedback.arma3.com/view.php?id=18451[/url]
I then found AI enableimulation false wasn't good as it could be and was improved:
[url]http://feedback.arma3.com/view.php?id=18734[/url][/CENTER]

[B][CENTER]Script vs Addon[/CENTER][/B]
[CENTER]As of v3, addon version is no longer supported. Spam my PM box if someone is/wants an addon version again.[/CENTER]

[B][CENTER]Testing[/CENTER][/B]
[CENTER]"ZBE 144 Groups, [B]1145 Units, 17 NoCacheFPS, 51 CachedFPS[/B], 59 DeletedFPS"
C_Offroad_01_F drops FPS to 28 no ZBE_Cache vs 59 FPS ZBE_Cache (600+/- spawned)
DWUS ([url]http://www.armaholic.com/page.php?id=21816[/url]) 20%+/- FPS improvement


[B]Known issues[/B]
Units inside vehicle do not cache due to A3 bug: [URL="http://feedback.arma3.com/view.php?id=21702"]A3 Issue Tracker[/URL]
[URL="https://bitbucket.org/zorrobyte/zbe_cache/issues/new"]Report issues here[/URL]