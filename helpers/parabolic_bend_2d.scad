use <../modules/bend/bend.scad>;

module safe_parabolic_bend (dimensions, steepness, nsteps = $fn) {
    if ($children > 0) {
        if (steepness > 0) {
            parabolic_bend(dimensions, steepness, nsteps = nsteps) {
                children();
            }
        } else {
            children();
        }
    }
}

module parabolic_bend_x (dimensions, steepness, nsteps = $fn) {
    rotate([0, 0, -90])
    translate([-dimensions.y, 0, 0])
    safe_parabolic_bend(
        [
            dimensions.y,
            dimensions.x,
            dimensions.z
        ],
        steepness,
        nsteps = nsteps
    )
    translate([dimensions.y, 0, 0])
    rotate([0, 0, 90]) {
        children();
    }
}

module parabolic_bend_2d (dimensions, steepness, nsteps = $fn) {
    safe_parabolic_bend(
        [
            dimensions.x,
            dimensions.y,
            dimensions.z + steepness.x * pow(dimensions.y, 2)
        ],
        steepness.y,
        nsteps = nsteps
    )
    parabolic_bend_x(dimensions, steepness.x, nsteps = nsteps) {
        children();
    }
}
