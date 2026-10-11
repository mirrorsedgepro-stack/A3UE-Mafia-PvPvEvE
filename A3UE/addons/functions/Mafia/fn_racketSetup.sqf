/*
    Author: mirrorsedgepro-stack
    Description:
        The Syndicate starts a protection racket in a town. Rackets pay the family every ten minutes
        and cost the rebels a little support there. Rebels end one by killing its collectors.
    Parameters:
        0: STRING - city name ("" to pick a town where the rebels are weak)
    Returns:
        STRING - the city, or "" if no racket was started
*/

params [["_city", "", [""]]];

if (!isServer) exitWith { "" };

if (_city == "") then {
    private _open = citiesX select {
        !(_x in A3UE_mafiaRackets) && {((A3A_townData getOrDefault [_x, [0, 0, 0, 100]]) select 3) < 60}
    };
    if (_open isNotEqualTo []) then { _city = selectRandom _open };
} else {
    // accept any spelling of a known town
    private _idx = citiesX findIf { toLower _x == toLower _city };
    _city = if (_idx < 0) then { "" } else { citiesX select _idx };
};
if (_city == "" || {_city in A3UE_mafiaRackets}) exitWith { "" };

A3UE_mafiaRackets pushBack _city;
A3UE_mafiaFunds = A3UE_mafiaFunds + 300;
[_city, 15] call A3UE_fnc_contestedSupport;
[0, -3, _city] spawn A3A_fnc_citySupportChange;

["racket", [_city], format ["Word on the street: the Syndicate is running protection in %1. Kill its collectors there to break the racket.", _city]] call A3UE_fnc_mafiaNotify;
["save"] call A3UE_fnc_mafiaState;
_city
