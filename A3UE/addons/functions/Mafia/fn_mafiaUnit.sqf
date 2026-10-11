/*
    Author: mirrorsedgepro-stack
    Description:
        Creates one Syndicate member in the given group, dressed and armed for his role.
    Parameters:
        0: GROUP
        1: ARRAY - position
        2: STRING - "don", "capo", "enforcer", "hitman" or "thug"
    Returns:
        OBJECT - the unit
*/

params ["_grp", "_pos", ["_role", "thug", [""]]];

private _unit = _grp createUnit ["O_G_Soldier_F", _pos, [], 6, "NONE"];
[_unit] joinSilent _grp;

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;

private _known = { _this select { isClass (configFile >> "CfgWeapons" >> _x) } };
private _uniforms = ["U_C_Man_casual_1_F", "U_C_Man_casual_2_F", "U_C_Man_casual_3_F", "U_C_Poloshirt_stripped", "U_C_Poloshirt_burgundy",
    "U_I_C_Soldier_Bandit_1_F", "U_I_C_Soldier_Bandit_3_F", "U_I_C_Soldier_Bandit_5_F"];
private _hats = ["H_Hat_checker", "H_Hat_grey", "H_Hat_brown", "H_Hat_tan", "H_Cap_blk", "H_Beret_blk"];
private _vest = "V_BandollierB_blk";
private _gun = "hgun_PDW2000_F";
private _mag = "30Rnd_9x21_Mag";
private _mags = 6;

switch (_role) do {
    case "don": {
        _uniforms = ["U_C_FormalSuit_01_black_F", "U_Marshal", "U_C_Poloshirt_stripped"];
        _hats = ["H_Hat_checker"];
        _vest = "V_Rangemaster_belt";
        _gun = "hgun_Pistol_heavy_02_F"; _mag = "6Rnd_45ACP_Cylinder"; _mags = 4;
    };
    case "capo": { _vest = "V_TacVest_blk"; _gun = "SMG_02_F"; _mag = "30Rnd_9x21_Mag_SMG_02"; };
    case "enforcer": { _vest = "V_TacVest_blk"; _gun = "LMG_Mk200_F"; _mag = "200Rnd_65x39_cased_Box"; _mags = 2; };
    case "hitman": { _vest = "V_TacVest_blk"; _gun = "srifle_EBR_F"; _mag = "20Rnd_762x51_Mag"; };
    default {
        (selectRandom [["hgun_PDW2000_F", "30Rnd_9x21_Mag"], ["arifle_TRG20_F", "30Rnd_556x45_Stanag"], ["SMG_01_F", "30Rnd_45ACP_Mag_SMG_01"]]) params ["_g", "_m"];
        _gun = _g; _mag = _m;
    };
};

_uniforms = _uniforms call _known;
if (_role == "don") then { _unit forceAddUniform (_uniforms select 0) } else { _unit forceAddUniform (selectRandom _uniforms) };
_unit addVest _vest;
_unit addHeadgear (selectRandom _hats);
_unit addMagazines [_mag, _mags];
_unit addWeapon _gun;
if (_role == "hitman") then { _unit addPrimaryWeaponItem "optic_DMS" };
_unit addItem "FirstAidKit";
_unit linkItem "ItemMap";
_unit linkItem "ItemRadio";

_unit setSkill ([0.4, 0.6] select (_role in ["don", "hitman", "capo"]));
_unit setVariable ["A3UE_mafia", _role, true];
_unit
