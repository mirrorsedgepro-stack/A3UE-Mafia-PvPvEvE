/*
    Author: mirrorsedgepro-stack
    Description:
        Loads or saves the Mafia state in the server profile, per map and campaign.
    Parameters:
        0: STRING - "load" or "save"
        1: BOOLEAN - write the profile to disk now (save only)
*/

params [["_mode", "save", [""]], ["_flush", false, [false]]];

if (!isServer) exitWith { false };

private _key = format ["A3UE_mafia_%1", worldName];
private _campaign = str (missionNamespace getVariable ["campaignID", ""]);

if (_mode == "load") exitWith {
    A3UE_mafiaHQ = [];
    A3UE_mafiaHQKnown = false;
    A3UE_mafiaFunds = 1500;
    A3UE_mafiaHR = 15;
    A3UE_mafiaRackets = [];
    A3UE_mafiaSupport = createHashMap;
    A3UE_mafiaMembers = [];
    A3UE_mafiaPlayable = false;
    A3UE_mafiaDonBackAt = 0;
    A3UE_mafiaCompromised = false;

    private _saved = profileNamespace getVariable [_key, []];
    if (_saved isEqualType [] && {count _saved >= 10} && {(_saved select 0) isEqualTo _campaign}) then {
        _saved params ["", "_hq", "_known", "_funds", "_hr", "_rackets", "_support", "_members", "_playable", "_donOut"];
        A3UE_mafiaHQ = _hq;
        A3UE_mafiaHQKnown = _known;
        A3UE_mafiaFunds = _funds;
        A3UE_mafiaHR = _hr;
        A3UE_mafiaRackets = _rackets select { _x in citiesX };
        A3UE_mafiaSupport = createHashMapFromArray _support;
        A3UE_mafiaMembers = _members;
        A3UE_mafiaPlayable = _playable;
        if (_donOut > 0) then {
            A3UE_mafiaDonBackAt = time + _donOut;
            A3UE_mafiaCompromised = true;
        };
    };

    // Runtime only
    A3UE_theDon = objNull;
    A3UE_mafiaBox = objNull;
    A3UE_mafiaHQUnits = [];
    A3UE_mafiaHQObjects = [];
    A3UE_mafiaCollectors = createHashMap;
    A3UE_mafiaCollectorWait = createHashMap;
    A3UE_mafiaHitGroup = grpNull;
    A3UE_mafiaPlayerGroup = grpNull;
    A3UE_mafiaLastRaid = -1e6;
    A3UE_mafiaLastHeist = -1e6;
    A3UE_mafiaNextRacket = time + 600 + random 600;
    A3UE_mafiaNextIncome = time + 600;
    A3UE_mafiaNextSave = time + 600;

    publicVariable "A3UE_mafiaPlayable";
    if (A3UE_mafiaHQKnown && {A3UE_mafiaHQ isNotEqualTo []}) then { ["reveal", "quiet"] call A3UE_fnc_mafiaCommand };
    true
};

private _support = (keys A3UE_mafiaSupport) apply { [_x, A3UE_mafiaSupport get _x] };
profileNamespace setVariable [_key, [
    _campaign, A3UE_mafiaHQ, A3UE_mafiaHQKnown, A3UE_mafiaFunds, A3UE_mafiaHR, A3UE_mafiaRackets, _support,
    A3UE_mafiaMembers, A3UE_mafiaPlayable, (A3UE_mafiaDonBackAt - time) max 0
]];
if (_flush) then { saveProfileNamespace };
true
