//[]execvm "ZBE_Caching\main.sqf";

player sidechat "ZBE Waiting to settle (15 seconds)";
diag_log "ZBE Waiting to settle (15 seconds)";
sleep 15;
_sum = 0; for "_c" from 1 to 30 do {_sum = (_sum + diag_fps);sleep 1}; dvd_avfps = floor (_sum/30); // Average fps over dvd_avtime sec
player sidechat format ["ZBE FPS Average 30sec no caching %1",dvd_avfps];
diag_log format ["ZBE FPS Average 30sec no caching %1",dvd_avfps];
sleep 1;
player sidechat "ZBE Starting caching and waiting 15 seconds for settle";
diag_log "ZBE Starting caching and waiting 15 seconds for settle";
[]execvm "ZBE_Caching\main.sqf";
sleep 15;
_sum = 0; for "_c" from 1 to 30 do {_sum = (_sum + diag_fps);sleep 1}; dvd_avcfps = floor (_sum/30); // Average fps over dvd_avtime sec
player sidechat format ["ZBE FPS Average 30sec caching %1",dvd_avcfps];
diag_log format ["ZBE FPS Average 30sec caching %1",dvd_avcfps];
player sidechat format ["ZBE %1 groups %2 units %3 cached %4 NoCacheFPS %5 CachedFPS",(count allgroups),(count allunits),ZBE_cached,dvd_avfps,dvd_avcfps];
diag_log format ["ZBE %1 groups %2 units %3 cached %4 NoCacheFPS %5 CachedFPS",(count allgroups),(count allunits),ZBE_cached,dvd_avfps,dvd_avcfps];