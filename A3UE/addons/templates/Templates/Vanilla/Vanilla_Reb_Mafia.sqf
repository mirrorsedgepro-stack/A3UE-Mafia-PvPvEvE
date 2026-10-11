private _hasWs = "ws" in A3A_enabledDLC;
private _hasMarksman = "mark" in A3A_enabledDLC;
private _hasLawsOfWar = "orange" in A3A_enabledDLC;
private _hasTanks = "tank" in A3A_enabledDLC;
private _hasApex = "expansion" in A3A_enabledDLC;
private _hasHelicopters = "heli" in A3A_enabledDLC;
private _hasContact = "enoch" in A3A_enabledDLC;
private _hasJets = "jets" in A3A_enabledDLC;
private _hasArtOfWar = "aow" in A3A_enabledDLC;
private _hasKart = "kart" in A3A_enabledDLC;
private _hasGM = "gm" in A3A_enabledDLC;
private _hasCSLA = "csla" in A3A_enabledDLC;
private _hasRF = "rf" in A3A_enabledDLC;
private _hasSOG = "vn" in A3A_enabledDLC;
private _hasSPE = "spe" in A3A_enabledDLC;
private _hasEF = "ef" in A3A_enabledDLC;

////////////////////////////////////
//   Mafia Faction Information   //
////////////////////////////////////

["name", "Mafia"] call _fnc_saveToTemplate;

["flag", "Flag_Altis_F"] call _fnc_saveToTemplate;
["flagTexture", "a3\data_f\flags\flag_altis_co.paa"] call _fnc_saveToTemplate;
["flagMarkerType", "flag_Altis"] call _fnc_saveToTemplate;

////////////////////////////////////
//       Syndicate Vehicles       //
////////////////////////////////////

private _vehiclesBasic = ["C_Quadbike_01_F"];
private _vehiclesLightUnarmed = ["C_Offroad_01_F", "C_SUV_01_F", "C_Hatchback_01_F", "C_Hatchback_01_sport_F"];
private _vehiclesLightArmed = ["I_C_Offroad_02_LMG_F", "B_G_Offroad_01_armed_F"];
private _vehiclesAt = ["I_G_Offroad_01_AT_F"];
private _VehTruck = ["C_Van_01_transport_F", "C_Van_01_box_F"];
private _vehicleAA = [];

private _vehiclesBoat = ["C_Boat_Civil_01_F", "C_Rubberboat", "I_C_Boat_Transport_02_F"];
private _vehiclesMedical = ["C_Van_02_medevac_F"];
private _vehiclesSupply = ["C_Van_01_box_F", "C_Truck_02_box_F"];

private _vehiclePlane = ["C_Plane_Civil_01_F", "C_Plane_Civil_01_racing_F"];
private _vehicleCivPlane = ["C_Plane_Civil_01_F", "C_Plane_Civil_01_racing_F"];

private _vehiclesCivCar = [
    "C_SUV_01_F", 
    "C_Hatchback_01_sport_F", 
    "C_Hatchback_01_F", 
    "C_Offroad_01_F"
];
private _CivTruck = ["C_Truck_02_transport_F", "C_Truck_02_covered_F", "C_Van_01_transport_F"];
private _civHelicopters = ["C_Heli_Light_01_civil_F", "a3a_C_Heli_Light_02_blue_F"];
private _CivBoat = ["C_Boat_Civil_01_F", "C_Rubberboat"];

if (_hasApex) then {
    _vehiclesCivCar pushBack "C_Offroad_02_unarmed_F";
    _vehiclesLightArmed pushBack "I_C_Offroad_02_LMG_F";
    _vehiclesAt pushBack "I_C_Offroad_02_AT_F";
};

if (_hasLawsOfWar) then {
    _vehiclesCivCar append ["C_Van_02_vehicle_F", "C_Van_02_transport_F"];
    _VehTruck pushBack "C_Van_02_transport_F";
};

