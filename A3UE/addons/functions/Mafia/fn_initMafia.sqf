/*
    Author: mirrorsedgepro-stack
    Description:
        Initializes the 4-way PvPvEvE engine sides and global Syndicate state.
        Configures civilian side hostility towards West, East, and Resistance.
        Initializes Mafia economic, HR, and aggression variables.
*/

if (!isServer) exitWith {};

diag_log "[A3UE] Initializing Mafia PvPvEvE Extender Framework...";

// 1. Establish 4-Way Engine Side Hostility
createCenter civilian;
civilian setFriend [west, 0];
west setFriend [civilian, 0];

civilian setFriend [east, 0];
east setFriend [civilian, 0];

civilian setFriend [resistance, 0];
resistance setFriend [civilian, 0];

// 2. Initialize Mafia Faction State Variables
if (isNil "A3UE_mafiaActive") then { A3UE_mafiaActive = true; };
if (isNil "A3UE_theDon") then { A3UE_theDon = objNull; };
if (isNil "A3UE_mafiaHQ") then { A3UE_mafiaHQ = [0, 0, 0]; };
if (isNil "A3UE_mafiaBox") then { A3UE_mafiaBox = objNull; };
if (isNil "A3UE_mafiaFunds") then { A3UE_mafiaFunds = 1500; };
if (isNil "A3UE_mafiaHR") then { A3UE_mafiaHR = 15; };
if (isNil "A3UE_mafiaAggroOcc") then { A3UE_mafiaAggroOcc = 0; };
if (isNil "A3UE_mafiaAggroInv") then { A3UE_mafiaAggroInv = 0; };
if (isNil "A3UE_mafiaMarkers") then { A3UE_mafiaMarkers = []; };
if (isNil "A3UE_mafiaRackets") then { A3UE_mafiaRackets = []; };
if (isNil "A3UE_mafiaUnlockedItems") then { A3UE_mafiaUnlockedItems = []; };

publicVariable "A3UE_mafiaActive";
publicVariable "A3UE_theDon";
publicVariable "A3UE_mafiaHQ";
publicVariable "A3UE_mafiaBox";
publicVariable "A3UE_mafiaFunds";
publicVariable "A3UE_mafiaHR";
publicVariable "A3UE_mafiaAggroOcc";
publicVariable "A3UE_mafiaAggroInv";
publicVariable "A3UE_mafiaMarkers";
publicVariable "A3UE_mafiaRackets";

diag_log "[A3UE] 4-Way Hostility Matrix & Mafia Syndicate state successfully initialized.";
