module inverse_rotate (rotation) {
    rotate([-rotation.x,           0,           0])
    rotate([          0, -rotation.y,           0])
    rotate([          0,           0, -rotation.z]) {
        if ($children > 0) children();
    }
}
