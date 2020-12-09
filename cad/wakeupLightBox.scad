include <laserlib/laserlib.scad>;


thickness = 6; // thikness
thickness2 = 3;


$fa= $preview ? 12 : 1;
$fs= $preview ? 1 : 0.1;


$flatPack = false;  // Toggle for whether or not to flatpack you build
$spaceing = 2;     // When flatpacking 
$kerf=0.1;

box_height = 120;
box_width = 180;
box_depth = 160;

glass_inner_dia = 94.8; 
glass_thickness = 2;
glass_outer_dia = glass_inner_dia + 2*glass_thickness;
glass_height = 182;


light_dia = 63.5;
light_height = 200;
light_glass_gap = 8;

lcd_size = [71.1,24.1,4.5];
psu_12_size = [130,98,31];
psu_5_size = [95,50,28];
pi_size = [90,59,18];

button_pad_x = 39.5;
button_pad_y = 42;

fan_size = [60,60,25];
fan_holes = 4.5;
fan_holes_spaceing = 50;
fan_screw_dia = 3;


llFlatPack(x=0, sizes=[box_height, box_height, box_depth, box_depth, box_depth]){
    llPos([0,thickness,0],[90,0,0], thickness) front();
    llPos([0,box_depth,0],[90,0,0], thickness) back();
    llPos([0,0,box_height-thickness], [0,0,0],thickness) top();
    llPos([0,0,0], [0,0,0],thickness) bottom();
}
llFlatPack(x=box_width+$spaceing, sizes=[box_depth,box_depth]){
    llPos([thickness,0,0], [0,-90,0],thickness) sideL();
    llPos([box_width,0,0], [0,-90,0],thickness) sideR();
}

llFlatPack(x=box_width+box_height+2*$spaceing, sizes=[box_depth,light_holder_width,light_holder_width,box_height,box_height,box_height,box_height]){
    llPos([0,0,box_height-thickness*2], th=thickness)glassHolder();
    llPos([box_width/2,box_depth/2,baseOfLight], th=thickness)lightHolderTop();
    llPos([box_width/2,box_depth/2,baseOfLight-thickness2], th=thickness2)lightHolder();
    llPos([box_width/2 , box_depth/2, 0],th=thickness2)airDuctSides(0);
    llPos([box_width/2 , box_depth/2, 0],th=thickness2)airDuctSides(1);
    llPos([box_width/2 , box_depth/2, 0],th=thickness2)airDuctSides(2);
    llPos([box_width/2 , box_depth/2, 0],th=thickness2)airDuctSides(3);

}

llFlatPack(x=-30,sizes=[30,30,30,30,30,30,30,30,30,30,30,30]){
    s = 20;
    llPos(th=thickness)feet(size=s, n=3, taper=20, i=0);
    llPos(th=thickness)feet(size=s, n=3, taper=20, i=1);

    llPos([box_width-s,0,0], th=thickness)feet(size=s, n=3, taper=20, i=0);
    llPos([box_width-s,0,0], th=thickness)feet(size=s, n=3, taper=20, i=1);
    
    llPos([0,box_depth-s,0], th=thickness)feet(size=s, n=3, taper=20, i=0);
    llPos([0,box_depth-s,0], th=thickness)feet(size=s, n=3, taper=20, i=1);

    llPos([box_width-s,box_depth-s,0], th=thickness)feet(size=s, n=3, taper=20, i=0);
    llPos([box_width-s,box_depth-s,0], th=thickness)feet(size=s, n=3, taper=20, i=1);

}


llIgnore(){
    // psu 230v -> 12v
    color("green")
    translate([thickness,thickness+10,thickness])rotate([90,0,90])cube(psu_12_size);
    
    // psu 12v -> 5v
    color("blue")
    translate([box_width-thickness,thickness+10,thickness])rotate([-90,-90,90])cube(psu_5_size);

    //raspberry pi
    color("Crimson")
    translate([box_width-thickness,psu_5_size[1]+thickness+20,thickness])rotate([-90,-90,90])cube(pi_size);

    // light
    translate([box_width/2,box_depth/2,baseOfLight])light();

    // fan
    color("#C5A289")
    translate([box_width/2,box_depth/2,baseOfLight-fan_size[2]/2-thickness2])cube(fan_size,center=true);

    // glass
    translate([box_width/2,box_depth/2,box_height-thickness])glass();
}

