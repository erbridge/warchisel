module rivet (size) {
    difference() {
        sphere(size);

        translate([0, 0, size / 2]) {
            cylinder(size / 2, size * 7 / 20, size / 2);
        };
    }
}
