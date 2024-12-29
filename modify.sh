#!/bin/bash

# Define working directories
WORK_DIR="~/token-repo"
MAPPINGS_DIR="$WORK_DIR/cardano-token-registry/mappings"
REPO_URL="https://github.com/cardano-foundation/cardano-token-registry"
OUTPUT_DIR="$WORK_DIR/output"

# Create the working directory if it doesn't exist
mkdir -p "$WORK_DIR"

# Change to the working directory
cd "$WORK_DIR" || { echo "Failed to change to directory $WORK_DIR"; exit 1; }

# Clone the repository (remove existing if necessary)
if [ -d "cardano-token-registry" ]; then
    echo "Repository already exists. Pulling latest changes..."
    cd "cardano-token-registry" || exit
    git pull || { echo "Failed to pull latest changes."; exit 1; }
else
    echo "Cloning repository..."
    git clone "$REPO_URL" || { echo "Failed to clone repository."; exit 1; }
    cd "cardano-token-registry" || exit
fi

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Function to decode base64 and save logo
decode_logo() {
    local base64_string=$1
    local output_file=$2
    echo "$base64_string" | base64 -d > "$output_file"
}

# Process each JSON file in the mappings directory
for json_file in "$MAPPINGS_DIR"/*.json; do
    # Extract the file name without extension
    file_name=$(basename "$json_file" .json)

    # Create a corresponding output folder
    output_folder="$OUTPUT_DIR/$file_name"
    mkdir -p "$output_folder"

    # Extract values using jq
    name=$(jq -r '.name.value' "$json_file")
    ticker=$(jq -r '.ticker.value' "$json_file")
    decimals=$(jq -r '.decimals.value' "$json_file")
    logo_base64=$(jq -r '.logo.value' "$json_file")

    # Save extracted values to files
    echo "$name" > "$output_folder/name.txt"
    echo "$ticker" > "$output_folder/ticker.txt"
    echo "$decimals" > "$output_folder/decimals.txt"

    # Decode and save the logo
    if [ -n "$logo_base64" ]; then
        decode_logo "$logo_base64" "$output_folder/logo.png"
    fi

    echo "Processed: $file_name"
done

echo "Processing complete. Files saved in $OUTPUT_DIR."