//#############################################################################


module fanScrewHoles(){
    h_space = fan_holes_spaceing/2;

    translate([ h_space ,  h_space, -$th+1])cylinder(d=fan_screw_dia, h=4*$th);
    translate([-h_space,  h_space , -$th+1])cylinder(d=fan_screw_dia, h=4*$th);
    translate([-h_space, -h_space , -$th+1])cylinder(d=fan_screw_dia, h=4*$th);
    translate([ h_space , -h_space, -$th+1])cylinder(d=fan_screw_dia, h=4*$th);
}

widest = max(light_dia, fan_size[0]);
light_holder_width = widest + 3*thickness;
module lightHolderTop(){
    llPos([-light_holder_width/2,-light_holder_width/2])
    llFingers(startPos=[0,0], angle=0, length = light_holder_width, startCon=[0,0], edge="r", nFingers=5, holeWidth=thickness2)
    llFingers(startPos=[0,light_holder_width], angle=-90, length = light_holder_width, startCon=[0,0], edge="r", nFingers=5, holeWidth=thickness2)
    llFingers(startPos=[0,light_holder_width-thickness2], angle=0, length = light_holder_width, startCon=[0,0], edge="l", nFingers=5, holeWidth=thickness2)
    llFingers(startPos=[light_holder_width,0], angle=90, length = light_holder_width, startCon=[0,0], edge="r", nFingers=5, holeWidth=thickness2)
    llCutoutSquare([light_holder_width,light_holder_width]){
        translate([light_holder_width/2,light_holder_width/2,-1])cylinder(d=light_dia+2, h=$th*2);
        translate([light_holder_width/2,light_holder_width/2])fanScrewHoles();
    };
}
module lightHolder(){
    llPos([-light_holder_width/2,-light_holder_width/2])
    llFingers(startPos=[0,0], angle=0, length = light_holder_width, startCon=[0,0], edge="r", nFingers=5)
    llFingers(startPos=[0,light_holder_width], angle=-90, length = light_holder_width, startCon=[0,0], edge="r", nFingers=5)
    llFingers(startPos=[0,light_holder_width-$th], angle=0, length = light_holder_width, startCon=[0,0], edge="l", nFingers=5)
    llFingers(startPos=[light_holder_width,0], angle=90, length = light_holder_width, startCon=[0,0], edge="r", nFingers=5)
    llCutoutSquare([light_holder_width,light_holder_width]){
        translate([light_holder_width/2,light_holder_width/2,-1])cylinder(d=light_dia-4, h=$th*2);
        translate([light_holder_width/2,light_holder_width/2])fanScrewHoles();
    };
}

module airDuctSides(i){

    height2holder = baseOfLight + thickness;
    height = box_height - 2*thickness;

    llRotate([0,0,90*i])llPos([-light_holder_width/2,light_holder_width/2,0],[90,0,0])
    llFingers(startPos=[0,height2holder-thickness-thickness2], angle=0, length=light_holder_width, startCon=[1,1], nFingers=5, holeWidth=thickness+thickness2+8)
    llFingers(startPos=[$th,0], angle=90, length=height, startCon=[2,2],specialWidths=[thickness,thickness+$th], edge="l", nFingers=5)
    llFingers(startPos=[light_holder_width,0], angle=90, length=height, startCon=[3,3],specialWidths=[thickness,thickness+$th], edge="r", nFingers=5)
    llFingers(startPos=[0,0], angle=0, length=light_holder_width, startCon=[0,0], edge="r", nFingers=5, holeWidth=thickness)
    llCutoutSquare([light_holder_width,height]);

}

//#############################################################################

// distToGlass is the vertical distance from the cylindrical part of the glass to the hight where the light 
// has the gap specified by "light_glass_gap" to the inside of the glass sphere. 
distToGlass = sqrt(pow(glass_inner_dia/2,2) - pow(light_dia/2+light_glass_gap,2));
// A lot of distances to figure out where the base of the light is
baseOfLight = box_height -thickness + glass_height - glass_outer_dia/2 + distToGlass - light_height;
module light(){

