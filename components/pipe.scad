module pipe_inner (
    length,
    diameter,
    position = [0, 0, 0],
    rotation = [0, 0, 0],
    colour = "green"
) {
    color(colour)
    translate(position)
    rotate(rotation)
    translate([0, 0, -0.5]) {
        cylinder(length + 1, d = diameter);
    }
}

module pipe (
    length,
    outer_diameter,
    inner_diameter,
    rim_length,
    rim_diameter,
    position = [0, 0, 0],
    rotation = [0, 0, 0],
    colour = "gray"
) {
    difference() {
        color(colour)
        translate(position)
        rotate(rotation) {
            cylinder(length, d = outer_diameter);

            if (rim_length > 0) {
                translate([0, 0, length - rim_length]) {
                    cylinder(rim_length, d = rim_diameter);
                }
            }
        }

        pipe_inner(
            length,
            inner_diameter,
            position = position,
            rotation = rotation,
            colour = colour
        );
    }
}
