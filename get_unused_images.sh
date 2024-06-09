#!/bin/bash

# Define the directories to search for images and tex files
img_dir="img"
tex_dirs=("chapters" "misc" "Preface")

# Find all image files in the img directory (png, jpg, pdf)
image_files=($(find "$img_dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.pdf" \)))

# Initialize an array to keep track of unused images
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

# Iterate over each image file
for image in "${image_files[@]}"; do
    if [[ $(search_image_in_tex "$image") -eq 1 ]]; then
        # Remove the image from unused_images if it is found in any tex file
        unused_images=("${unused_images[@]/$image}")
    fi
done

# Print the list of unused images
if [ ${#unused_images[@]} -eq 0 ]; then
    echo "All images are in use."
else
    echo "Unused images:"
    for image in "${unused_images[@]}"; do
        echo "$image"
    done
fi
