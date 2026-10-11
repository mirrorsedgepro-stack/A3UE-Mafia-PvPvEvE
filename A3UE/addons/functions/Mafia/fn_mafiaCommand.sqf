/*
    Author: mirrorsedgepro-stack
    Description:
        Admin / Game Master commands for the Syndicate (the @a3gm bridge's MAFIA action calls this).
    Parameters:
        0: STRING - status | relocate | racket | reveal | hit | funds | playable
        1: STRING - argument: racket <town or "">, reveal <how it was found>, hit <player name>,
                    funds <amount to add>, playable <on|off>
    Returns:
        ARRAY - [success BOOLEAN, detail STRING]
*/

params [["_sub", "status", [""]], ["_arg", "", [""]]];

if (!isServer) exitWith { [false, "server only"] };
if (isNil "A3UE_mafiaFunds") exitWith { [false, "the Mafia layer hasn't started yet"] };

switch (toLower _sub) do {
    case "status": { [true, [true] call A3UE_fnc_mafiaStatus] };
    case "relocate": {
        if ([] call A3UE_fnc_initMafiaHQ) then { [true, format ["new hideout at grid %1", mapGridPosition A3UE_mafiaHQ]] } else { [false, "no valid hideout position found"] }
    };
    case "racket": {
        private _city = [_arg] call A3UE_fnc_racketSetup;
        if (_city == "") then { [false, "no town free for a racket (unknown town, already taken, or rebels too strong everywhere)"] } else { [true, format ["racket started in %1", _city]] }
    };
    case "reveal": {
        if (A3UE_mafiaHQ isEqualTo []) exitWith { [false, "no hideout"] };
        A3UE_mafiaHQKnown = true;
        deleteMarker "A3UE_mafiaHQ";
        private _mrk = createMarker ["A3UE_mafiaHQ", A3UE_mafiaHQ];
        _mrk setMarkerType "hd_warning";
        _mrk setMarkerColor "ColorBrown";
        _mrk setMarkerText "Syndicate hideout";
        if (_arg != "quiet") then {
            ["found", [mapGridPosition A3UE_mafiaHQ, _arg], format ["The Syndicate hideout has been found at grid %1. It's on your map.", mapGridPosition A3UE_mafiaHQ], teamPlayer] call A3UE_fnc_mafiaNotify;
        };
        [true, format ["hideout marked at grid %1", mapGridPosition A3UE_mafiaHQ]]
    };
    case "hit": {
        private _players = (allPlayers - entities "HeadlessClient_F") select { alive _x };
        private _idx = _players findIf { toLower (name _x) == toLower _arg };
        if (_idx < 0 && {_arg == ""} && {_players isNotEqualTo []}) then { _idx = floor random count _players };
        if (_idx < 0) exitWith { [false, "no such player"] };
        if (!isNull A3UE_mafiaHitGroup && {({ alive _x } count units A3UE_mafiaHitGroup) > 0}) exitWith { [false, "a hit squad is already out"] };
        [_players select _idx, 30] spawn A3UE_fnc_mafiaHitSquad;
        [true, format ["hit squad sent after %1", name (_players select _idx)]]
    };
    case "funds": {
        A3UE_mafiaFunds = (A3UE_mafiaFunds + parseNumber _arg) max 0;
        [true, format ["Syndicate funds now %1", round A3UE_mafiaFunds]]
    };
    case "playable": {
        A3UE_mafiaPlayable = (toLower _arg) in ["on", "true", "1", "yes"];
        publicVariable "A3UE_mafiaPlayable";
        ["save"] call A3UE_fnc_mafiaState;
        [true, format ["players %1 join the Syndicate", ["can no longer", "can now"] select A3UE_mafiaPlayable]]
    };
    default { [false, "unknown Mafia command (status, relocate, racket, reveal, hit, funds, playable)"] };
};
