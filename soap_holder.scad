width = 20;
depth = 10;
height = 4;
thickness = 1;
faucet_radius = 3;
faucet_offset = 14;
$fs=0.1;

// The complete boundary of the holder
module boundary() {
    cube([width, depth, height]);
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


// The entire model
module holder() {
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

holder();


