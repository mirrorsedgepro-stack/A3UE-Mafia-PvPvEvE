/*
    Author: mirrorsedgepro-stack
    Description:
        Handles HQ crate raiding between rival human factions (Rebels vs Mafia).
        Allows plundering weapons and cash reserves from the rival ammo crate.
    Parameters:
        0: OBJECT - Target ammo crate being raided
        1: OBJECT - Player unit performing the raid
*/

params [["_targetBox", objNull, [objNull]], ["_player", objNull, [objNull]]];

if (isNull _targetBox || isNull _player) exitWith {};

private _playerSide = side group _player;
private _isMafiaTarget = _targetBox getVariable ["A3UE_isMafiaBox", false];
private _isRebelTarget = (_targetBox == boxX);

if (!_isMafiaTarget && !_isRebelTarget) exitWith {
    ["This container cannot be raided.", "align='center' size='0.8' color='#ff4444'"] call A3A_fnc_customHint;
};

// Siphon cash reserves
if (_isMafiaTarget && _playerSide == independent) then {
    private _stolen = (round (A3UE_mafiaFunds * 0.2)) min 2500;
    A3UE_mafiaFunds = (A3UE_mafiaFunds - _stolen) max 0;
    publicVariable "A3UE_mafiaFunds";
    
    [0, _stolen] remoteExec ["A3A_fnc_resourcesFIA", 2];
    [format ["Raid successful! Siphoned %1 € from the Mafia hideout.", _stolen], "align='center' size='0.8' color='#22c55e'"] call A3A_fnc_customHint;
};

if (_isRebelTarget && _playerSide == civilian) then {
    private _stolen = 1500;
    A3UE_mafiaFunds = A3UE_mafiaFunds + _stolen;
    publicVariable "A3UE_mafiaFunds";
    
    [0, -_stolen] remoteExec ["A3A_fnc_resourcesFIA", 2];
    [format ["Heist successful! Siphoned %1 € from the Rebel headquarters.", _stolen], "align='center' size='0.8' color='#a855f7'"] call A3A_fnc_customHint;
};
