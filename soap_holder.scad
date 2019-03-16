width = 20;
depth = 10;
height = 4;
thickness = 1;


module base() {
    cube([width, depth, height]);
}

difference() {
    base();
    translate([thickness, thickness, thickness]) {
        resize([width - thickness * 2, 
                depth - thickness * 2, 
                (height - thickness) * 1.1]) 
        {
            base();
        }
    }
}



