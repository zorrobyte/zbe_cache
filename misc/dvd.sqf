//////////////////////////////////////////////////////////////////
// Function file for [Combined Operations]
// Created by: [TPW]
//////////////////////////////////////////////////////////////////

// Script to smoothly scale the viewdistance according to fps and whether scope is used.
// Should help stabilise FPS too.
// Huge thanks to Das Attorney for help with the addon version of this script
// v1.03 TPW 20110128

// Variables
dvd_vmin = 500; // minimum draw distance
dvd_vpref = 3000; // preferred draw distance
dvd_vmax = 8000; // maximum draw distance
dvd_fmin = 30; // min framerate
dvd_fpref = 40; // preferred framerate
dvd_avtime = 10; // In seconds. Must be > 2
dvd_zf = 1.5; // zoom factor to increase viewdistance by when scope used 
dvd_azf = 1.5; // zoom factor to increase viewdistance by when in aircraft 
dvd_debug = 1; // debugging output 
//_zoomed = "n"; // start off not zoomed in
dvd = 1; //enables DVD

//Set up
_airmax = dvd_vmax * dvd_azf;
hintsilent "Dynamic View Distance 1.03 Active";
dvd_avtime = floor dvd_avtime; 
if (dvd_avtime < 2) then {dvd_avtime = 2};
dvd_steps = (dvd_vpref-dvd_vmin)/(dvd_fpref-dvd_fmin);

// Background process to determine average fps over dvd_avtime seconds and adjust view distance accordingly
dvd_lastfps = dvd_fmin;
[] spawn {while {dvd > 0} do {
_sum = 0; for "_c" from 1 to dvd_avtime do {_sum = (_sum + diag_fps);sleep 1}; dvd_avfps = floor (_sum/dvd_avtime); // Average fps over dvd_avtime sec
_buffps = (dvd_avfps + dvd_lastfps)/2; // should stop huge oscillations in viewdistance
_mfactor = (_buffps - dvd_fmin); if (_mfactor < 0) then {_mfactor = 0};
dvd_vdist = floor (dvd_vmin + (dvd_steps*_mfactor)); // will linearly scale viewdistance from dvd_fmin = dvd_vmin to dvd_fpref = dvd_vpref 
if (dvd_vdist > dvd_vmax) then {dvd_vdist = dvd_vmax};
dvd_lastfps = dvd_avfps;
};
};

// Initial viewdistance 
_oldvdist = dvd_vpref;
setviewdistance dvd_vpref;
sleep (dvd_avtime * 1.5 ); // free up CPU for other init stuff and wait for 1st run through background process

// Adjust viewdistance when zooming/unzooming scopes
while {dvd > 0 } do {
_vdist = dvd_vdist;
/* oldway
if ((cameraView == "GUNNER") and (_zoomed == "y")) then {_vdist = (_vdist * dvd_zf); if (_vdist > dvd_vmax) then {_vdist = dvd_vmax};};
if ((cameraView == "GUNNER") and (_zoomed == "n")) then {_vdist = (_vdist * dvd_zf); if (_vdist > dvd_vmax) then {_vdist = dvd_vmax};_zoomed="y"};
if ((cameraView == "INTERNAL") and (_zoomed == "y")) then {_zoomed="n"};
*/
if (cameraView == "GUNNER") then {_vdist = (_vdist * dvd_zf); if (_vdist > dvd_vmax) then {_vdist = dvd_vmax};};

if (vehicle player iskindof "air") then {_vdist = (_vdist * dvd_azf); if (_vdist > _airmax) then {_vdist = _airmax};hint "ScopeZoom"};

// Smoothly change viewdistance - if it has changed since last time
if (_vdist != _oldvdist) then 
{_inc = ((_vdist - _oldvdist)/10); // setviewdistance increments 1/10 changed to 1/20 for smoothness
_vdist = _oldvdist;
for "_i" from 1 to 10 do {_vdist = (_vdist + _inc); setviewdistance _vdist};
};
_oldvdist = _vdist;

//Debugging output
if (dvd_debug == 1) then {hintsilent format ["av fps:%1, vd:%2",dvd_avfps,_vdist];};

sleep 1;
};