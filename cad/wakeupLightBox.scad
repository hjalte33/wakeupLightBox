include <laserlib/laserlib.scad>;


thickness = 6; // thikness

$flatPack = false;  // Toggle for whether or not to flatpack you build
$spaceing = 2;     // When flatpacking 


box_height = 100;
box_width = 180;
box_depth = 150;

glass_inner_dia = 94.8; 
glass_thickness = 2;
glass_outer_dia = glass_inner_dia + 2*glass_thickness;
glass_height = 183;


light_dia = 83.5;
light_height = 200;

lcd_size = [71.1,24.1,4.5];
psu_12_size = [130,98,31];
psu_5_size = [95,50,28];

fan_size = [60,60,25];
fan_holes = 4.5;
fan_holes_spaceing = 50;


llFlatPack(x=0, sizes=[box_height, box_height, box_depth, box_depth, box_depth]){
    *llPos([0,thickness,0],[90,0,0], thickness) front();
    llPos([0,box_depth,0],[90,0,0], thickness) back();
    llPos([thickness,0,0], [0,-90,0],thickness) sideL();
    llPos([box_width,0,0], [0,-90,0],thickness) sideR();
    llPos([0,0,box_height-thickness], [0,0,0],thickness) top();
    *llPos([0,0,0], [0,0,0],thickness) bottom();
}

llFlatPack(x=box_width+$spaceing, sizes=[200]){
    #llPos([0,0,box_height-thickness*2], [0,0,0], thickness)
        glass_holder();
}


llIgnore(){
}

module front(){
    llFingers(startPos=[0,0], length=box_width, angle=0, startCon=[0,0],edge="r")
    llFingers(startPos=[0,box_height-thickness], length=box_width, angle=0, startCon=[0,0],edge="l")
    llFingers(startPos=[0,0], length=box_height, angle=90, startCon=[2,2],edge="l",inverse=true)
    llFingers(startPos=[box_width-thickness,0], length=box_height, angle=90, startCon=[2,2],edge="r")
    llCutoutSquare([box_width,box_height]);
}

module sideL(){
    llFingers(startPos=[0,0], length=box_height, angle=0, startCon=[2,2],edge="r")
    llFingers(startPos=[0,box_depth-thickness], length=box_height, angle=0, startCon=[2,2],edge="l",inverse=true)
    llFingers(startPos=[0,0], length=box_depth, angle=90, startCon=[0,0],edge="l")
    llFingers(startPos=[box_height-thickness,0], length=box_depth, angle=90, startCon=[0,0],edge="r")
    llCutoutSquare([box_height,box_depth]);
}

module sideR(){

    llFingers(startPos=[0,0], length=box_height, angle=0, startCon=[2,2],edge="r",inverse=true)
    llFingers(startPos=[0,box_depth-thickness], length=box_height, angle=0, startCon=[2,2],edge="l")
    llFingers(startPos=[0,0], length=box_depth, angle=90, startCon=[0,0],edge="l")
    llFingers(startPos=[box_height-thickness,0], length=box_depth, angle=90, startCon=[0,0],edge="r")
    llCutoutSquare([box_height,box_depth]);
}

module back(){
    llFingers(startPos=[0,0], length=box_width, angle=0, startCon=[0,0],edge="r")
    llFingers(startPos=[0,box_height-thickness], length=box_width, angle=0, startCon=[0,0],edge="l")
    llFingers(startPos=[0,0], length=box_height, angle=90, startCon=[2,2],edge="l")
    llFingers(startPos=[box_width-thickness,0], length=box_height, angle=90, startCon=[2,2],edge="r",inverse=true)
    llCutoutSquare([box_width,box_height]);
}

module top(){
    // fingers for glass_holder
    module fingersL(){
        llFingers(startPos=[0,0], angle=90, length=box_depth, startCon=[1,1], edge="l");
    }

    llFingers(startPos=[0,0], angle=0, length=box_width, startCon=[1,1], edge="r")
    llFingers(startPos=[0,0], angle=90, length=box_depth, startCon=[1,1], edge="l")
    llFingers(startPos=[box_width-thickness,0], angle=90, length=box_depth, startCon=[1,1], edge="r")
    llFingers(startPos=[0,box_depth-thickness], angle=0, length=box_width, startCon=[1,1], edge="l")
    llCutoutSquare([box_width,box_depth]){
        translate([box_width/2,box_depth/2,-1])cylinder(d=glass_outer_dia, h=thickness*2);
    };
}

glass_holder_depth = glass_outer_dia+thickness*2;
module glass_holder(){
    llFingers(startPos=([0,0]), angle=90, length=box_depth, edge="l", startCon=[0,0], inverse=true)
    llFingers(startPos=([box_width-thickness,0]), angle=90, length=box_depth, edge="r", startCon=[0,0],inverse=true)
    translate([0,box_depth/2-glass_holder_depth/2])
    llCutoutSquare([box_width,glass_holder_depth]){
        translate([box_width/2,glass_holder_depth/2,-1]) cylinder(d=glass_inner_dia-4, h=thickness+2);
    };
}

module bottom(){
    llFingers(startPos=[0,0], angle=0, length=box_width, startCon=[1,1], edge="r")
    llFingers(startPos=[0,0], angle=90, length=box_depth, startCon=[1,1], edge="l")
    llFingers(startPos=[box_width-thickness,0], angle=90, length=box_depth, startCon=[1,1], edge="r")
    llFingers(startPos=[0,box_depth-thickness], angle=0, length=box_width, startCon=[1,1], edge="l")
    llCutoutSquare([box_width,box_depth]);
}

module light_cylinder(){
translate([width/2,depth/2,mt])
    cylinder(height + 200,inner_tube_radius,inner_tube_radius);

}




module speaker_hole(){
    d = 50;
    r = d/2;
    n = 7;
    th = 2;

    difference(){
        cylinder(mt, d=d);
        for(i=[0:n-1]){
            for(j=[0:n-i]){
                rotate([0,0,j*360/(n-i) + i*360/n/2])translate([r-((i+1)*(d/n))/2-th/2,-th/2])cube([th,th,mt]);
            }
            difference(){
                cylinder(mt, d = d- i*(d/n));
                translate([0,0,-0.5])cylinder(mt+1, d = d - (i+1)*(d/n) + th);
            }
        }
    }
}



