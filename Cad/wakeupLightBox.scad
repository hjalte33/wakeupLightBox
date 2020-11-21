include <lasercut/lasercut.scad>;

mt = 6; //material thickness
height = 100;
width = 180;
depth = 150;
glass_radius = 50; // ø100
inner_tube_radius = 35;

clip_height = 30;

lcd_size = [50,20];

$fn=60;
thickness = 3.1;
x = 50;
y = 100;

*box();
*light_cylinder();

generate = 1;

module light_cylinder(){
translate([width/2,depth/2,mt])
    cylinder(height + 200,inner_tube_radius,inner_tube_radius);

}

module box(){
   *top();
    bottom();
    sides();
    front();
    back();
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


module top(){
    translate([0,0,height])
        lasercutoutSquare(
            thickness=mt,
            x = width,
            y = depth,
            finger_joints=[
                [UP,0,5],
                [LEFT,0,5],
                [DOWN,0,5],
                [RIGHT,0,5]],
            circles_remove = [
                [glass_radius,width/2,depth/2]
            ]
        );
    
    //glass holder insert. It has a 1mm tollerace around the edges.
    mySize = glass_radius*2+20;
    translate([1,1,height-mt])
        lasercutoutSquare(
            thickness = mt,
            x = width-2,
            y = depth-2,
            circles_remove = [
                [glass_radius-5,width/2-1,depth/2-1]
            ],
            slits = [
                [DOWN,mt+mt/2-1,0,clip_height-1],
                [DOWN,width-mt-mt/2-1,0,clip_height-1],
                [UP,mt+mt/2-1,depth,clip_height-1],
                [UP,width-mt-mt/2-1,depth,clip_height-1]
            ]
        );
}


module front()
{
    rotate([90,0,0]) 
        lasercutoutSquare(
            thickness = mt,
            x = width,
            y = height,
            finger_joints = [
                [UP,0,5],
                [LEFT,1,5],
                [DOWN,0,5],
                [RIGHT,0,5]
            ],
            cutouts = [
                [width/2-lcd_size[0]/2, height/2-lcd_size[1]/2, lcd_size[0], lcd_size[1]]
            ],
            simple_tabs = [
                [0,width+mt/2,height],
                [DOWN,-mt/2,0]
            ]   
        );
    
}

module sides()
{
    translate([-mt,0,0])rotate([90,0,90])
        lasercutoutSquare(
            thickness = mt,
            x = depth,
            y = height,
            finger_joints = [
                [UP,1,5],
                [LEFT,0,5],
                [DOWN,1,5],
                [RIGHT,1,5]
            ],
            simple_tabs = [
                [0,-mt/2,height],
                [DOWN,depth+mt/2,0]
            ] 
        );
    translate([width,0,0])rotate([90,0,90])
    lasercutoutSquare(
        thickness = mt,
        x = depth,
        y = height,
        finger_joints = [
            [UP,0,5],
            [LEFT,0,5],
            [DOWN,0,5],
            [RIGHT,1,5]
        ],
            simple_tabs = [
                [0,depth+mt/2,height],
                [DOWN,-mt/2,0]
            ] 
    );
    //clips
    translate([mt*2,0,0]) rotate([90,-90,-90])
    lasercutoutSquare(
        thickness = mt,
        x = height,
        y = clip_height,
        clips = [
            [LEFT,0,clip_height/2]
        ]
    );
    translate([mt,depth,0]) rotate([90,-90,90])
    lasercutoutSquare(
        thickness = mt,
        x = height,
        y = clip_height,
        clips = [
            [LEFT,0,clip_height/2]
        ]
    );
    translate([width-mt*2,depth,0]) rotate([90,-90,90])
    lasercutoutSquare(
        thickness = mt,
        x = height,
        y = clip_height,
        clips = [
            [LEFT,0,clip_height/2]
        ]
    );
    translate([width-mt,0,0]) rotate([90,-90,-90])
    lasercutoutSquare(
        thickness = mt,
        x = height,
        y = clip_height,
        clips = [
            [LEFT,0,clip_height/2]
        ]
    );
}

module bottom(){
    translate([0,0,-mt])
        lasercutoutSquare(
            thickness = mt,
            x = width,
            y = depth,
            finger_joints=[
                [UP,1,5],
                [LEFT,1,5],
                [DOWN,1,5],
                [RIGHT,1,5]],
            clip_holes = [
                [RIGHT,mt*2,clip_height/2],
                [RIGHT,mt*2,depth-clip_height/2],
                [RIGHT,width-mt,depth-clip_height/2],
                [RIGHT,width-mt,clip_height/2]
            ]
        );
}

module back(){
    translate([0,depth+mt,0]) rotate([90,0,0])
        lasercutoutSquare(
           thickness = mt,
            x = width,
            y = height,
            finger_joints = [
                [UP,1,5],
                [LEFT,1,5],
                [DOWN,1,5],
                [RIGHT,0,5]
            ],
            simple_tabs = [
                [0,-mt/2,height],
                [DOWN,width+mt/2,0]
            ]

        ); 
        
}