if (_hasRF) then {
    _vehiclesCivCar append ["C_Pickup_rf", "C_Pickup_covered_rf"];
    _vehiclesLightArmed pushBack "a3u_black_Pickup_rival_rf";
    _civHelicopters append ["C_Heli_EC_01A_civ_RF", "C_Heli_EC_01_civ_RF"];
};

private _staticMG = ["I_G_HMG_02_high_F", "I_G_HMG_02_F", "I_HMG_01_high_F"];
private _staticAT = ["I_static_AT_F"];
private _staticAA = ["I_static_AA_F"];
private _staticMortars = ["I_G_Mortar_01_F"];
["staticMortarMagHE", "8Rnd_82mm_Mo_shells"] call _fnc_saveToTemplate;
["staticMortarMagSmoke", "8Rnd_82mm_Mo_Smoke_white"] call _fnc_saveToTemplate;

["minesAT", ["ATMine_Range_Mag", "SLAMDirectionalMine_Wire_Mag"]] call _fnc_saveToTemplate;
["minesAPERS", ["ClaymoreDirectionalMine_Remote_Mag", "APERSMine_Range_Mag", "APERSBoundingMine_Range_Mag", "APERSTripMine_Wire_Mag"]] call _fnc_saveToTemplate;

["breachingExplosivesAPC", [["DemoCharge_Remote_Mag", 1]]] call _fnc_saveToTemplate;
["breachingExplosivesTank", [["SatchelCharge_Remote_Mag", 1], ["DemoCharge_Remote_Mag", 2]]] call _fnc_saveToTemplate;

["vehiclesCivPlane", _vehicleCivPlane] call _fnc_saveToTemplate;
["vehiclesCivSupply", _vehiclesSupply] call _fnc_saveToTemplate;
["vehiclesMedical", _vehiclesMedical] call _fnc_saveToTemplate;
["vehiclesBoat", _vehiclesBoat] call _fnc_saveToTemplate;
["staticMortars", _staticMortars] call _fnc_saveToTemplate;
["staticMGs", _staticMG] call _fnc_saveToTemplate;
["staticAT", _staticAT] call _fnc_saveToTemplate;
["vehiclesCivHeli", _civHelicopters] call _fnc_saveToTemplate;
["vehiclesBasic", _vehiclesBasic] call _fnc_saveToTemplate;
["vehiclesPlane", _vehiclePlane] call _fnc_saveToTemplate;
["vehiclesCivTruck", _CivTruck] call _fnc_saveToTemplate;
["vehiclesTruck", _VehTruck] call _fnc_saveToTemplate;
["vehiclesCivBoat", _CivBoat] call _fnc_saveToTemplate;
["vehiclesAA", _vehicleAA] call _fnc_saveToTemplate;
["staticAA", _staticAA] call _fnc_saveToTemplate;
["vehiclesCivCar", _vehiclesCivCar] call _fnc_saveToTemplate;
["vehiclesLightUnarmed", _vehiclesLightUnarmed] call _fnc_saveToTemplate;
["vehiclesLightArmed", _vehiclesLightArmed] call _fnc_saveToTemplate;
["vehiclesAT", _vehiclesAt] call _fnc_saveToTemplate;

//////////////////////////////////////
//  Mafia Starting Low-Tier Arsenal //
//////////////////////////////////////

private _initialRebelEquipment = [
    // Low tier sidearms & revolvers
    "hgun_Pistol_heavy_02_F", // Zubr .44 Magnum
    "hgun_ACPC2_F",           // 1911 .45 ACP
    "hgun_Rook40_F",          // 9mm Concealed
    "6Rnd_45ACP_Cylinder",
    "9Rnd_45ACP_Mag",
    "16Rnd_9x21_Mag",
    
    // Low tier SMGs
    "hgun_PDW2000_F",
    "30Rnd_9x21_Mag", "30Rnd_9x21_Red_Mag",
    "SMG_02_F",               // Scorpion EVO / Sting 9mm
    
    // Starter grenades & tactical explosives
    "MiniGrenade", "SmokeShell", "SmokeShellYellow",
    ["IEDUrbanSmall_Remote_Mag", 10], ["IEDLandSmall_Remote_Mag", 10],
    ["IEDUrbanBig_Remote_Mag", 3], ["DemoCharge_Remote_Mag", 5],
    
    // Syndicate utility & packs
    "B_LegStrapBag_black_F",
    "B_FieldPack_blk",
    "V_BandollierB_blk", "V_Rangemaster_belt", "V_TacVest_blk",
    "Binocular",
    "acc_flashlight_pistol", "acc_flashlight_smg_01"
];

