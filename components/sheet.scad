use <./rivet.scad>;

module sheet (
    size,
    thickness,
    rivet_size,
    rivet_spacing,
    rivet_inset,
    position = [0, 0, 0],
    rotation = [0, 0, 0],
    colour = "lightgray"
) {

    module rivet_row(length, size, spacing, inset, first = false, last = false) {
        x_range = [
            (first ? 0 : spacing) + inset :
            spacing :
            length - inset - (last ? 0 : spacing)
        ];

        for (x = x_range) {
            translate([x, inset, -size * 3 / 8]) {
                rivet(size);
            }
        }
    }

    length = size[0];
    width = size[1];

    color(colour)
    translate(position)
    rotate(rotation)
    intersection() {
        union() {
            cube([length, width, thickness]);

            translate([0, 0, thickness]) {
                rivet_row(length, rivet_size, rivet_spacing, rivet_inset, first = true, last = true);

                rotate([0, 0, 90]) translate([0, -2 * rivet_inset, 0]) {
                    rivet_row(width, rivet_size, rivet_spacing, rivet_inset, last = true);
                }

                translate([0, width - 2 * rivet_inset, 0]) {
                    rivet_row(length, rivet_size, rivet_spacing, rivet_inset, last = true);
                }

                translate([length - 2 * rivet_inset, 0, 0]) rotate([0, 0, 90]) translate([0, -2 * rivet_inset, 0]) {
                    rivet_row(width, rivet_size, rivet_spacing, rivet_inset);
                }
            }
        }

        if ($children > 0) children();
    }
}

sheet([22, 32], 0.5, 0.4, 5, 1);
