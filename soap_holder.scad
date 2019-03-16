width = 20;
depth = 10;
height = 4;
thickness = 1;
faucet_radius = 3;
faucet_offset = 14;

module footprint() {
    cube([width, depth, height]);
}

module basin() {
    difference() {
        footprint();
        translate([thickness, thickness, thickness]) {
            resize([width - thickness * 2, 
                    depth - thickness * 2, 
                    (height - thickness) * 1.1]) 
            {
                footprint();
            }
        }
    }
}

module faucet_outer_cylinder() {
    translate([faucet_offset, 0, 0]) {
        cylinder(r=faucet_radius + thickness / 2, h=height, $fs=0.5);
    }
}

module faucet_inner_cylinder() {
    translate([faucet_offset, 0, 0]) {
        cylinder(r=faucet_radius, h=height * 2, $fs=0.5);
    }
}

module holder() {
    difference() {
        union() {
            basin();
            faucet_outer_cylinder();
        };
        faucet_inner_cylinder();
    }
}

holder();


