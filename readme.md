# Antistasi Ultimate - Mafia PvPvEvE Extender (`A3UE`)

An official-grade Extender for [Antistasi Ultimate](https://github.com/Antistasi-Ultimate-Community/A3-Antistasi-Ultimate) that introduces dynamic 4-way **PvPvEvE** warfare across the map.

Instead of fighting only AI Occupants and Invaders, players can now divide into two competing human factions:
1. **The Traditional Rebel Resistance** (`independent`) fighting for freedom and ideological liberation.
2. **The Mafia Syndicate** (`civilian` weaponized) fighting for underworld dominance, control of rackets, and territorial power.

Both player-led factions start from the ground up with low-tier equipment, competing against each other while simultaneously battling AI Occupants (`west`) and AI Invaders (`east`).

---

## Key Features

- **4-Way Engine Hostility**:
  - `west` (Occupants - AI)
  - `east` (Invaders - AI)
  - `resistance` (Rebels - Players / AI)
  - `civilian` (The Mafia Syndicate - Players / AI)
  - Native engine target recognition and 4-way hostile combat.

- **Dual Parallel Progression & HQs**:
  - Independent Headquarters for both factions: **Petros** leads the Rebels, while **The Don (Don Salvatore)** commands the Syndicate.
  - Enforced minimum distance buffer (minimum 2.5km) between starting camps to ensure fair staging.
  - Separate Arsenals: gear looted into the Mafia ammo crate unlocks equipment exclusively for the Mafia.

- **HQ Raiding**:
  - Locate the rival faction's hidden HQ through reconnaissance or interrogation.
  - Raid the rival HQ ammo crate to siphon cash reserves and plunder stockpiled weapons.

- **Contested Cities & Rackets**:
  - Cities dynamically split public sentiment across Occupants, Rebels, and Mafia.
  - Human Resources (HR) and daily income are split according to town support percentages.
  - Capos can establish **Protection Rackets** in towns to generate periodic dirty income and informant intel.

- **Syndicate Archetypes & Loadouts**:
  - **The Don**: Commander archetype in tailored formal suits with revolvers.
  - **Capo**: Squad leaders in leather/casual jackets with SMGs and radios.
  - **Enforcer**: Heavy gunners with tac vests and automatic firepower.
  - **Hitman**: Syndicate marksmen with precision rifles.
  - **Thug / Soldier**: Street footmen with handguns and shotguns.

- **Global War Level & Targeted Aggro**:
  - War Level scales globally as island conflict intensifies.
  - AI Occupants and Invaders track Rebel Aggro and Mafia Aggro independently, directing airstrikes and QRFs at whichever faction stirred up trouble.

---

## Directory Structure

```
A3UE/
├── addons/
│   ├── core/         # Core macros, includes, and stringtables
│   ├── functions/    # PvPvEvE scripts, 4-way hostility, HQ & Racket logic
│   │   └── Mafia/    # Syndicate functions (init, Don boss, HQ raid, rackets)
│   ├── maps/         # Supported maps and mission descriptions
│   ├── templates/    # Faction templates and vehicle configs
│   │   └── Templates/
│   │       └── Vanilla/
│   │           └── Vanilla_Reb_Mafia.sqf  # Mafia faction template
│   └── ultimate/     # Ultimate integration hooks
└── mod.cpp           # Mod metadata and author branding
```

---

## How to Build and Install

### Method 1: arma_mod_packing (Recommended)
This repository is fully configured for [estchd/arma_mod_packing](https://github.com/estchd/arma_mod_packing) with pre-configured `pbo.json` files for each addon, `.modignore`, `.convertignore`, and `path.json`.

1. Download the latest release from [estchd/arma_mod_packing Releases](https://github.com/estchd/arma_mod_packing/releases).
2. Validate configurations or pack directly:
   ```bash
   # Validate config
   python3 Tools/pack_arma_mod.py --validate-only

   # Pack mod with arma_tools_mod_packing
   arma_tools_mod_packing.exe --source ./A3UE --destination ./build/@A3UE_Mafia --pack --path_json path.json
   ```
   Or use the included PowerShell wrapper:
   ```powershell
   .\Tools\Pack-ArmaMod.ps1
   ```

### Method 2: VSCode / Arma Dev
1. Open this repository in [Visual Studio Code](https://code.visualstudio.com/).
2. Install the **Arma Dev** extension (`ole1986.arma-dev`).
3. Press `Ctrl + Shift + P` and execute **Arma 3: Build**.
4. Add the generated `build` folder to your Arma 3 Launcher as a local mod.

### Method 3: Default Extender Scripts
1. Run `Install.ps1` to configure your build environment.
2. Run `Build.ps1` to compile the addons into `.pbo` files.

---

## Requirements

- **Arma 3** (v2.06+)
- **Antistasi Ultimate** (Mod version)
- Optional: RHS, CUP, or 3CB Factions for expanded syndicate weapon/vehicle pools.

---

## Author
- **mirrorsedgepro-stack**
- Repository: [A3UE-Mafia-PvPvEvE](https://github.com/mirrorsedgepro-stack/A3UE-Mafia-PvPvEvE)