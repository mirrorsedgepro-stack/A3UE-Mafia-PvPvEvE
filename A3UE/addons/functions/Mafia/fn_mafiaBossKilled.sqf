/*
    Author: mirrorsedgepro-stack
    Description:
        Triggered when The Don (Syndicate Boss) or Petros is assassinated.
        Applies HR and monetary penalties and forces the victim's faction to relocate.
    Parameters:
        0: OBJECT - Victim unit
        1: OBJECT - Killer unit
        2: OBJECT - Instigator unit
*/

params ["_unit", "_killer", "_instigator"];

if (!isServer) exitWith {};

private _killerSide = side group _killer;
if (isNull _killer) then { _killerSide = side group _instigator; };

diag_log format ["[A3UE] The Don has been assassinated! Killer: %1 (Side: %2)", _killer, _killerSide];

// 1. Economic and HR Penalties for Mafia
private _lostFunds = round (A3UE_mafiaFunds * 0.35);
private _lostHR = round (A3UE_mafiaHR * 0.25);

A3UE_mafiaFunds = (A3UE_mafiaFunds - _lostFunds) max 0;
A3UE_mafiaHR = (A3UE_mafiaHR - _lostHR) max 0;

publicVariable "A3UE_mafiaFunds";
publicVariable "A3UE_mafiaHR";

// 2. Broadcast World Alert to All Players
[
    format ["<t size='1.1' color='#ff2222'>CONTRACT COMPLETED</t><br/>Don Salvatore was eliminated by %1!<br/>The Syndicate has lost %2 € and %3 HR, forcing remaining Capos into hiding.", _killerSide, _lostFunds, _lostHR],
    "align='center' size='0.8'"
] remoteExec ["A3A_fnc_customHint", 0];

// 3. Mark Mafia HQ as compromised
A3UE_mafiaHQCompromised = true;
publicVariable "A3UE_mafiaHQCompromised";
