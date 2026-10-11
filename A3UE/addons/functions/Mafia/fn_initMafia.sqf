/*
    Author: mirrorsedgepro-stack
    Description:
        Starts the Mafia layer on the server once the Antistasi campaign has loaded.
        Everything runs on the server; clients only get actions sent to them, so they don't need this mod.
*/

if (!isServer) exitWith {};
if !(isClass (configFile >> "CfgPatches" >> "A3A_core")) exitWith {};

[] spawn {
    waitUntil {
        sleep 5;
        missionNamespace getVariable ["serverInitDone", false] && {!isNil "membersX"} && {!isNil "citiesX"} && {!isNil "A3A_townData"}
    };
    sleep 20;

    // The Mafia fights on Antistasi Ultimate's rival side (east, shared with the invaders).
    A3UE_mafiaSide = missionNamespace getVariable ["Rivals", east];
    ["load"] call A3UE_fnc_mafiaState;
    if (A3UE_mafiaHQ isEqualTo []) then { [] call A3UE_fnc_initMafiaHQ };

    // Player actions: joining and leaving the Syndicate (only shown while it is open to players).
    [[], {
        if (!hasInterface) exitWith {};
        waitUntil { sleep 1; !isNull player };
        private _add = {
            player addAction ["<t color='#c084fc'>Join the Syndicate</t>", { [player, true] remoteExec ["A3UE_fnc_mafiaJoin", 2] }, nil, -5, false, true, "",
                "_target == _this && {missionNamespace getVariable ['A3UE_mafiaPlayable', false]} && {side group _this != east}"];
            player addAction ["<t color='#c084fc'>Leave the Syndicate</t>", { [player, false] remoteExec ["A3UE_fnc_mafiaJoin", 2] }, nil, -5, false, true, "",
                "_target == _this && {missionNamespace getVariable ['A3UE_mafiaPlayable', false]} && {side group _this == east}"];
        };
        call _add;
        player addEventHandler ["Respawn", _add];
    }] remoteExec ["spawn", 0, "A3UE_client"];

    // Syndicate players can rob the rebel HQ crate.
    if (!isNil "boxX" && {!isNull boxX}) then {
        [boxX, ["<t color='#c084fc'>Rob the rebel war chest</t>", { params ["_t", "_c"]; [_t, _c] remoteExec ["A3UE_fnc_raidHQ", 2] }, nil, 5, true, true, "",
            "side group _this == east", 5]] remoteExec ["addAction", 0, "A3UE_boxX"];
    };

    diag_log text format ["A3UE|ready|%1|%2|%3", mapGridPosition A3UE_mafiaHQ, round A3UE_mafiaFunds, count A3UE_mafiaRackets];
    [] spawn A3UE_fnc_mafiaLoop;
};
