ZBE_Caching

What does it do?
This caching script/addon enablesimulation false & hideobject true all AI units but Team Leaders if players are not within X distance OR enemy AI units are not within X distance. Also empty vehicles are enablesimulation false if no unit near (including AI) allowing the mission dev to spawn thousands of vehicles with minimal server/client FPS drop.

Why?
I was toying with an ambient vehicle spawn script and found empty vehicles still simulated Physx on all clients and killed framerate when spawning 100s/1000s of vehicles. AI caching greatly improves server performance in Co-Op if mission is heavy on AI.

A3 Feedback Tickets resolved in relation
I first found that Physx wasn't disabled for enablesimulation false and was fixed:
http://feedback.arma3.com/view.php?id=18451
I then found AI enableimulation false wasn't good as it could be and was improved:
http://feedback.arma3.com/view.php?id=18734

Script vs Addon

As of v3, addon version is no longer supported. Spam my PM box if someone is/wants an addon version again.

Testing

"ZBE 144 Groups, 1145 Units, 17 NoCacheFPS, 51 CachedFPS, 59 DeletedFPS"
C_Offroad_01_F drops FPS to 28 no ZBE_Cache vs 59 FPS ZBE_Cache (600+/- spawned)
DWUS (http://www.armaholic.com/page.php?id=21816) 20%+/- FPS improvement


Known issues
Units inside vehicle do not cache due to A3 bug: http://feedback.arma3.com/view.php?id=21702