    color("lightgrey")
    difference(){
        cylinder(d=light_dia, h=light_height);
        translate([0,0,-1])cylinder(d=light_dia-4, h=light_height+2);
    }
}

module glass(){
    color("LightCyan", 0.6)
    difference(){
        union(){
            cylinder(d=glass_outer_dia,h=glass_height-glass_outer_dia/2);
            translate([0,0,glass_height-glass_outer_dia/2])sphere(d=glass_outer_dia);
        }
        translate([0,0,-0.01])union(){
            cylinder(d=glass_inner_dia,h=glass_height-glass_outer_dia/2);
            translate([0,0,glass_height-glass_outer_dia/2])sphere(d=glass_inner_dia);
        }
    }
}

module front(){
    llFingers(startPos=[0,0], length=box_width, angle=0, startCon=[0,0],edge="r")
    llFingers(startPos=[0,box_height-$th], length=box_width, angle=0, startCon=[0,0],edge="l")
    llFingers(startPos=[$th,0], length=box_height, angle=90, startCon=[3,3],edge="l")
    llFingers(startPos=[box_width,0], length=box_height, angle=90, startCon=[2,2],edge="r")
    llCutoutSquare([box_width,box_height]){
        translate([box_width/2,box_height/2])cube([lcd_size[0],lcd_size[1],2*$th],center=true);
    };
}



module back(){
    llFingers(startPos=[0,0], length=box_width, angle=0, startCon=[0,0],edge="r")
    llFingers(startPos=[0,box_height-$th], length=box_width, angle=0, startCon=[0,0],edge="l")
    llFingers(startPos=[$th,0], length=box_height, angle=90, startCon=[2,2],edge="l")
    llFingers(startPos=[box_width,0], length=box_height, angle=90, startCon=[3,3],edge="r")
    llCutoutSquare([box_width,box_height]){
        translate([30,30])mirror([1,0,0])fan_hole(dia = 30, gap=3, rings=5, tab_width=2);
        translate([box_width-30,30])fan_hole(dia = 30, gap=3, rings=5, tab_width=2);
        // wire hole
        translate([64,0,0])cube([8,14,$th]);
        // on-off button
        translate([85,thickness+2])cube([20,13,$th]);
    };
}

module sideL(){
    llFingers(startPos=[0,0], length=box_height, angle=0, startCon=[2,2],edge="r")
    llFingers(startPos=[0,box_depth-$th], length=box_height, angle=0, startCon=[3,3],edge="l")
    llFingers(startPos=[$th,0], length=box_depth, angle=90, startCon=[0,0],edge="l")
    llFingers(startPos=[box_height,0], length=box_depth, angle=90, startCon=[0,0],edge="r")
    llCutoutSquare([box_height,box_depth]){
        difference(){
            llFingers(startPos=[box_height-$th,0], angle=90, length=box_depth,edge="r",startCon=[0,0]);
            toHolder=(box_depth-glass_holder_depth)/2;
            translate([box_height-3*$th,0,-1])cube([3*$th,toHolder,$th+1]);
            translate([box_height-3*$th,glass_holder_depth+toHolder,-1])cube([3*$th,toHolder,$th+1]);
        }
    };
}

module sideR(){
    llFingers(startPos=[0,0], length=box_height, angle=0, startCon=[3,3],edge="r")
    llFingers(startPos=[0,box_depth-$th], length=box_height, angle=0, startCon=[2,2],edge="l")
    llFingers(startPos=[$th,0], length=box_depth, angle=90, startCon=[0,0],edge="l")
    llFingers(startPos=[box_height,0], length=box_depth, angle=90, startCon=[0,0],edge="r")
    llCutoutSquare([box_height,box_depth]){;
        difference(){
            llFingers(startPos=[box_height-$th,0], angle=90, length=box_depth,edge="r",startCon=[0,0]);
            toHolder=(box_depth-glass_holder_depth)/2;
            translate([box_height-3*$th,0,-1])cube([3*$th,toHolder,$th+1]);
            translate([box_height-3*$th,glass_holder_depth+toHolder,-1])cube([3*$th,toHolder,$th+1]);
        }
    }
}


