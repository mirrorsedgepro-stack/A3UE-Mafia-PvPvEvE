#!/usr/bin/env python3
"""
A3UE Mafia PvPvEvE Mod Packaging Utility
Compatible with estchd/arma_mod_packing (https://github.com/estchd/arma_mod_packing)

Provides both:
1. Native cross-platform PBO packing and zip bundle packaging.
2. Direct invocation of arma_tools_mod_packing.exe when available.
"""

import os
import sys
import json
import struct
import hashlib
import shutil
import zipfile
import argparse
import subprocess

# Leftovers of the extender template. They override Antistasi's own Altis mission, trader store and
# forbidden-item lists, so they are not packed. Delete the folders to drop them for good.
SKIPPED_ADDONS = {"maps", "hals", "ultimate"}

def create_pbo(source_folder, output_pbo_path, prefix=None):
    """
    Packs a folder into a standard Arma 3 PBO archive with SHA-1 checksum.
    """
    files_to_pack = []
    ignored_names = {"pbo.json", "key.json", "$PBOPREFIX$", ".git", ".gitignore", ".DS_Store"}

    for root, dirs, files in os.walk(source_folder):
        dirs[:] = [d for d in dirs if d not in ignored_names]
        for f in files:
            if f in ignored_names:
                continue
            full_path = os.path.join(root, f)
            rel_path = os.path.relpath(full_path, source_folder)
            # Use backslashes as standard for Arma engine
            arma_rel_path = rel_path.replace("/", "\\")
            files_to_pack.append((full_path, arma_rel_path))

    # Sort files for deterministic packing
    files_to_pack.sort(key=lambda x: x[1].lower())

    # Build PBO in memory or temp buffer
    header_bytes = bytearray()

    # 1. First header entry: "Vers" entry with metadata
    header_bytes.extend(b"\x00")  # empty filename
    header_bytes.extend(struct.pack("<IIIII", 0x56657273, 0, 0, 0, 0)) # "Vers" tag

    # Properties
    if prefix:
        header_bytes.extend(b"prefix\x00" + prefix.encode("utf-8") + b"\x00")
    header_bytes.extend(b"\x00") # end of properties

    # Read all file contents and build entries
    file_entries = []
    file_data_blocks = []

    for full_path, arma_rel_path in files_to_pack:
        with open(full_path, "rb") as fp:
            data = fp.read()
        mtime = int(os.path.getmtime(full_path))
        data_len = len(data)
        file_entries.append((arma_rel_path, data_len, mtime))
        file_data_blocks.append(data)

    for arma_rel_path, data_len, mtime in file_entries:
        header_bytes.extend(arma_rel_path.encode("utf-8") + b"\x00")
        # Stored (uncompressed) entries carry 0 as their original size: the layout Arma's own tools write.
        header_bytes.extend(struct.pack("<IIIII", 0, 0, 0, mtime, data_len))

    # End of headers: 21 null bytes
    header_bytes.extend(b"\x00" + struct.pack("<IIIII", 0, 0, 0, 0, 0))

    # Assemble complete PBO
    os.makedirs(os.path.dirname(os.path.abspath(output_pbo_path)), exist_ok=True)
    with open(output_pbo_path, "wb") as out_fp:
        out_fp.write(header_bytes)
        for data in file_data_blocks:
            out_fp.write(data)

    # Calculate SHA1 checksum across the entire file written so far
    with open(output_pbo_path, "rb") as in_fp:
        full_content = in_fp.read()
    sha1_digest = hashlib.sha1(full_content).digest()

    # Append BIS checksum signature (0x00 + 20 bytes SHA1)
    with open(output_pbo_path, "ab") as out_fp:
        out_fp.write(b"\x00" + sha1_digest)

    print(f"  [+] Packed {len(files_to_pack)} files into {os.path.basename(output_pbo_path)} ({len(full_content) + 21:,} bytes)")

def validate_config(source_dir):
    print(f"[*] Validating mod source: {source_dir}")
    if not os.path.isdir(source_dir):
        print(f"[!] Error: Source directory does not exist: {source_dir}")
        return False

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

