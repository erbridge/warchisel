module bar (length, thickness) {
    intersection() {
        cube([length, thickness, thickness]);

        translate([0, thickness / 2, thickness / 2]) rotate([0, 90, 0]) {
            cylinder(length, d = thickness * 1.15);
        }
    }
}

module bars (length, width, thickness, spacing) {
    for (y = [0 : spacing : width]) {
        translate([0, y, 0]) {
            bar(length, thickness);
        }
    }
}
