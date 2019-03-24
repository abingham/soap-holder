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
full_width = a_dims[0] + b_dims[0] + d_dims[0] + e_dims[0];
full_depth = a_dims[1];
faucet_radius = 5.6 / 2.0;
wall_thickness = 0.2;
corner_radius = 0.5;
wall_height = 4;
slat_count = 15;
slat_height = 0.5;
slat_width = 0.5;
slat_spacing = (full_width - (wall_thickness * 4)) / slat_count;
gutter_width = 0.5;

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

// The actual 2D footprint with rounded corners.
module footprint() {
    minkowski() {
        offset(r = corner_radius) {
            cornered_footprint();
        };
        circle(r = corner_radius);
    }
}

module slats() {
    for (index = [0 : slat_count]) {
        offset = index * slat_spacing;
        translate([offset, 0, 0]) {
            cube([slat_width, full_depth, slat_height]);
        }       
    }
}

module slat_space() {
    linear_extrude(heigh=wall_height) {
        offset(r = -1 * (wall_thickness + gutter_width)) {
            footprint();
        }
    }
}

module base_plate() {
    union() {
        // The simple base plat
        linear_extrude(height=wall_thickness) footprint();

        // The slates with a gutter subtracted around the edge.
        translate([0, 0, wall_thickness]) {
            intersection() {
                slats();
                slat_space();
            }
        }
    } 
}

base_plate();