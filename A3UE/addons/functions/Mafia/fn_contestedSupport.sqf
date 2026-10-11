/*
    Author: mirrorsedgepro-stack
    Description:
        Calculates 3-way town sentiment and contested town support across
        Occupants, Rebels, and Mafia.
    Parameters:
        0: STRING - Marker name of the city
        1: NUMBER - Mafia influence change (-100 to 100)
    Returns:
        ARRAY - [_occSupport, _rebSupport, _mafiaSupport]
*/

params [["_marker", "", [""]], ["_mafiaDelta", 0, [0]]];

if (_marker == "") exitWith { [0, 0, 0] };

private _mafiaSupport = _marker getVariable ["A3UE_mafiaSupport", 0];
private _rebSupport = _marker getVariable ["support", 0];
private _occSupport = 100 - _rebSupport - _mafiaSupport;

_mafiaSupport = (_mafiaSupport + _mafiaDelta) min (100 - _rebSupport) max 0;
_occSupport = (100 - _rebSupport - _mafiaSupport) max 0;

_marker setVariable ["A3UE_mafiaSupport", _mafiaSupport, true];

// Trigger marker color shift if Mafia is dominant
if (_mafiaSupport > _rebSupport && _mafiaSupport > _occSupport) then {
    _marker setMarkerColor "ColorYellow";
};

[_occSupport, _rebSupport, _mafiaSupport];
