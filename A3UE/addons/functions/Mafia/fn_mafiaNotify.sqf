/*
    Author: mirrorsedgepro-stack
    Description:
        Writes one "A3UE|event|field|..." line to the server log (the Game Master reads these)
        and optionally shows a hint to players.
    Parameters:
        0: STRING - event name
        1: ARRAY - fields for the log line
        2: STRING - hint text ("" for none)
        3: NUMBER/OBJECT/SIDE - who gets the hint (default everyone)
*/

params [["_event", "", [""]], ["_fields", [], [[]]], ["_hint", "", [""]], ["_to", 0]];

private _clean = _fields apply { ((if (_x isEqualType "") then { _x } else { str _x }) splitString "|") joinString "/" };
diag_log text (["A3UE", _event] + _clean joinString "|");

if (_hint != "") then {
    ["Mafia Syndicate", _hint] remoteExec ["A3A_fnc_customHint", _to];
};