module top(){
    // fingers for glassHolder
    module fingersL(){
        llFingers(startPos=[0,0], angle=90, length=box_depth, startCon=[1,1], edge="l");
    }
    llFingers(startPos=[0,0], angle=0, length=box_width, startCon=[1,1], edge="r")
    llFingers(startPos=[$th,0], angle=90, length=box_depth, startCon=[1,1], edge="l")
    llFingers(startPos=[box_width,0], angle=90, length=box_depth, startCon=[1,1], edge="r")
    llFingers(startPos=[0,box_depth-$th], angle=0, length=box_width, startCon=[1,1], edge="l")
    llCutoutSquare([box_width,box_depth]){
        translate([box_width/2,box_depth/2,-1])cylinder(d=glass_outer_dia, h=thickness*2);
        translate([box_width/2,thickness+10])buttons(n = 6, space = 20, button_dia=12);
    };
}

module bottom(){
    center = [[box_width/2, box_depth/2],
              [box_width/2, box_depth/2],
              [box_width/2, box_depth/2],
              [box_width/2, box_depth/2]];

    w = light_holder_width/2;

    corners=[[-w,-w],
             [ w,-w],
             [ w, w],
             [-w, w]] + center;

    llFingers(startPos=[0,0], angle=0, length=box_width, startCon=[1,1], edge="r")
    llFingers(startPos=[$th,0], angle=90, length=box_depth, startCon=[1,1], edge="l")
    llFingers(startPos=[box_width,0], angle=90, length=box_depth, startCon=[1,1], edge="r")
    llFingers(startPos=[0,box_depth-$th], angle=0, length=box_width, startCon=[1,1], edge="l")
    //airduct finger holes
    llFingers(startPos=corners[0], endPos=corners[1], startCon=[1,1], nFingers=5, holeWidth=thickness2)
    llFingers(startPos=corners[1], endPos=corners[2], startCon=[1,1], nFingers=5, holeWidth=thickness2)
    llFingers(startPos=corners[2], endPos=corners[3], startCon=[1,1], nFingers=5, holeWidth=thickness2)
    llFingers(startPos=corners[3], endPos=corners[0], startCon=[1,1], nFingers=5, holeWidth=thickness2)
    llCutoutSquare([box_width,box_depth]){
        translate([box_width/2, box_depth/2]) fan_hole(light_dia, gap=3, rings=10);
    };
}

glass_holder_depth = glass_outer_dia+thickness*2;
module glassHolder(){
    llFingers(startPos=([$th,0]), angle=90, length=box_depth, edge="l", startCon=[1,1])
    llFingers(startPos=([box_width,0]), angle=90, length=box_depth, edge="r", startCon=[1,1])
    translate([0,box_depth/2-glass_holder_depth/2])
    llCutoutSquare([box_width,glass_holder_depth]){
        translate([box_width/2,glass_holder_depth/2,-1]) cylinder(d=glass_inner_dia-4, h=thickness+2);
    };
}

module feet(size, n, taper, i){
        s = sin(taper)*i*$th;
        translate([s/2,s/2,-i*$th-$th])cube([size-s,size-s,$th]);
}


module fan_hole(dia, rings=5, gap=5, tab_width=3){
    for(i=[rings:-1:0]){
        render(){
            outer_ring = i*(dia/rings);
            inner_ring = i*(dia/rings) - gap;
            difference(){
                cylinder(d=outer_ring, $th);
                translate([0,0,-1])cylinder(d=inner_ring, $th+2);
                for(j=[1:i+1]){
                    
                    rotate(i*360/rings/3)rotate(360/(i+1) * j)translate([0,-tab_width/2,-1])cube([dia,tab_width,$th+2]);
                }
                
            }
        }

    }

}


module buttons(n = 5, space = 20, button_dia = 11){
    l=(n-1)*space;

    translate([-l/2,0])
    for(i=[0:n-1]){ // 5 buttons
        translate([i*space,0])cylinder(d=11, h=$th);
    }
}


