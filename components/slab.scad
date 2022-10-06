use <./bar.scad>;

module slab (
    size,
    thickness,
    bar_thickness,
    bar_spacing,
    bar_inset,
    position = [0, 0, 0],
    rotation = [0, 0, 0],
    colour = "gray"
) {

    module broken_bars (max_length, min_length, width, thickness, spacing) {
        function length_at(y) =
            let(angle = y / width * 360)
                min_length +
                (max_length - min_length) *
                sin(angle + 34) *
                cos(angle - 12) *
                cos(angle * 2 + 3);

        for (y = [0 : spacing : width]) {
            length = length_at(y);

            translate([(max_length - length_at(width - y)) / 2, y, 0]) {
                bar(length_at(y), thickness);
            }
        }
    }

    length = size.x;
    width = size.y;

    translate(position)
    rotate(rotation)
    intersection() {
        union() {
            color(colour) cube([length, width, thickness]);

            color("dimgray") for(z = [bar_inset : bar_spacing : thickness - bar_inset]) {
                translate([0, 0, z]) {
                    translate([-bar_spacing, bar_inset, -bar_thickness / 2]) {
                        broken_bars(
                            length + 2 * bar_spacing,
                            length + bar_spacing,
                            width - 2 * bar_inset,
                            bar_thickness,
                            bar_spacing
                        );
                    }

                    rotate([180, 0, 90]) translate([-bar_spacing, bar_inset, -bar_thickness / 2]) {
                        broken_bars(
                            width + 2 * bar_spacing,
                            width + bar_spacing,
                            length - 2 * bar_inset,
                            bar_thickness,
                            bar_spacing
                        );
                    }
                }
            }
        }

        if ($children > 0) children();
    }
}

slab([22.5, 32.5], 2, 0.5, 2, 1);
