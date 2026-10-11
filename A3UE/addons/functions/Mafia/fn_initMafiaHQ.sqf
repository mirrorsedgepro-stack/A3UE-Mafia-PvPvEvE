/*
    Author: mirrorsedgepro-stack
    Description:
        Picks (or is given) the Syndicate hideout position. Nothing is spawned here: the hideout is
        populated by A3UE_fnc_mafiaSpawnHQ when players come near.
        A hideout is at least 2.5 km from the rebel HQ, 600 m from any military zone and 800 m from players.
    Parameters:
        0: ARRAY - proposed position ([] to pick one near a random town)
        1: BOOLEAN - accept the proposed position without the distance checks
    Returns:
        BOOLEAN - true if a hideout was set
*/

params [["_pos", [], [[]]], ["_force", false, [false]]];

if (!isServer) exitWith { false };

private _rebHQ = getMarkerPos (missionNamespace getVariable ["respawnTeamPlayer", "respawn_guerrila"]);
private _zones = [];
{ _zones append (missionNamespace getVariable [_x, []]) } forEach ["airportsX", "outposts", "milbases", "resourcesX", "factories", "seaports"];
private _players = (allPlayers - entities "HeadlessClient_F") select { alive _x };

private _ok = {
    params ["_p"];
    count _p >= 2
    && {!surfaceIsWater _p}
    && {_p distance2D _rebHQ >= 2500}
    && {(_zones findIf { (getMarkerPos _x) distance2D _p < 600 }) < 0}
    && {(_players findIf { _x distance2D _p < 800 }) < 0}
};

if (_pos isEqualTo []) then {
    for "_i" from 1 to 80 do {
        private _try = [getMarkerPos (selectRandom citiesX), 350, 1100, 6, 0, 0.25, 0, [], [[0, 0], [0, 0]]] call BIS_fnc_findSafePos;
        if (_try isNotEqualTo [0, 0] && {[_try] call _ok}) exitWith { _pos = _try };
    };
} else {
    if (!_force && {!([_pos] call _ok)}) then { _pos = [] };
};

if (_pos isEqualTo []) exitWith {
    diag_log text "A3UE|error|no valid hideout position found";
    false
};

["despawn"] call A3UE_fnc_mafiaSpawnHQ;
A3UE_mafiaHQ = [_pos select 0, _pos select 1, 0];
A3UE_mafiaHQKnown = false;
deleteMarker "A3UE_mafiaHQ";

["hq", [mapGridPosition A3UE_mafiaHQ], "Word on the street: the Syndicate has gone to ground in a new hideout somewhere on the island."] call A3UE_fnc_mafiaNotify;
["save"] call A3UE_fnc_mafiaState;
true
