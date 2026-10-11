/*
    Author: mirrorsedgepro-stack
    Description:
        Sets up a Syndicate protection racket in the given town.
        Yields periodic dirty income ticks and informant intel to the Mafia.
    Parameters:
        0: STRING - City marker name
        1: OBJECT - Capo / Mafia player initiating the racket
*/

params [["_marker", "", [""]], ["_player", objNull, [objNull]]];

if (_marker == "") exitWith {};

if (_marker in A3UE_mafiaRackets) exitWith {
    ["This town is already under Mafia protection.", "align='center' size='0.8' color='#eab308'"] call A3A_fnc_customHint;
};

A3UE_mafiaRackets pushBack _marker;
publicVariable "A3UE_mafiaRackets";

// Initial payout & boost
private _take = 750;
A3UE_mafiaFunds = A3UE_mafiaFunds + _take;
publicVariable "A3UE_mafiaFunds";

[_marker, 15] call A3UE_fnc_contestedSupport;

[
    format ["Protection racket established in %1. Collected %2 € street tax.", _marker, _take],
    "align='center' size='0.8' color='#a855f7'"
] call A3A_fnc_customHint;

diag_log format ["[A3UE] Protection racket established in %1 by %2", _marker, _player];
