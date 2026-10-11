/*
    Author: mirrorsedgepro-stack
    Description:
        Called from the Mafia loop. Puts a collector crew on the street in racket towns while players
        are near, removes it when they leave, and ends the racket when the whole crew is dead.
    Parameters:
        0: ARRAY - alive players
*/

params ["_players"];

{
    private _city = _x;
    private _centre = getMarkerPos _city;
    private _crew = A3UE_mafiaCollectors getOrDefault [_city, []];

    if (_crew isEqualTo []) then {
        if ((_players findIf { _x distance2D _centre < 500 }) >= 0 && {time >= (A3UE_mafiaCollectorWait getOrDefault [_city, 0])}) then {
            private _pos = [_centre, 0, 120, 3, 0, 0.4, 0, [], [[0, 0], [0, 0]]] call BIS_fnc_findSafePos;
            // not in front of someone's eyes
            if (_pos isNotEqualTo [0, 0] && {(_players findIf { _x distance2D _pos < 150 }) < 0}) then {
                private _grp = createGroup [A3UE_mafiaSide, true];
                _crew = ["capo", "thug", "thug", "enforcer"] apply { [_grp, _pos, _x] call A3UE_fnc_mafiaUnit };
                [_grp, _centre, 100] call BIS_fnc_taskPatrol;
                A3UE_mafiaCollectors set [_city, _crew];
            };
        };
    } else {
        if ((_crew findIf { alive _x }) < 0) then {
            // racket broken
            A3UE_mafiaCollectors deleteAt _city;
            A3UE_mafiaRackets = A3UE_mafiaRackets - [_city];
            [_city, -20] call A3UE_fnc_contestedSupport;
            [0, 250] spawn A3A_fnc_resourcesFIA;
            [0, 3, _city] spawn A3A_fnc_citySupportChange;
            _crew spawn { sleep 600; { deleteVehicle _x } forEach _this };
            ["bust", [_city], format ["The Syndicate's collectors in %1 are dead and the racket is broken. The townsfolk hand over 250 in thanks.", _city]] call A3UE_fnc_mafiaNotify;
            if (!A3UE_mafiaHQKnown && {random 1 < 0.35}) then { ["reveal", "a collector's phone"] call A3UE_fnc_mafiaCommand };
            ["save"] call A3UE_fnc_mafiaState;
        } else {
            if ((_players findIf { _x distance2D _centre < 1000 }) < 0) then {
                { deleteVehicle _x } forEach _crew;
                A3UE_mafiaCollectors deleteAt _city;
                A3UE_mafiaCollectorWait set [_city, time + 300];
            };
        };
    };
} forEach +A3UE_mafiaRackets;
