/*
    Author: mirrorsedgepro-stack
    Description:
        Populates the Syndicate hideout (the Don, his guards, the stash crate, a flag and a car),
        or removes it again. Called by the Mafia loop as players come and go.
    Parameters:
        0: STRING - "spawn" or "despawn"
*/

params [["_mode", "spawn", [""]]];

if (!isServer) exitWith {};

if (_mode == "despawn") exitWith {
    { deleteVehicle _x } forEach (A3UE_mafiaHQUnits + A3UE_mafiaHQObjects);
    A3UE_mafiaHQUnits = [];
    A3UE_mafiaHQObjects = [];
    A3UE_theDon = objNull;
    A3UE_mafiaBox = objNull;
};

if (A3UE_mafiaHQObjects isNotEqualTo [] || {A3UE_mafiaHQ isEqualTo []}) exitWith {};

private _pos = A3UE_mafiaHQ;

// Stash crate: what rebels raid
private _box = createVehicle ["Box_Syndicate_Wps_F", _pos getPos [3, 45], [], 0, "NONE"];
clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
clearItemCargoGlobal _box;
clearBackpackCargoGlobal _box;
_box addWeaponCargoGlobal ["hgun_PDW2000_F", 4];
_box addWeaponCargoGlobal ["SMG_02_F", 2];
_box addMagazineCargoGlobal ["30Rnd_9x21_Mag", 20];
_box addMagazineCargoGlobal ["30Rnd_9x21_Mag_SMG_02", 12];
_box addItemCargoGlobal ["FirstAidKit", 6];
_box setVariable ["A3UE_isMafiaBox", true, true];
A3UE_mafiaBox = _box;
[_box, ["<t color='#c084fc'>Raid the Syndicate stash</t>", { params ["_t", "_c"]; [_t, _c] remoteExec ["A3UE_fnc_raidHQ", 2] }, nil, 5, true, true, "",
    "alive _target && {side group _this != east}", 5]] remoteExec ["addAction", 0, _box];

private _flag = createVehicle ["Flag_Altis_F", _pos getPos [3, 315], [], 0, "NONE"];
private _car = createVehicle ["C_SUV_01_F", _pos getPos [12, 200], [], 4, "NONE"];
A3UE_mafiaHQObjects = [_box, _flag, _car];

// The Don and two capos stay put; he is away for a while after being killed
private _inner = createGroup [A3UE_mafiaSide, true];
if (time >= A3UE_mafiaDonBackAt) then {
    private _don = [_inner, _pos, "don"] call A3UE_fnc_mafiaUnit;
    _don disableAI "PATH";
    _don setRank "COLONEL";
    _don addEventHandler ["Killed", {
        params ["_unit", "_killer", "_instigator"];
        [_unit, _killer, _instigator] call A3UE_fnc_mafiaBossKilled;
    }];
    A3UE_theDon = _don;
    A3UE_mafiaHQUnits pushBack _don;
};
for "_i" from 1 to 2 do { A3UE_mafiaHQUnits pushBack ([_inner, _pos, "capo"] call A3UE_fnc_mafiaUnit) };
_inner setBehaviourStrong "SAFE";

// Guards patrol around the hideout; a richer family keeps more of them
private _guards = (4 + floor (A3UE_mafiaFunds / 1500)) min 10;
private _outer = createGroup [A3UE_mafiaSide, true];
for "_i" from 1 to _guards do {
    private _role = ["thug", "thug", "enforcer", "hitman"] select (_i mod 4);
    A3UE_mafiaHQUnits pushBack ([_outer, _pos getPos [25, random 360], _role] call A3UE_fnc_mafiaUnit);
};
[_outer, _pos, 70] call BIS_fnc_taskPatrol;

["hqspawn", [mapGridPosition _pos, count A3UE_mafiaHQUnits]] call A3UE_fnc_mafiaNotify;
