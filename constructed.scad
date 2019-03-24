// Basic footpring (minus the faucet gap)
// +----+-----+----+----+
// | A  |  B  | D  | E  |
// |    |     +----+----+
// |    |     | C /
// |    |     |  /
// |    +-----|/  
// |    |
// +----+
//
// The faucet indentation will be at the bottom of B with its left edge at the
// left side of B.

a_dims = [13.2, 13.7];
b_dims = [6.6, 10.2];
c_dims = [2, 2];
d_dims = [c_dims[0], b_dims[1] - c_dims[1]];
e_dims = [3.5, d_dims[1]];
faucet_radius = 5.6 / 2.0;
wall_thickness = 0.2;
corner_radius = 0.5;

$fs=0.1;
$fn=100;

// The straight-edge outline of the plate (i.e. without the faucet indentation)
module hull() {
    union() {
        square(a_dims);
        translate([a_dims[0], a_dims[1] - b_dims[1]]) {
            square(b_dims);
            translate([b_dims[0], 0]) {
                polygon(points=[[0,0], c_dims, [0, c_dims[1]]]);
                translate([0, c_dims[1]]) {
                    square(d_dims);
                    translate([d_dims[0], 0]) {
                        square(e_dims);
                    }
                }
            }
        }
    }
}

// The full outline of the plate including the faucet indentation, but with square corners. We'll round these
// off for the final footprint.
module cornered_footprint() {
    difference() {
        hull();
        translate([a_dims[0] + faucet_radius, a_dims[1] - b_dims[1]]) {
            circle(r = faucet_radius, center = true);
        }
    }
}

// The actual footprint with rounded corners.
module footprint() {
    minkowski() {
        offset(r = corner_radius) {
            cornered_footprint();
        };
        circle(r = corner_radius);
    }
}

footprint();