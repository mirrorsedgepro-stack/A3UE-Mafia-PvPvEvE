/*
    Author: mirrorsedgepro-stack
    Description:
        The Don has been killed: the Syndicate loses money and men, rebels earn a bounty if they did it,
        and the family moves to a new hideout with a new Don after half an hour.
    Parameters:
        0: OBJECT - the Don
        1: OBJECT - killer
        2: OBJECT - instigator
*/

params ["_unit", ["_killer", objNull], ["_instigator", objNull]];

if (!isServer) exitWith {};

private _by = if (isNull _instigator) then { _killer } else { _instigator };
private _side = side group _by;
private _who = if (isPlayer _by) then { name _by } else { ["an unknown gunman", "the rebels"] select (_side == teamPlayer) };

private _lostFunds = round (A3UE_mafiaFunds * 0.35);
private _lostHR = round (A3UE_mafiaHR * 0.25);
A3UE_mafiaFunds = (A3UE_mafiaFunds - _lostFunds) max 0;
A3UE_mafiaHR = (A3UE_mafiaHR - _lostHR) max 0;
{ [_x, -10] call A3UE_fnc_contestedSupport } forEach A3UE_mafiaRackets;

if (_side == teamPlayer) then { [5, 1000] spawn A3A_fnc_resourcesFIA };

A3UE_theDon = objNull;
A3UE_mafiaDonBackAt = time + 1800;
A3UE_mafiaCompromised = true;

["don", [_who, _side, _lostFunds],
    format ["Don Salvatore is dead, killed by %1. The Syndicate has lost %2 and will go to ground to pick a successor.", _who, _lostFunds]
] call A3UE_fnc_mafiaNotify;
["save"] call A3UE_fnc_mafiaState;
