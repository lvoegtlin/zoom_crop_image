#!/usr/bin/bash

# Define the input file and output file
input_image="/Users/voegtlil/Documents/20_Thesis/figures/06-assessment/patch-resize-example/e-codices_fmb-cb-0055_0074v_max.jpg"
output_image="/Users/voegtlil/Documents/20_Thesis/figures/06-assessment/patch-resize-example/images/e-codices_fmb-cb-0055_0074v_max.jpg"

crop_x=1250
crop_y=3300
crop_width=1000
crop_height=1000
crop_geometry="${crop_width}x${crop_height}+${crop_x}+${crop_y}"

# Define the size and position for the inset image (adjust as needed)
inset_width=2000
inset_height=2000
inset_position_x=2800
inset_position_y=4400
inset_size="${inset_width}x${inset_height}"
inset_position="+${inset_position_x}+${inset_position_y}"

rectangle_color="black"
rect_stroke_width=10

# Create the zoomed-in crop
convert "$input_image" -crop "$crop_geometry" -resize "$inset_size" inset.png

# Draw a rectangle to indicate the crop area
convert "$input_image" -fill none -stroke $rectangle_color -strokewidth $rect_stroke_width -draw "rectangle ${crop_x},${crop_y} $((crop_x+crop_width)),$((crop_y+crop_height))" image_with_rectangle.png

# Draw a rectangle to indicate the insert area
convert image_with_rectangle.png -fill none -stroke $rectangle_color -strokewidth $rect_stroke_width -draw "rectangle $((inset_position_x-rect_stroke_with)),$((inset_position_y-rect_stroke_width)) $((inset_position_x+inset_width+rect_stroke_width)),$((inset_position_y+inset_height+rect_stroke_width))" image_with_rectangle_2.png

# Draw lines connecting the corners of the zoomed area to the inset
convert image_with_rectangle_2.png -stroke $rectangle_color -strokewidth 5 \
    -draw "line ${crop_x},${crop_y} ${inset_position_x},${inset_position_y}" \
    -draw "line $((crop_x+crop_width)),${crop_y} $((inset_position_x+inset_width)),${inset_position_y}" \
    -draw "line ${crop_x},$((crop_y+crop_height)) ${inset_position_x},$((inset_position_y+inset_height))" \
    -draw "line $((crop_x+crop_width)),$((crop_y+crop_height)) $((inset_position_x+inset_width)),$((inset_position_y+inset_height))" temp.png

# Position inset at bottom left
convert temp.png inset.png -geometry "$inset_position" -composite "$output_image"

#rm *.png