if (_hasApex) then {
    _initialRebelEquipment append [
        "hgun_Pistol_01_F", "10Rnd_9x21_Mag", // PM 9mm
        "SMG_05_F", "30Rnd_9x21_Mag_SMG_02"   // Protector 9mm
    ];
};

if (_hasContact) then {
    _initialRebelEquipment append [
        "srifle_DMR_06_hunter_F", "10Rnd_Mk14_762x51_Mag" // Hunting rifle
    ];
};

if (A3A_hasTFAR) then {_initialRebelEquipment append ["tf_microdagr", "tf_anprc154"]};
if (A3A_hasTFAR && startWithLongRangeRadio) then {_initialRebelEquipment append ["tf_anprc155"]};
if (A3A_hasTFARBeta) then {_initialRebelEquipment append ["TFAR_microdagr", "TFAR_anprc154"]};
if (A3A_hasTFARBeta && startWithLongRangeRadio) then {_initialRebelEquipment append ["TFAR_anprc155"]};

_initialRebelEquipment append ["Chemlight_red", "Chemlight_yellow", "Chemlight_blue"];
["initialRebelEquipment", _initialRebelEquipment] call _fnc_saveToTemplate;

//////////////////////////////////////
//  Mafia Attire & Headgear Pools   //
//////////////////////////////////////

private _rebUniforms = [
    // Formal & Suits
    "U_C_FormalSuit_01_black_F",
    "U_C_FormalSuit_01_gray_F",
    "U_C_FormalSuit_01_khaki_F",
    "U_C_FormalSuit_01_blue_F",
    // Mobster Streetwear & Leather
    "U_C_Man_casual_1_F",
    "U_C_Man_casual_2_F",
    "U_C_Man_casual_3_F",
    "U_C_Man_casual_4_F",
    "U_C_Man_casual_5_F",
    "U_C_Man_casual_6_F",
    "U_I_C_Soldier_Bandit_1_F",
    "U_I_C_Soldier_Bandit_2_F",
    "U_I_C_Soldier_Bandit_3_F",
    "U_I_C_Soldier_Bandit_4_F",
    "U_I_C_Soldier_Bandit_5_F",
    "U_C_E_LooterJacket_01_F"
];

private _headgear = [
    "H_Hat_checker",
    "H_Hat_grey",
    "H_Hat_brown",
    "H_Hat_tan",
    "H_Cap_blk",
    "H_Cap_press",
    "H_Beret_blk",
    "H_StrawHat",
    "H_StrawHat_dark"
];

["headgear", _headgear] call _fnc_saveToTemplate;
["uniforms", _rebUniforms] call _fnc_saveToTemplate;

//////////////////////////////////////
//     Identities & Voice Lines     //
//////////////////////////////////////

private _faces = [
    "GreekHead_A3_02", "GreekHead_A3_03", "GreekHead_A3_04",
    "GreekHead_A3_05", "GreekHead_A3_06", "GreekHead_A3_07",
    "GreekHead_A3_08", "GreekHead_A3_09", "GreekHead_A3_11",
    "Ioannou", "Mavros", "Sturrock"
];
["voices", ["Male01GRE", "Male02GRE", "Male03GRE", "Male04GRE", "Male05GRE", "Male06GRE"]] call _fnc_saveToTemplate;
["faces", _faces] call _fnc_saveToTemplate;

