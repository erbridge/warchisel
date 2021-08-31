$fa = $preview ? 5 : 0.1;
$fs = $preview ? 0.5 : 0.1;
base_diameter = 32;
base_height = 4;
base_surface_thickness = 0.5;
preview_surface = false;

module base (diameter = base_diameter) {
    radius = diameter / 2;

    cylinder(base_height, radius, radius - base_diameter / 16);
}

module base_cutout () {
    translate([0, 0, -1]) {
        base(base_diameter - 1);
    }
}

module base_surface () {
    intersection() {
        base();

        if (!$preview || preview_surface) {
            translate([0, 0, base_height - base_surface_thickness]) scale([base_diameter / 512, base_diameter / 512, base_surface_thickness / 100]) {
                surface("../../heightmaps/cracked-earth-1.png", center = true);
            }
        }
    }
}

module base_surface_cutout () {
    translate([0, 0, base_height - base_surface_thickness]) {
        cylinder(base_surface_thickness + 0.01, r = base_diameter);
    }
}

module base_with_surface () {
    color("sandybrown") {
        difference() {
            base();
            base_surface_cutout();
        }

        base_surface();
    }
}

module grid (angle, thickness, spacing, z_layer, rotation = [0, 0, 0], translation = [0, 0, 0]) {

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

    diameter = base_diameter - z_layer;

    translate([0, 0, z_layer]) {
        color("dimgray") intersection() {
            base(diameter);

            translate(translation) rotate(rotation) {
                bars(diameter * 1.2, spacing);

                rotate([0, 0, angle]) {
                    bars(diameter * 1.2, spacing);
                }
            }
        }
    }
}

module sheet (thickness, z_layer, rotation = [0, 0, 0], translation = [0, 0, 0]) {

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

    diameter = base_diameter - z_layer;
    rivet_gutter = 0.5;

    translate([0, 0, z_layer]) {
        color("lightgray") intersection() {
            base(diameter);

            translate(translation) rotate(rotation) {
                cube([diameter, diameter, thickness]);

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

module pipe (inner_diameter, rotation = [0, 0, 0], translation = [0, 0, 0]) {
    translate(translation) rotate(rotation) {
        color("gray") difference() {
            union() {
                cylinder(20, inner_diameter / 2, inner_diameter / 2);

                translate([0, 0, 17]) {
                    cylinder(inner_diameter / 2, r = 3.2);
                }
            }

            translate([0, 0, 1]) {
                cylinder(20, r = 2.5);
            }
        }
    }
}

union() {
    difference() {
        union() {
            base_with_surface();

            difference() {
                grid(60, 0.3, 1, base_height - 0.2, rotation = [2, 3, 0]);

                rotate([2, 3, 9]) translate([-48, -20, 0]) {
                    cube(40);
                }
            }

            sheet(0.5, base_height - 0.05, rotation = [2, 3, 0], translation = [-3.6, -1.4, 0.3]);
        }

        base_cutout();
    }

    difference() {
        pipe(6, rotation = [10, 50, 5], translation = [-7, -5.5, -8]);

        translate([-base_diameter / 2, -base_diameter / 2, -base_diameter]) {
            cube(base_diameter);
        }

        base_cutout();
    }
}
