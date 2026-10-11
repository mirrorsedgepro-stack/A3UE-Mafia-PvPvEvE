/*
    Author: mirrorsedgepro-stack
    Description:
        One-paragraph summary of the Syndicate, for the Game Master and for intel reports.
    Parameters:
        0: BOOLEAN - true to include what the rebels haven't found out yet (the hideout grid)
    Returns:
        STRING
*/

params [["_full", false, [false]]];

private _parts = [format ["the Mafia Syndicate has %1 in funds", round A3UE_mafiaFunds]];
_parts pushBack (if (A3UE_mafiaRackets isEqualTo []) then { "no rackets running" } else {
    format ["rackets in %1", A3UE_mafiaRackets joinString ", "]
});
_parts pushBack (if (time >= A3UE_mafiaDonBackAt) then { "Don Salvatore is alive" } else {
    format ["the Don is dead, a successor takes over in %1 min", ceil ((A3UE_mafiaDonBackAt - time) / 60)]
});
if (A3UE_mafiaHQ isNotEqualTo []) then {
    if (A3UE_mafiaHQKnown) then {
        _parts pushBack format ["its hideout is at grid %1", mapGridPosition A3UE_mafiaHQ];
    } else {
        _parts pushBack (["its hideout has not been found", format ["its hideout is at grid %1 (the rebels don't know this yet)", mapGridPosition A3UE_mafiaHQ]] select _full);
    };
};
if (A3UE_mafiaPlayable) then { _parts pushBack format ["%1 players have joined it", count A3UE_mafiaMembers] };

_parts joinString ", "
