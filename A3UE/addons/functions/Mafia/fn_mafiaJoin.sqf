/*
    Author: mirrorsedgepro-stack
    Description:
        EXPERIMENTAL. Moves a player into or out of the Syndicate. Members fight on the Mafia's side
        (east) and are hostile to the rebels; membership is kept by player UID and re-applied after
        respawn and reconnect by the Mafia loop. Only works while A3UE_mafiaPlayable is true.
    Parameters:
        0: OBJECT - player
        1: BOOLEAN - true to join, false to leave
*/

params [["_player", objNull, [objNull]], ["_join", true, [true]]];

if (!isServer) exitWith {};
if (isNull _player || {!isPlayer _player}) exitWith {};
if (isRemoteExecuted && {!(remoteExecutedOwner in [2, owner _player])}) exitWith {};
if (!A3UE_mafiaPlayable) exitWith {};

private _uid = getPlayerUID _player;

if (_join) then {
    if (isNull A3UE_mafiaPlayerGroup) then { A3UE_mafiaPlayerGroup = createGroup [A3UE_mafiaSide, false] };
    [_player] joinSilent A3UE_mafiaPlayerGroup;
    A3UE_mafiaMembers pushBackUnique _uid;
    if (A3UE_mafiaHQ isNotEqualTo []) then { _player setPosATL (A3UE_mafiaHQ getPos [15 + random 10, random 360]) };
    ["join", [name _player], format ["%1 has sworn in with the Syndicate.", name _player]] call A3UE_fnc_mafiaNotify;
} else {
    A3UE_mafiaMembers = A3UE_mafiaMembers - [_uid];
    [_player] joinSilent (createGroup [teamPlayer, true]);
    _player setPosATL ((getMarkerPos (missionNamespace getVariable ["respawnTeamPlayer", "respawn_guerrila"])) getPos [10, random 360]);
    ["leave", [name _player], format ["%1 has walked away from the Syndicate.", name _player]] call A3UE_fnc_mafiaNotify;
};
["save"] call A3UE_fnc_mafiaState;