//////////////////////////////////////
//       Mafia Unit Loadouts        //
//////////////////////////////////////

private _loadoutData = call _fnc_createLoadoutData;
_loadoutData set ["maps", ["ItemMap"]];
_loadoutData set ["watches", ["ItemWatch"]];
_loadoutData set ["compasses", ["ItemCompass"]];
_loadoutData set ["binoculars", ["Binocular"]];
_loadoutData set ["uniforms", _rebUniforms];

_loadoutData set ["glasses", ["G_Aviator", "G_Spectacles", "G_Spectacles_Tinted", "G_Squares", "G_Squares_Tinted"]];
_loadoutData set ["goggles", []];
_loadoutData set ["facemask", ["G_Bandanna_blk", "G_Bandanna_aviator", "G_Bandanna_shades"]];
_loadoutData set ["balaclavas", ["G_Balaclava_blk", "G_Balaclava_lowprofile"]];
_loadoutData set ["argoFacemask", []];
_loadoutData set ["facewearWS", []];
_loadoutData set ["facewearContact", []];
_loadoutData set ["facewearLawsOfWar", []];
_loadoutData set ["facewearGM", []];
_loadoutData set ["facewearCLSA", []];
_loadoutData set ["facewearSOG", []];
_loadoutData set ["facewearSPE", []];

_loadoutData set ["items_medical_basic", ["BASIC"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData set ["items_medical_standard", ["STANDARD"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData set ["items_medical_medic", ["MEDIC"] call A3A_fnc_itemset_medicalSupplies];
_loadoutData set ["items_miscEssentials", [] call A3A_fnc_itemset_miscEssentials];

// Template Archetypes
private _theDonTemplate = {
    ["uniforms"] call _fnc_setUniform;
    [selectRandomWeighted ["glasses", 2, "facemask", 0.5, [], 0.5]] call _fnc_setFacewear;
    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["binoculars"] call _fnc_addBinoculars;
};

private _capoTemplate = {
    ["uniforms"] call _fnc_setUniform;
    [selectRandomWeighted ["glasses", 1.5, "facemask", 1, "balaclavas", 0.5, [], 1]] call _fnc_setFacewear;
    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
    ["binoculars"] call _fnc_addBinoculars;
};

private _thugTemplate = {
    ["uniforms"] call _fnc_setUniform;
    [selectRandomWeighted ["glasses", 1, "facemask", 1, "balaclavas", 0.8, [], 1.5]] call _fnc_setFacewear;
    ["items_medical_standard"] call _fnc_addItemSet;
    ["items_miscEssentials"] call _fnc_addItemSet;
    ["maps"] call _fnc_addMap;
    ["watches"] call _fnc_addWatch;
    ["compasses"] call _fnc_addCompass;
};

private _prefix = "militia";
private _unitTypes = [
    ["Petros", _theDonTemplate],          // Replaced by The Don in script runtime
    ["SquadLeader", _capoTemplate],       // Capo
    ["Rifleman", _thugTemplate],          // Soldier / Thug
    ["staticCrew", _thugTemplate],        // Guard / Watchman
    ["Medic", _thugTemplate, [["medic", true]]],                 // Back-alley Medic
    ["Engineer", _thugTemplate, [["engineer", true]]],           // Mechanic / Safecracker
    ["ExplosivesExpert", _thugTemplate, [["explosiveSpecialist", true]]], // Demolitionist
    ["Grenadier", _thugTemplate],
    ["LAT", _thugTemplate],
    ["AT", _thugTemplate],
    ["AA", _thugTemplate],
    ["MachineGunner", _thugTemplate],     // Heavy Enforcer
    ["Marksman", _thugTemplate],          // Hitman
    ["Sniper", _thugTemplate],            // Syndicate Assassin
    ["Unarmed", _thugTemplate]            // Street Informant
];

[_prefix, _unitTypes, _loadoutData] call _fnc_generateAndSaveUnitsToTemplate;
