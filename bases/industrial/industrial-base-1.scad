$fa = $preview ? 5 : 0.1;
$fs = $preview ? 0.5 : 0.1;
base_diameter = 32;
base_height = 5;
base_bevel_angle = 30;
base_wall_thickness = 2;
base_top_thickness = 2.5;
base_surface_depth = 1;
preview_base_surface = false;

use <../../components/base.scad>;
use <../../components/grid.scad>;
use <../../components/pipe.scad>;
use <../../components/sheet.scad>;

on_base_with_surface(
    base_diameter,
    base_height,
    base_bevel_angle,
    base_wall_thickness,
    base_top_thickness,
    ["../heightmaps/cracked-earth-1.png", 512, 512],
    base_surface_depth,
    surface_visible = !$preview || preview_base_surface
) {
    within_base_outer_bounds(base_diameter, base_height, base_surface_depth, 20) {
        bent_grid(
            [9.2, 22],
            60,
            0.4,
            1.5,
            [0.03, 0.0013],
            position = [7, -8, base_height - base_surface_depth - 0.9],
            rotation = [2, -9, 14]
        );

        grid(
            [5, 4],
            20,
            0.3,
            1,
            position = [-11, -10, base_height],
            rotation = [-10, -2, 25]
        ) {
            translate([3, -0.2, 0]) rotate([0, 0, 60]) cube(5);
        }

        grid(
            [7.5, 7.5],
            45,
            0.3,
            1.3,
            position = [-1, -10, base_height - base_surface_depth - 2],
            rotation = [72, -23, 176]
        ) {
            translate([3.75, 3.75, 0]) cylinder(1, d = 7.5);
        }

        pipe(
            9,
            8.5,
            7.5,
            4,
            9,
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
            position = [-2, 12, base_height - 0.8],
            rotation = [2, 3, 180]
        );
    }
}
