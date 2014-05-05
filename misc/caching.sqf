_safePos = [_pos, 0, 500, 30, 0, 20, 0] call BIS_fnc_findSafePos;


                _x disableAI "TARGET";
                _x disableAI "AUTOTARGET";
                _x disableAI "MOVE";
                _x disableAI "ANIM";
                _x disableAI "FSM";
                _x enableSimulation false;
                _x allowDamage false;
				_x hideobject true;
	} else {
                _x allowDamage true;
                _x enableSimulation true;
                _x hideobject false;
                _x enableAI "TARGET";
                _x enableAI "AUTOTARGET";
                _x enableAI "MOVE";
                _x enableAI "ANIM";
                _x enableAI "FSM";