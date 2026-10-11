/*
    Author: mirrorsedgepro-stack
    Description:
        The Syndicate's heartbeat, one pass every 30 seconds on the server:
        hideout spawn and despawn, discovery, the Don's succession, new rackets, collectors,
        racket income, member sides and saving.
*/

if (!isServer) exitWith {};

while { true } do {
    sleep 30;
    private _players = (allPlayers - entities "HeadlessClient_F") select { alive _x };
    private _rebels = _players select { side group _x == teamPlayer };

    // A new Don after the old one was killed: the family moves
    if (A3UE_mafiaCompromised && {time >= A3UE_mafiaDonBackAt}) then {
        A3UE_mafiaCompromised = false;
        [] call A3UE_fnc_initMafiaHQ;
    };

    // Hideout comes alive when players are near
    if (A3UE_mafiaHQ isNotEqualTo []) then {
        private _spawned = A3UE_mafiaHQObjects isNotEqualTo [];
        if (!_spawned && {(_players findIf { _x distance2D A3UE_mafiaHQ < 1200 }) >= 0}) then { ["spawn"] call A3UE_fnc_mafiaSpawnHQ };
        if (_spawned && {(_players findIf { _x distance2D A3UE_mafiaHQ < 1600 }) < 0}) then { ["despawn"] call A3UE_fnc_mafiaSpawnHQ };
        if (!A3UE_mafiaHQKnown && {(_rebels findIf { _x distance2D A3UE_mafiaHQ < 250 }) >= 0}) then { ["reveal", "a rebel patrol"] call A3UE_fnc_mafiaCommand };
    };

    // The family expands while it has a Don
    if (time >= A3UE_mafiaNextRacket) then {
        A3UE_mafiaNextRacket = time + 900 + random 600;
        if (!A3UE_mafiaCompromised && {count A3UE_mafiaRackets < 3 + floor ((missionNamespace getVariable ["tierWar", 1]) / 2)}) then {
            [""] call A3UE_fnc_racketSetup;
        };
    };
    [_players] call A3UE_fnc_racketCollectors;

    if (time >= A3UE_mafiaNextIncome) then {
        A3UE_mafiaNextIncome = time + 600;
        { A3UE_mafiaFunds = A3UE_mafiaFunds + 40 + 3 * (A3UE_mafiaSupport getOrDefault [_x, 0]) } forEach A3UE_mafiaRackets;
    };

    // Syndicate players stay on the Syndicate's side through respawn and reconnect
    if (A3UE_mafiaPlayable) then {
        {
            if (getPlayerUID _x in A3UE_mafiaMembers && {side group _x != A3UE_mafiaSide}) then {
                if (isNull A3UE_mafiaPlayerGroup) then { A3UE_mafiaPlayerGroup = createGroup [A3UE_mafiaSide, false] };
                [_x] joinSilent A3UE_mafiaPlayerGroup;
            };
        } forEach _players;
    };

    if (time >= A3UE_mafiaNextSave) then {
        A3UE_mafiaNextSave = time + 600;
        ["save", true] call A3UE_fnc_mafiaState;
    };
};
