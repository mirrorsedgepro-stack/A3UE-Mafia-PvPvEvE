# Antistasi Ultimate - Mafia PvPvEvE Extender (`A3UE`)

An extender for [Antistasi Ultimate](https://github.com/Antistasi-Ultimate-Community/A3-Antistasi-Ultimate) that adds a crime family, the **Mafia Syndicate**, to the war: an AI faction with a hidden hideout, a Don, protection rackets in the towns and hit squads, which the rebels can raid, rob and behead. Optionally, players can join it.

The Mafia layer runs entirely on the server. Loaded as a server mod (`-serverMod`), it works on an existing campaign and players need nothing extra. The two faction templates are only needed for new campaigns and must then also be on the client of whoever sets the campaign up.

---

## What it does

- **Hideout and the Don**: the Syndicate picks a hideout near a random town, at least 2.5 km from the rebel HQ and 600 m from any military zone. Don Salvatore, two capos and 4 to 10 guards (more as the family gets richer) appear when players come within 1.2 km. Rebels find it by walking within 250 m, by raiding it, or from a dead collector's phone; it then goes on the map.
- **Rackets**: every 15 to 25 minutes the family starts a protection racket in a town where the rebels are weak (up to 3 plus half the war level). A racket pays the Syndicate every ten minutes and costs the rebels a little support. A collector crew walks the town while players are near; kill all four and the racket is broken, for 250 and some support.
- **Raids**: the stash crate at the hideout has a "Raid the Syndicate stash" action: a fifth of the family's money (up to 2500) goes to the rebels, once every 30 minutes. Five gunmen come after the raider a few minutes later.
- **Killing the Don**: costs the Syndicate 35% of its money, pays the rebels 1000 and 5 HR if they did it, and stops new rackets. After 30 minutes a successor takes over at a new hideout.
- **Sides**: the Mafia fights on Antistasi Ultimate's rival side (east, which it shares with the invaders). Arma has no free fifth side, and the civilian side is used by Antistasi's townspeople.
- **Player Mafia (experimental, off by default)**: when switched on, players get "Join / Leave the Syndicate" actions. Members move to the Mafia's side, start at the hideout and can rob the rebel HQ crate. Antistasi's rebel systems (arsenal, garage, respawn) were not written for this and it is untested.
- **Persistence**: funds, rackets, hideout, members and the Don's status are kept in the server profile per map and campaign.
- **Templates for new campaigns**: "The Mafia Syndicate" as the rebel faction, and "The Mafia Syndicate (rivals)" as the rival faction (the stock L'Ensemble template, reskinned).

### Admin and Game Master commands

`["<command>", "<argument>"] call A3UE_fnc_mafiaCommand` on the server:

| Command | Argument | Effect |
|---|---|---|
| `status` | | funds, rackets, the Don, hideout grid |
| `relocate` | | move to a new hideout |
| `racket` | town or `""` | start a racket there, or in a random weak town |
| `reveal` | | put the hideout on the map |
| `hit` | player name or `""` | send a hit squad after that (or a random) player |
| `funds` | amount | add to (or take from) the family's money |
| `playable` | `on` / `off` | let players join the Syndicate |

Every event is also written to the server log as `A3UE|<event>|...` (racket, bust, raid, heist, don, found, hit, hq, join, leave).

### Not done yet

- Nothing here has been run in game yet.
- No separate Mafia arsenal, no income or HR split by town support, no per-faction enemy aggro.
- The `maps`, `hals` and `ultimate` folders are untouched examples from the extender template. They are not packed (see `SKIPPED_ADDONS` in `Tools/pack_arma_mod.py`) and can be deleted.

---

## Directory Structure

```
A3UE/
├── addons/
│   ├── core/         # Core macros, includes, and stringtables
│   ├── functions/    # the server-side Mafia layer
│   │   └── Mafia/    # Syndicate functions (init, Don boss, HQ raid, rackets)
│   ├── templates/    # Faction templates and vehicle configs
│   │   └── Templates/
│   │       └── Vanilla/
│   │           ├── Vanilla_Reb_Mafia.sqf  # Mafia as the rebel faction
│           └── Vanilla_Riv_Mafia.sqf  # Mafia as the rival faction
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
---

## Publishing to Steam Workshop

### Option A: Official Arma 3 Tools Publisher (Recommended GUI)
1. Open **Arma 3 Tools** from your Steam Library.
2. Launch **Publisher**.
3. Select Mod: point to `build/@A3UE_Mafia`.
4. Load the included preview image: `build/@A3UE_Mafia/preview.png`.
5. Enter title: `Antistasi Ultimate - Mafia PvPvEvE Extender`.
6. Click **Publish**.

### Option B: Automated SteamCMD (CLI)
A pre-configured [`workshop_item.vdf`](workshop_item.vdf) is included in the root directory.
- On Windows: Run `Tools\publish_workshop.bat`.
- On Linux: Run `./Tools/publish_workshop.sh`.
- Or run SteamCMD directly:
  ```bash
  steamcmd +login <your_username> +workshop_build_item workshop_item.vdf +quit
  ```

---

## Requirements

- **Arma 3** (v2.06+)
- **Antistasi Ultimate** (Mod version)
- Optional: RHS, CUP, or 3CB Factions for expanded syndicate weapon/vehicle pools.

---

## Author
- **mirrorsedgepro-stack**
- Repository: [A3UE-Mafia-PvPvEvE](https://github.com/mirrorsedgepro-stack/A3UE-Mafia-PvPvEvE)