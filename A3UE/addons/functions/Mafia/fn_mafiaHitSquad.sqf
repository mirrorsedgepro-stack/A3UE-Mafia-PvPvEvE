/*
    Author: mirrorsedgepro-stack
    Description:
        Sends five Syndicate gunmen after a player. Spawn this (it sleeps); only one squad is out at a time.
        The squad hunts for 15 minutes and is removed once no player is near it.
    Parameters:
        0: OBJECT - the player to hunt
        1: NUMBER - seconds before the squad sets out
*/

params [["_target", objNull, [objNull]], ["_delay", 180, [0]]];

if (!isServer || {isNull _target}) exitWith {};
if (!isNull A3UE_mafiaHitGroup && {({ alive _x } count units A3UE_mafiaHitGroup) > 0}) exitWith {};

sleep _delay;
if (!alive _target) exitWith {};
if (!isNull A3UE_mafiaHitGroup && {({ alive _x } count units A3UE_mafiaHitGroup) > 0}) exitWith {};

private _pos = [getPosATL _target, 400, 650, 4, 0, 0.4, 0, [], [[0, 0], [0, 0]]] call BIS_fnc_findSafePos;
if (_pos isEqualTo [0, 0]) exitWith { ["error", ["no room for a hit squad"]] call A3UE_fnc_mafiaNotify };

private _grp = createGroup [A3UE_mafiaSide, true];
A3UE_mafiaHitGroup = _grp;
private _units = ["capo", "thug", "thug", "enforcer", "hitman"] apply { [_grp, _pos, _x] call A3UE_fnc_mafiaUnit };
_grp setBehaviourStrong "AWARE";
_grp setSpeedMode "FULL";

["hit", [name _target, mapGridPosition _pos], "The Syndicate has put a price on your head. Gunmen are on their way.", _target] call A3UE_fnc_mafiaNotify;

private _end = time + 900;
waitUntil {
    if (alive _target) then { _grp move (getPosATL _target) };
    sleep 20;
    time > _end || {!alive _target} || {(_units findIf { alive _x }) < 0}
};

// leave quietly once nobody is watching
private _gone = time + 600;
waitUntil {
    sleep 15;
    private _lead = leader _grp;
    time > _gone || {isNull _lead} || {(((allPlayers - entities "HeadlessClient_F") select { alive _x }) findIf { _x distance2D _lead < 800 }) < 0}
};
{ deleteVehicle _x } forEach _units;
