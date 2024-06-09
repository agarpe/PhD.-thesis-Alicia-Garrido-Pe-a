#!/bin/bash

# Define the directories to search for images and tex files
img_dir="img"
tex_dirs=("chapters" "misc" "Preface")

# Find all image files in the img directory (png, jpg, pdf)
image_files=($(find "$img_dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.pdf" \)))

# Initialize arrays to keep track of used and unused images
used_images=()
unused_images=("${image_files[@]}")

# Function to search for an image in the tex files
search_image_in_tex() {
    local image=$1
    local found=0
    for tex_dir in "${tex_dirs[@]}"; do
        if grep -q -r "$(basename "$image")" "$tex_dir"; then
            found=1
            break
        fi
    done
    echo $found
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
    if [[ $(search_image_in_tex "$image") -eq 1 ]]; then
        # Add the image to used_images and remove it from unused_images
        used_images+=("$image")
        unused_images=("${unused_images[@]/$image}")
    fi
done

# Print the list of used images with their sizes
if [ ${#used_images[@]} -eq 0 ]; then
    echo "No images are in use."
else
    echo "Used images:"
    for image in "${used_images[@]}"; do
        size=$(stat -c%s "$image")
        readable_size=$(human_readable_size "$size")
        echo "$image - $readable_size"
    done
fi
