/*
    Author: mirrorsedgepro-stack
    Description:
        Sets up the Mafia Syndicate HQ at the designated position.
        Enforces a minimum distance buffer from the Rebel HQ (Petros / posHQ).
        Spawns The Don (Syndicate Boss), Mafia Ammo Box, Syndicate Flag, and hideout assets.
    Parameters:
        0: ARRAY - Proposed Position [x, y, z]
    Returns:
        BOOLEAN - Success or failure
*/

params [["_pos", [0,0,0], [[]]]];

if (!isServer) exitWith { false };

// 1. Enforce Minimum Distance Buffer from Rebel HQ (minimum 2500m)
if (!isNil "posHQ") then {
    private _dist = _pos distance2D posHQ;
    if (_dist < 2500) exitWith {
        ["Mafia HQ placement failed: Too close to Rebel HQ (Minimum 2.5km required).", "align='center' size='0.8' color='#ff4444'"] remoteExec ["A3A_fnc_customHint", remoteExecutedOwner];
        false;
    };
};

A3UE_mafiaHQ = _pos;
publicVariable "A3UE_mafiaHQ";

// 2. Clean up previous Mafia HQ assets if relocating
if (!isNull A3UE_theDon) then { deleteVehicle A3UE_theDon; };
if (!isNull A3UE_mafiaBox) then { deleteVehicle A3UE_mafiaBox; };

// 3. Create Syndicate Boss (The Don)
private _group = createGroup [civilian, true];
private _don = _group createUnit ["C_Man_Formal_1_F", _pos, [], 0, "NONE"];
_don setSkill 1;
_don setRank "COLONEL";
_don setName ["Don Salvatore", "Don", "Salvatore"];
_don setVariable ["A3UE_isDon", true, true];
_don forceAddUniform "U_C_FormalSuit_01_black_F";
_don addHeadgear "H_Hat_checker";
_don addWeapon "hgun_Pistol_heavy_02_F";
_don addMagazine "6Rnd_45ACP_Cylinder";
_don addMagazine "6Rnd_45ACP_Cylinder";
_don addWeapon "Binocular";
_don linkItem "ItemMap";
_don linkItem "ItemCompass";
_don linkItem "ItemWatch";

_don addEventHandler ["Killed", {
    params ["_unit", "_killer", "_instigator"];
    [_unit, _killer, _instigator] call A3UE_fnc_mafiaBossKilled;
}];

A3UE_theDon = _don;
publicVariable "A3UE_theDon";

// 4. Create Mafia Ammo Box / Arsenal Crate
private _boxPos = _pos getPos [3, 45];
private _box = createVehicle ["Box_Syndicate_Wps_F", _boxPos, [], 0, "CAN_COLLIDE"];
clearMagazineCargoGlobal _box;
clearWeaponCargoGlobal _box;
clearItemCargoGlobal _box;
clearBackpackCargoGlobal _box;

_box setVariable ["A3UE_isMafiaBox", true, true];
A3UE_mafiaBox = _box;
publicVariable "A3UE_mafiaBox";

// 5. Create Syndicate Flag
private _flagPos = _pos getPos [3, 315];
private _flag = createVehicle ["Flag_Altis_F", _flagPos, [], 0, "CAN_COLLIDE"];
_flag setFlagTexture "a3\data_f\flags\flag_altis_co.paa";
_flag setVariable ["A3UE_isMafiaFlag", true, true];

// 6. Broadcast notification
["The Mafia Syndicate has established their family hideout.", "align='center' size='0.8' color='#a855f7'"] remoteExec ["A3A_fnc_customHint", 0];

diag_log format ["[A3UE] Mafia HQ established at %1. The Don spawned.", _pos];
true;
