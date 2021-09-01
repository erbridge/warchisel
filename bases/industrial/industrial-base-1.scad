$fa = $preview ? 5 : 0.1;
$fs = $preview ? 0.5 : 0.1;
base_diameter = 32;
base_height = 4;
base_bevel_angle = 30;
base_surface_depth = 0.5;
preview_base_surface = false;

use <../../components/base.scad>;
use <../../components/grid.scad>;
use <../../components/pipe.scad>;
use <../../components/sheet.scad>;

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

            within_base_outer_bounds(base_diameter, base_height, base_surface_depth, 20) {
                grid(
                    [9.2, 22],
                    60,
                    0.3,
                    1,
                    position = [6, -8, base_height - base_surface_depth - 1],
                    rotation = [2, -9, 14]
                );

                grid(
                    [5, 4],
                    10,
                    0.1,
                    0.35,
                    position = [-10, -12, base_height + 0.3],
                    rotation = [-10, -2, 25]
                ) {
                    translate([3, -0.2, 0]) rotate([0, 0, 60]) cube([5, 5, 5]);
                }

                grid(
                    [5, 5],
                    45,
                    0.2,
                    0.8,
                    position = [-1, -10, base_height - base_surface_depth - 2],
                    rotation = [72, -23, 176]
                ) {
                    translate([2.5, 2.5, 0]) cylinder(1, d = 5);
                };

                pipe(
                    9,
                    5.5,
                    5,
                    2,
                    6,
                    position = [6, -3, 0],
                    rotation = [50, 10, -70]
                );
            }

            within_base_inner_bounds(
                base_diameter,
                base_height,
                base_bevel_angle,
                base_surface_depth,
                20
            ) {
                sheet(
                    [11, 11],
                    0.5,
                    0.4,
                    5,
                    0.5,
                    position = [-2, 9, base_height - 0.7],
                    rotation = [2, 3, 180]
                );
            }
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
