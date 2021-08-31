module base (true_diameter, true_height, bevel_angle, z = 0) {
    true_radius = true_diameter / 2;
    inset = true_height * tan(bevel_angle);
    radius_at_z = true_radius - z * tan(bevel_angle);

    cylinder(true_height, radius_at_z, radius_at_z - inset);
}

module base_cutout (
    diameter,
    height,
    bevel_angle,
    wall_thickness,
    top_thickness = 0
) {
    top_thickness = top_thickness > 0 ? top_thickness : wall_thickness;

    translate([0, 0, -top_thickness]) {
        base(
            diameter,
            height,
            bevel_angle,
            z = - (wall_thickness / sin(bevel_angle) - top_thickness)
        );
    }
}

module base_surface (
    diameter,
    height,
    bevel_angle,
    texture_data,
    depth
) {
    texture_path = texture_data[0];
    texture_width = texture_data[1];
    texture_height = texture_data[2];
    texture_scale = [
        diameter / texture_width,
        diameter / texture_height,
        depth / 100
    ];

    intersection() {
        base(diameter, height, bevel_angle);

        translate([0, 0, height - depth]) {
            scale(texture_scale) {
                surface(texture_path, center = true);
            }
        }
    }
}

module base_surface_cutout (
    diameter,
    height,
    bevel_angle,
    depth
) {
    z = height - depth;

    translate([0, 0, z]) {
        base(diameter + 1, height, bevel_angle, z = z);
    }
}

module base_with_surface (
    diameter,
    height,
    bevel_angle,
    surface_texture_data,
    surface_depth,
    colour = "sandybrown",
    surface_visible = !$preview
) {
    color(colour) {
        difference() {
            base(diameter, height, bevel_angle);

            if (surface_visible) {
                base_surface_cutout(
                    diameter,
                    height,
                    bevel_angle,
                    surface_depth
                );
            }
        }

        if (surface_visible) {
            base_surface(
                diameter,
                height,
                bevel_angle,
                surface_texture_data,
                surface_depth
            );
        }
    }
}
