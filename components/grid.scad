use <../helpers/inverse_rotate.scad>;
use <../helpers/parabolic_bend_2d.scad>;
use <./bar.scad>;

module grid (
    size,
    angle,
    bar_thickness,
    spacing,
    position = [0, 0, 0],
    rotation = [0, 0, 0],
    center = false,
    colour = "dimgray"
) {

    module rotated_bars(length, width, thickness, spacing, angle) {
        rotated_length = length * cos(angle) + width * sin(angle);
        rotated_width = length * sin(angle) + width * cos(angle);

        length_offset = length * sin(angle) * sin(angle);
        width_offset = -length * sin(angle) * cos(angle);

        intersection() {
            cube([length, width, bar_thickness]);

            translate([length_offset, width_offset, 0]) rotate([0, 0, angle]) {
                bars(rotated_length, rotated_width, bar_thickness, spacing);
            }
        }
    }

    length = size.x;
    width = size.y;

    color(colour)
    translate(position)
    rotate(rotation)
    translate(
        center ?
        [-length / 2, -width / 2, -bar_thickness / 2] :
        [0, 0, 0]
    )
    intersection() {
        union() {
            rotated_bars(length, width, bar_thickness, spacing, 90 - angle / 2);

            translate([length / 2, 0, 0]) mirror([1, 0, 0]) translate([-length / 2, 0, 0]) {
                rotated_bars(length, width, bar_thickness, spacing, 90 - angle / 2);
            }
        }

        if ($children > 0) children();
    }
}

module bent_grid (
    size,
    angle,
    bar_thickness,
    spacing,
    steepness,
    position = [0, 0, 0],
    rotation = [0, 0, 0],
    colour = "dimgray"
) {
    length = size.x;
    width = size.y;

    translate(position)
    rotate(rotation)
    parabolic_bend_2d([length, width, bar_thickness], steepness)
    inverse_rotate(rotation)
    translate(-position) {
        grid (
            size,
            angle,
            bar_thickness,
            spacing,
            position = position,
            rotation = rotation,
            colour = colour
        ) {
            if ($children > 0) {
                children();
            } else {
                cube([length, width, bar_thickness]);
            }
        };
    }
}

grid(
    [40, 20],
    30,
    1,
    2,
    colour = "green",
    $fa = 0.1,
    $fs = 0.1
);

grid(
    [20, 40],
    30,
    1.5,
    5,
    position = [0, 0, 10],
    colour = "blue",
    $fa = 0.1,
    $fs = 0.1
);

grid(
    [20, 40],
    30,
    1.5,
    5,
    position = [0, 0, 20],
    center = true,
    colour = "purple",
    $fa = 0.1,
    $fs = 0.1
);

grid(
    [10, 10],
    80,
    0.5,
    2,
    position = [0, 0, 30],
    rotation = [30, 15, 45],
    center = true,
    colour = "red",
    $fa = 0.1,
    $fs = 0.1
) {
    cube(10);
};

bent_grid(
    [9.2, 22],
    60,
    0.4,
    1.5,
    [0.03, 0.005],
    position = [7, -8, 40],
    rotation = [2, -9, 14],
    colour = "yellow",
    $fa = 2,
    $fs = 1
);
