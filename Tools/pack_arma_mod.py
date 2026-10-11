#!/usr/bin/env python3
"""
A3UE Mafia PvPvEvE Mod Packaging Utility
Compatible with estchd/arma_mod_packing (https://github.com/estchd/arma_mod_packing)

Validates mod configuration (.modignore, .convertignore, path.json, pbo.json)
and executes arma_tools_mod_packing.
"""

import os
import sys
import json
import shutil
import subprocess
import argparse

def validate_config(source_dir):
    print(f"[*] Validating mod source: {source_dir}")
    if not os.path.isdir(source_dir):
        print(f"[!] Error: Source directory does not exist: {source_dir}")
        return False

    mod_cpp = os.path.join(source_dir, "mod.cpp")
    if not os.path.isfile(mod_cpp):
        print(f"[!] Warning: mod.cpp not found at {mod_cpp}")

    addons_dir = os.path.join(source_dir, "addons")
    if not os.path.isdir(addons_dir):
        print(f"[!] Error: addons directory not found at {addons_dir}")
        return False

    all_valid = True
    for item in sorted(os.listdir(addons_dir)):
        addon_path = os.path.join(addons_dir, item)
        if os.path.isdir(addon_path):
            pbo_json = os.path.join(addon_path, "pbo.json")
            if os.path.isfile(pbo_json):
                try:
                    with open(pbo_json, "r") as f:
                        data = json.load(f)
                    prefix = next((h["value"] for h in data.get("headers", []) if h.get("name") == "prefix"), None)
                    print(f"  [+] Addon '{item}': pbo.json valid (prefix: {prefix})")
                except Exception as e:
                    print(f"  [!] Addon '{item}': pbo.json invalid JSON: {e}")
                    all_valid = False
            else:
                print(f"  [-] Addon '{item}': missing pbo.json")
                all_valid = False

    return all_valid

def pack_mod(source_dir, dest_dir, tool_path="arma_tools_mod_packing.exe", path_json="path.json"):
    source_dir = os.path.abspath(source_dir)
    dest_dir = os.path.abspath(dest_dir)

    print("=" * 60)
    print("  Packing A3UE Mafia PvPvEvE with arma_mod_packing")
    print("=" * 60)
    print(f"Source:      {source_dir}")
    print(f"Destination: {dest_dir}")
    print(f"Tool:        {tool_path}")

    if not validate_config(source_dir):
        print("[!] Validation failed. Please fix configuration before packing.")
        return False

    # Check if arma_tools_mod_packing is available
    tool_bin = shutil.which(tool_path) or (tool_path if os.path.isfile(tool_path) else None)
    if not tool_bin:
        print("\n[!] arma_tools_mod_packing executable not found in PATH or at specified path.")
        print("[*] To pack with arma_mod_packing:")
        print("    1. Download from https://github.com/estchd/arma_mod_packing/releases")
        print("    2. Run command:")
        print(f'       arma_tools_mod_packing.exe --source "{source_dir}" --destination "{dest_dir}" --pack --path_json "{path_json}"')
        return False

    cmd = [
        tool_bin,
        "--source", source_dir,
        "--destination", dest_dir,
        "--pack"
    ]
    if os.path.isfile(path_json):
        cmd.extend(["--path_json", path_json])

    print(f"[*] Running: {' '.join(cmd)}")
    result = subprocess.run(cmd)
    return result.returncode == 0

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Pack A3UE Mafia Extender using arma_mod_packing")
    parser.add_argument("--source", default=os.path.join(os.path.dirname(__file__), "..", "A3UE"), help="Source mod directory")
    parser.add_argument("--destination", default=os.path.join(os.path.dirname(__file__), "..", "build", "@A3UE_Mafia"), help="Build destination")
    parser.add_argument("--tool", default="arma_tools_mod_packing.exe", help="Path to arma_tools_mod_packing executable")
    parser.add_argument("--path-json", default=os.path.join(os.path.dirname(__file__), "..", "path.json"), help="Path to path.json")
    parser.add_argument("--validate-only", action="store_true", help="Only validate configs without packing")

    args = parser.parse_args()

    if args.validate_only:
        success = validate_config(args.source)
    else:
        success = pack_mod(args.source, args.destination, args.tool, args.path_json)

    sys.exit(0 if success else 1)
