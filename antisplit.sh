#!/usr/bin/env bash

# AntiSplit - Merge split APK files and sign them
# Script by: @termuxvoid

figlet -f slant "AntiSplit"
echo -e "\tAPK Split Merger auto Signer"
echo -e "\t\t\t\t@termuxvoid"
echo

if [ $# -eq 0 ]; then
    echo "Usage: $0 <input.apks|apkm|xapk>"
    exit 1
fi

INPUT="$1"
INPUT_DIR=$(dirname "$INPUT")
BASE_NAME=$(basename "$INPUT" .${INPUT##*.})

OUTPUT="$INPUT_DIR/$BASE_NAME.apk"
SIGNED="$INPUT_DIR/${BASE_NAME}_signed.apk"

echo "Input: $INPUT"
echo "Output: $SIGNED"

if [ ! -f "$INPUT" ]; then
    echo "Error: File not found: $INPUT"
    exit 1
fi

KEYSTORE="key/antisplit.keystore"
if [ ! -f "$KEYSTORE" ]; then
    echo "Error: Keystore not found: $KEYSTORE"
    exit 1
fi

echo "Merging split files..."
if apkeditor m -i "$INPUT" -o "$OUTPUT"; then
    echo "Merged successfully"
else
    echo "Merge failed"
    exit 1
fi

echo "Signing APK..."
if apksigner sign --ks "$KEYSTORE" --ks-pass "pass:password" \
    --ks-key-alias "antisplit" --key-pass "pass:password" \
    --out "$SIGNED" "$OUTPUT"; then
    echo "Signed successfully: $SIGNED"
    
    rm -f "$OUTPUT" "$INPUT_DIR"/*.idsig 
else
    echo "Signing failed"
    exit 1
fi

echo "All done!"
