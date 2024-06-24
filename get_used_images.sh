#!/bin/bash

# Define the directories to search for images and tex files
img_dir="img"
tex_dirs=("chapters" "misc" "Preface" "chapters/chapter4/" "chapters/chapter5/")

# Find all image files in the img directory (png, jpg, pdf)
image_files=($(find "$img_dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.pdf" \)))

# Initialize arrays to keep track of used and unused images
used_images=()
unused_images=("${image_files[@]}")
image_usage_paths=()

# Function to search for an image in the tex files
search_image_in_tex() {
    local image=$1
    local image_basename=$(basename "$image")
    local found=0
    local tex_path=""
    for tex_dir in "${tex_dirs[@]}"; do
        tex_path=$(grep -rl "\\includegraphics.*$image_basename" "$tex_dir")
        if [ -n "$tex_path" ]; then
            found=1
            break
        fi
    done
    echo $found "$tex_path"
}

# Function to convert bytes to a human-readable format (KB or MB)
human_readable_size() {
    local size=$1
    if [ $size -ge 1048576 ]; then
        echo "$(echo "scale=2; $size/1048576" | bc) MB"
    elif [ $size -ge 1024 ]; then
        echo "$(echo "scale=2; $size/1024" | bc) KB"
    else
        echo "$size bytes"
    fi
}

# Iterate over each image file
for image in "${image_files[@]}"; do
    result=($(search_image_in_tex "$image"))
    found=${result[0]}
    tex_path=${result[1]}
    if [[ $found -eq 1 ]]; then
        # Add the image to used_images and remove it from unused_images
        used_images+=("$image")
        image_usage_paths+=("$tex_path")
        unused_images=("${unused_images[@]/$image}")
    fi
done

# Print the list of used images with their sizes and usage paths
if [ ${#used_images[@]} -eq 0 ]; then
    echo "No images are in use."
else
    for i in "${!used_images[@]}"; do
        image="${used_images[$i]}"
        tex_path="${image_usage_paths[$i]}"
        size=$(stat -c%s "$image")
        readable_size=$(human_readable_size "$size")
        echo "$image - $readable_size - used in $tex_path"
    done
fi
