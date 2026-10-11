/*
    Author: mirrorsedgepro-stack
    Description:
        A player robs the rival faction's crate. Rebels take a fifth of the Syndicate's money (up to 2500)
        from the hideout stash; Syndicate players take up to 1500 from the rebel HQ crate.
        Runs on the server, called from the crate's action. One raid per crate every 30 minutes.
    Parameters:
        0: OBJECT - crate
        1: OBJECT - player
*/

params [["_box", objNull, [objNull]], ["_player", objNull, [objNull]]];

if (!isServer) exitWith {};
if (isNull _box || {isNull _player} || {!alive _player} || {!isPlayer _player}) exitWith {};
if (isRemoteExecuted && {!(remoteExecutedOwner in [2, owner _player])}) exitWith {};
if (_player distance _box > 10) exitWith {};

private _to = owner _player;
private _side = side group _player;
private _tell = { ["Mafia Syndicate", _this] remoteExec ["A3A_fnc_customHint", _to] };

if (_box getVariable ["A3UE_isMafiaBox", false] && {_side == teamPlayer}) exitWith {
    if (time - A3UE_mafiaLastRaid < 1800) exitWith { "The stash has just been cleaned out. Give them time to refill it." call _tell };
    private _stolen = (round (A3UE_mafiaFunds * 0.2)) min 2500;
    if (_stolen <= 0) exitWith { "The Syndicate is broke. Nothing to take." call _tell };
    A3UE_mafiaLastRaid = time;
    A3UE_mafiaFunds = A3UE_mafiaFunds - _stolen;
    [0, _stolen] spawn A3A_fnc_resourcesFIA;
    if (!A3UE_mafiaHQKnown) then { ["reveal", "quiet"] call A3UE_fnc_mafiaCommand };
    ["raid", [name _player, _stolen], format ["%1 raided the Syndicate stash and took %2 for the rebels. The family will want payback.", name _player, _stolen], teamPlayer] call A3UE_fnc_mafiaNotify;
    [_player, 180 + random 120] spawn A3UE_fnc_mafiaHitSquad;
    ["save"] call A3UE_fnc_mafiaState;
};

if (!isNil "boxX" && {_box isEqualTo boxX} && {_side == A3UE_mafiaSide}) exitWith {
    if (time - A3UE_mafiaLastHeist < 1800) exitWith { "The war chest was hit not long ago. It's being watched." call _tell };
    private _stolen = 1500 min (server getVariable ["resourcesFIA", 0]);
    if (_stolen <= 0) exitWith { "The rebels are broke. Nothing to take." call _tell };
    A3UE_mafiaLastHeist = time;
    A3UE_mafiaFunds = A3UE_mafiaFunds + _stolen;
    [0, -_stolen] spawn A3A_fnc_resourcesFIA;
    ["heist", [name _player, _stolen], format ["The Syndicate has robbed the rebel war chest: %1 is gone.", _stolen]] call A3UE_fnc_mafiaNotify;
    ["save"] call A3UE_fnc_mafiaState;
};
