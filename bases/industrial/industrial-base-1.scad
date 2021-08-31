$fa = $preview ? 5 : 0.1;
$fs = $preview ? 0.5 : 0.1;
base_diameter = 32;
base_height = 4;
base_bevel_angle = 30;
base_surface_depth = 0.5;
preview_base_surface = false;

use <../../components/base.scad>;

module grid (angle, thickness, spacing, z, rotation = [0, 0, 0], translation = [0, 0, 0]) {

    module bar (length, thickness) {
        intersection() {
            cube([length, thickness, thickness]);

            translate([0, thickness / 2, thickness / 2]) rotate([0, 90, 0]) {
                cylinder(length, r = thickness * 11 / 20);
            }
        }
    }

    module bars (diameter, spacing) {
        for (y = [-diameter / 2 : spacing : diameter / 2]) {
            translate([-diameter / 2, y, 0]) {
                bar(diameter, thickness);
            }
        }
    }

    translate([0, 0, z]) {
        color("dimgray") intersection() {
            base(base_diameter, base_height, base_bevel_angle, z = z);

            translate(translation) rotate(rotation) {
                bars(base_diameter, spacing);

                rotate([0, 0, angle]) {
                    bars(base_diameter, spacing);
                }
            }
        }
    }
}

module sheet (thickness, z, rotation = [0, 0, 0], translation = [0, 0, 0]) {

    module rivet (size) {
        difference() {
            sphere(size);

            translate([0, 0, size / 2]) {
                cylinder(size / 2, size * 7 / 20, size / 2);
            };
        }
    }

    module rivet_row(length, spacing, gutter, size) {
        for (i = [0 : 20]) {
            translate([rivet_gutter, rivet_gutter + spacing * i, thickness / 2 + size * 3 / 4]) {
                rivet(size);
            }

            translate([rivet_gutter + spacing * i, rivet_gutter, thickness / 2 + size * 3 / 4]) {
                rivet(size);
            }
        }
    }

    rivet_gutter = 0.5;

    translate([0, 0, z]) {
        color("lightgray") intersection() {
            base(base_diameter, base_height, base_bevel_angle, z = z);

            translate(translation) rotate(rotation) {
                cube([base_diameter, base_diameter, thickness]);

                for (i = [0 : 20]) {
                    translate([rivet_gutter, rivet_gutter + 2 * i, thickness / 2 + 0.15]) {
                        rivet(0.2);
                    }

                    translate([rivet_gutter + 2 * i, rivet_gutter, thickness / 2 + 0.15]) {
                        rivet(0.2);
                    }
                }
            }
        }
    }
}

module pipe (length, outer_diameter, rotation = [0, 0, 0], translation = [0, 0, 0]) {
    translate(translation) rotate(rotation) {
        color("gray") difference() {
            union() {
                cylinder(length, d = outer_diameter);

                translate([0, 0, length - 3]) {
                    cylinder(3, d = outer_diameter * 1.1);
                }
            }

            translate([0, 0, 1]) {
                cylinder(length, d = outer_diameter - 0.5);
            }
        }
    }
}

union() {
    difference() {
        union() {
            base_with_surface(
                base_diameter,
                base_height,
                base_bevel_angle,
                ["../heightmaps/cracked-earth-1.png", 512, 512],
                base_surface_depth,
                surface_visible = !$preview || preview_base_surface
            );

            difference() {
                grid(60, 0.3, 1, base_height - 0.2, rotation = [2, 3, 0]);

                rotate([2, 3, 9]) translate([-48, -20, 0]) {
                    cube(40);
                }
            }

            sheet(0.5, base_height - 0.05, rotation = [2, 3, 0], translation = [-3.6, -1.4, 0.3]);
        }

        base_cutout(
            base_diameter,
            base_height,
            base_bevel_angle,
            wall_thickness = 1,
            top_thickness = 1.5
        );
    }

    difference() {
        pipe(20, 5.5, rotation = [10, 50, 5], translation = [-7, -5, -8]);

        translate([-base_diameter / 2, -base_diameter / 2, -base_diameter]) {
            cube(base_diameter);
        }

        base_cutout(
            base_diameter,
            base_height,
            base_bevel_angle,
            wall_thickness = 1,
            top_thickness = 1.5
        );
    }
}
