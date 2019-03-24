// measurements in centimeters
width = 35;
depth = 10;
height = 4;
thickness = 0.5;
faucet_radius = 5.6;
faucet_center_offset = 15.5;
spout_offset = 5;
spout_width = 2;
spout_length = 4;
gutter_width = 0.5;
slat_count = 15;
slat_height = 0.5;
slat_width = 0.5;
slat_spacing = (width - (thickness * 4)) / slat_count;
$fs=0.1;
$fn=100;

module footprint() {
    translate([thickness, thickness, 0]) {
        minkowski() {
            intersection() {
                difference() {
                    union() {
                        square([width - 2 * thickness, depth - 2 * thickness]);
                        translate([faucet_center_offset, 0, 0]) {
                            circle(r=faucet_radius + thickness, center=true);
                        }
                    };
                    translate([faucet_center_offset, 0, 0]) {
                        circle(r=faucet_radius, center=true);
                    };
                };
                square([width - 2 * thickness, depth - 2 * thickness]);
            };
            circle(r=thickness);
        }
    }
}

module slats() {
    for (index = [0 : slat_count]) {
        offset = index * slat_spacing;
        translate([offset, 0, 0]) {
            cube([slat_width, depth, slat_height]);
        }       
    }
}

module slat_space() {
    linear_extrude(heigh=height) {
        offset(r = -1 * (thickness + gutter_width)) {
            footprint();
        }
    }
}

module wall(height) {
    linear_extrude(height=height) {
        difference() {
            footprint();
            offset(r=-1 * thickness) {
                footprint();
            };
            translate([spout_offset, 0, 0]) {
                square([spout_width, thickness * 1.1]);
            };
        }
    };
}

module base_plate() {
    union() {
        // The simple base plat
        linear_extrude(height=thickness) footprint();

        // The slates with a gutter subtracted around the edge.
        translate([0, 0, thickness]) {
            intersection() {
                slats();
                slat_space();
            }
        }
    } 
}

module spout() {
    difference() {
        cube([spout_width + thickness * 2, spout_length, height]);
        translate([thickness, -1 * thickness, thickness]) {
            cube([spout_width, spout_length + thickness * 2, height]);
        };
    };
}

module full_model() {
    union() {
        base_plate();
        // translate([0, 0, thickness]) {
        //     wall(height - thickness);
        // };
        // translate([spout_offset - thickness, -1 * spout_length, 0]) {
        //     spout();
        // }
    }
}

// TODO: Some sort of tilt for the base to direct water to the spout.
// TODO: A spout to the right of the faucet? How else do we get water from there?
// TODO: Downward tilt to the spout.

full_model();