width = 30;
depth = 10;
height = 4;
thickness = 0.5;
faucet_radius = 3;
faucet_offset = 24;
spout_width = 5;
spout_length = 10;
$fs=0.1;
$fn=100;

// The 2d footprint of the main basin (without the faucet accomodation)
module footprint() {
    square([width, depth]);
}

// The 3d boundary to which we'll clip the entire thing
module boundary() {
    linear_extrude(height = height) {
        footprint();
    }
}

// The base plus the lip, without the cylinder indentation.
module basin() {
    difference() {
        boundary();
        translate([thickness, thickness, thickness]) {
            resize([width - thickness * 2, 
                    depth - thickness * 2, 
                    height]) 
            {
                boundary();
            }
        }
    }
}

module faucet_outer_cylinder() {
    translate([faucet_offset, 0, 0]) {
        cylinder(r=faucet_radius + thickness, h=height);
    }
}

module faucet_inner_cylinder() {
    translate([faucet_offset, 0, -0.5 * height]) {
        cylinder(r=faucet_radius, h=height * 2);
    }
}

// TODO: Spout to drain into sink.
// TODO: Slight tilt to basin floor to direct water out.
// TODO: "slats" to raise the contents off the floor.

module basin_with_faucet() {
    // Clip the model to the boundary.
    intersection() {
        // Subtract out the inner faucet cylinder
        difference() {
            // Combine the basin and the outer cylinder
            union() {
                basin();
                faucet_outer_cylinder();
            };
            faucet_inner_cylinder();
        };
        boundary();
    }
}

module basin_with_spout_gap() {
    
}

module spout() {
    rotate([90, 0, 0]) {
        difference() {
            cube([spout_width, height, spout_length]);
            translate([thickness, thickness, -0.1]) {
                cube([spout_width - thickness * 2, height - thickness * 0.8, spout_length * 1.1]);
            }
        }
    }
}

module full_model() {
    union() {
        basin_with_faucet();
        spout();
    }
}

full_model();