def pack_mod_native(source_dir, dest_dir, zip_output=None):
    """
    Packs all addons into PBOs in dest_dir/@A3UE_Mafia and creates a zip release.
    """
    source_dir = os.path.abspath(source_dir)
    mod_dest = os.path.join(dest_dir, "@A3UE_Mafia")
    addons_dest = os.path.join(mod_dest, "addons")
    os.makedirs(addons_dest, exist_ok=True)

    print("=" * 60)
    print("  Packing A3UE Mafia PvPvEvE Mod (Native PBO Engine)")
    print("=" * 60)

    # 1. Copy mod.cpp
    mod_cpp = os.path.join(source_dir, "mod.cpp")
    if os.path.isfile(mod_cpp):
        shutil.copy2(mod_cpp, os.path.join(mod_dest, "mod.cpp"))
        print(f"[+] Copied mod.cpp to {mod_dest}")

    # 2. Pack each addon folder
    addons_source = os.path.join(source_dir, "addons")
    for item in sorted(os.listdir(addons_source)):
        addon_path = os.path.join(addons_source, item)
        if item in SKIPPED_ADDONS:
            print(f"[-] Skipping addon '{item}' (extender template examples, not part of the Mafia mod)")
            continue
        if os.path.isdir(addon_path):
            pbo_json_path = os.path.join(addon_path, "pbo.json")
            prefix = f"x\\A3UE\\addons\\{item}"
            if os.path.isfile(pbo_json_path):
                try:
                    with open(pbo_json_path, "r") as f:
                        cfg = json.load(f)
                    prefix = next((h["value"] for h in cfg.get("headers", []) if h.get("name") == "prefix"), prefix)
                except Exception:
                    pass

            pbo_name = f"A3UE_{item}.pbo"
            out_pbo = os.path.join(addons_dest, pbo_name)
            create_pbo(addon_path, out_pbo, prefix)

    # 3. Create Zip release bundle if requested
    if zip_output:
        os.makedirs(os.path.dirname(os.path.abspath(zip_output)), exist_ok=True)
        print(f"\n[*] Creating release archive: {zip_output}")
        with zipfile.ZipFile(zip_output, "w", zipfile.ZIP_DEFLATED) as zipf:
            for root, _, files in os.walk(mod_dest):
                for f in files:
                    file_path = os.path.join(root, f)
                    arcname = os.path.relpath(file_path, dest_dir)
                    zipf.write(file_path, arcname)
        zip_size = os.path.getsize(zip_output)
        print(f"[+] Release archive created successfully! ({zip_size:,} bytes)")

    return True

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Pack A3UE Mafia Extender using arma_mod_packing")
    parser.add_argument("--source", default=os.path.join(os.path.dirname(__file__), "..", "A3UE"), help="Source mod directory")
    parser.add_argument("--destination", default=os.path.join(os.path.dirname(__file__), "..", "build"), help="Build destination")
    parser.add_argument("--tool", default="arma_tools_mod_packing.exe", help="Path to arma_tools_mod_packing executable")
    parser.add_argument("--path-json", default=os.path.join(os.path.dirname(__file__), "..", "path.json"), help="Path to path.json")
    parser.add_argument("--zip", default=os.path.join(os.path.dirname(__file__), "..", "build", "A3UE-Mafia-PvPvEvE-v1.0.0.zip"), help="Zip release bundle destination")
    parser.add_argument("--validate-only", action="store_true", help="Only validate configs without packing")
    parser.add_argument("--native", action="store_true", default=True, help="Use built-in native PBO packer")

    args = parser.parse_args()

    if args.validate_only:
        success = validate_config(args.source)
    else:
        # Check if external tool requested explicitly and exists
        if not args.native and shutil.which(args.tool):
            cmd = [args.tool, "--source", args.source, "--destination", os.path.join(args.destination, "@A3UE_Mafia"), "--pack"]
            if os.path.isfile(args.path_json):
                cmd.extend(["--path_json", args.path_json])
            res = subprocess.run(cmd)
            success = res.returncode == 0
        else:
            success = pack_mod_native(args.source, args.destination, args.zip)

    sys.exit(0 if success else 1)
