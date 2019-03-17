width = 30;
depth = 10;
height = 4;
thickness = 0.5;
faucet_radius = 3;
faucet_offset = 24;
spout_offset = 5;
spout_width = 5;
spout_length = 10;
slat_height = 2;
slat_width = 0.5;
slat_length = depth - thickness * 2;
$fs=0.1;
$fn=100;

module inner_footprint() {
    intersection() {
        difference() {
            union() {
                square([width, depth]);
                translate([faucet_offset, 0, 0]) {
                    circle(r=faucet_radius + thickness);
                }
            };
            translate([faucet_offset, 0, 0]) {
                circle(r=faucet_radius);
            };
        };
        square([width, depth]);
    };
}

module outer_footprint() {
    minkowski() {
        inner_footprint();
        circle(r=thickness);
    }
}

module basin() {
    difference() {
        linear_extrude(height=height) {
            outer_footprint();
        };
        translate([0, 0, thickness]) {
            linear_extrude(height=height) {
                inner_footprint();
            };
        };
    }
}

module spout_gap() {
    cube([spout_width, thickness * 2, height]);
}

module spout() {
    difference() {
        cube([spout_width + thickness * 2, spout_length, height]);
        translate([thickness, -1 * thickness, thickness]) {
            cube([spout_width, spout_length + thickness * 2, height]);
        };
    };
}

module slat() {
    cube([slat_width, slat_length, slat_height]);
}

module slats(count, spacing) {
    for (offset = [0 : count]) { 
        translate([offset * spacing, 0, 0]) slat();
    }
}

module full_model() {
    union() {
        difference() {
            basin();
            translate([spout_offset, -1 * thickness, thickness]) {
                spout_gap();
            }
        };
        translate([spout_offset - thickness, -1 * spout_length - thickness, 0]) {
            spout();
        };
        translate([thickness, thickness, thickness]) {
            slats(10, 2);
        };
    };
}

full_model();