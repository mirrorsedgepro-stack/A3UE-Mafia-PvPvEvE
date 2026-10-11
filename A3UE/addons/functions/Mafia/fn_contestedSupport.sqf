/*
    Author: mirrorsedgepro-stack
    Description:
        Changes and returns the Syndicate's hold on a town. Occupant and rebel support are Antistasi's
        own figures (A3A_townData); the Mafia's share is kept alongside and can't exceed what the rebels leave.
    Parameters:
        0: STRING - city name (an entry of citiesX)
        1: NUMBER - change in Mafia influence
    Returns:
        ARRAY - [occupant support, rebel support, Mafia influence]
*/

params [["_city", "", [""]], ["_delta", 0, [0]]];

private _data = A3A_townData getOrDefault [_city, []];
if (_data isEqualTo []) exitWith { [0, 0, 0] };
_data params ["", "", "_gov", "_reb"];

private _mafia = ((A3UE_mafiaSupport getOrDefault [_city, 0]) + _delta) max 0 min ((100 - _reb) max 0);
A3UE_mafiaSupport set [_city, _mafia];

[_gov, _reb, _mafia]
