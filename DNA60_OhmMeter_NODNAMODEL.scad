include <BOSL/constants.scad>
use <BOSL/masks.scad>
use <BOSL/transforms.scad>

$fa = 0.1; // Set these to 1 for faster preview.
$fs = 0.1; // ----------------------------------
fudge=0.1; // Don't change this value

// Which one would you like to see?
part = "box"; // [box:Box only, top: Top cover only, both: Box and top cover]

// Size of your printer's nozzle in mm
nozzle_size = 0.4;

// Number of walls the print should have
number_of_walls = 5; // [1:5]

// Tolerance (use 0.2 for FDM)
tolerance = 0.2; // [0.1:0.1:0.4]

// Outer x dimension in mm
x=120;

// Outer y dimension in mm
y=60;

// Outer z dimension in mm
z=30;

// Radius for rounded corners in mm
radius=5; // [1:20]

/* Hidden */
//$fn=100;
wall_thickness=nozzle_size*number_of_walls;
hook_thickness = 3*nozzle_size;

top_cover_wall_thickness = hook_thickness + wall_thickness;

module bottom_box () {
    difference(){
        // Solid box
        linear_extrude(z-wall_thickness){
            minkowski(){
                square([x-radius*2,y-radius*2], center=true);
                circle(radius);
            }
        }
        
        // Hollow out
        translate([0,0,wall_thickness]) linear_extrude(z){
            minkowski(){
                square([x-radius*2-wall_thickness*2+wall_thickness*2,y-radius*2-wall_thickness*2+wall_thickness*2], center=true);
                circle(radius-wall_thickness);
            }
        }
    }
    left_hook(); // left hook
    rotate([180,180,0]) left_hook(); // right hook
    front_hook(); // front hook
    rotate([180,180,0]) front_hook(); // back hook
    // TODO: hooks on the other two sides
}

module left_hook () {
    translate([(x-2*wall_thickness)/2,-y/2+radius*2,z-wall_thickness]) rotate([0,90,90]) linear_extrude(y-2*radius*2){
    polygon(points=[[0,0],[2*hook_thickness,0],[hook_thickness,hook_thickness]]);
    }
}


module front_hook () {
    translate([(-x+4*radius)/2,-y/2+wall_thickness,z-wall_thickness]) rotate([90,90,90]) linear_extrude(x-2*radius*2){
    polygon(points=[[0,0],[2*hook_thickness,0],[hook_thickness,hook_thickness]]);
    }
}


module right_grove () {
    translate([-tolerance/2+(x-2*wall_thickness)/2,-y/2+radius,wall_thickness+hook_thickness*2]) rotate([0,90,90]) linear_extrude(y-2*radius){
    polygon(points=[[0,0],[2*hook_thickness,0],[hook_thickness,hook_thickness]]);
    }
}


module front_grove () {
    translate([(-x+2*radius)/2,-y/2+wall_thickness+tolerance/2,wall_thickness+hook_thickness*2]) rotate([90,90,90]) linear_extrude(x-2*radius){
    polygon(points=[[0,0],[2*hook_thickness,0],[hook_thickness,hook_thickness]]);
    }
}

module top_cover () {

    // Top face
    linear_extrude(wall_thickness){
        minkowski(){
            square([x-radius*2,y-radius*2], center=true);
            circle(radius);
        }
    }
    
    difference(){
        // Wall of top cover
        linear_extrude(wall_thickness+hook_thickness*2){
            minkowski(){
                square([x-radius*2-wall_thickness*2-tolerance+wall_thickness*2,y-radius*2-wall_thickness*2-tolerance+wall_thickness*2], center=true);
                circle(radius-wall_thickness);
            }
        }
        
        // Hollow out
        // TODO: If radius is very small, still hollow out

        translate([0,0,wall_thickness]) linear_extrude(z){
            minkowski(){
                square([x-radius*2-wall_thickness*2-2*top_cover_wall_thickness-tolerance+wall_thickness*2+top_cover_wall_thickness*2,y-radius*2-wall_thickness*2-2*top_cover_wall_thickness-tolerance+wall_thickness*2+top_cover_wall_thickness*2], center=true);
            circle(radius-wall_thickness-top_cover_wall_thickness);
            }
        }
    right_grove();
    rotate([180,180,0]) right_grove();
    front_grove();
    rotate([180,180,0])  front_grove();
    }
  

}

module print_part() {
	if (part == "box") {
    translate([0,-32,30])
    rotate([0,180,0])
		bottom_box();
	} else if (part == "top") {
		top_cover();
	} else if (part == "both") {
		both();
	} else {
		both();
	}
}

module both() {
	translate([0,-(y/2+wall_thickness),(-z)]) bottom_box();
    translate([0,+(y/2+wall_thickness),0]) top_cover();
}

module standoff (){
  rotate([90,0,0])
  difference () {
  cylinder(r=1.25,h=2.4,center=true);
  cylinder(r=0.625,h=3,center=true);
  }
}

module DNA60_Screen (){
        union(){
        translate([12,-1,5.5])
        cube([8,14,1], center=true);
        difference(){
        translate([0,-1,3])
        rotate([90,0,90])
        cube([14,4,32], center=true);
        translate([-2,-1,0.5])
        rotate([90,0,90])
        cube([11.65,10,33], center=true);      
  }
 }
}

 module mUSB(){ 
  //usb.org CabConn20.pdf
  
  M= 6.9;   //Rece inside width
  N= 1.85;  //Rece inside Height -left/right
  
  C= 3.5;   //Plastic width
  X= 0.6;   //plastic height
  U= 0.22;  //plastic from shell
  P= 0.48;  //Conntacst from plastic
  
  Q= 5.4;   //shell inside bevel width
  R= 1.1;   //shell inside bevel height -left/right
  
  S= 4.75;  //Latch separation 
  T= 0.6;   //Latch width -left/right
  V= 1.05;  //Latch recess
  W= 2.55;  //Latch recess
  Y= 0.56;  //Latch Height
  Z= 60;    //Latch Angle
  
  H= 2.6;   //Pin1-5 separation
  I= 1.3;   //Pin2-4 separation
  conWdth= 0.37; //# contact width
  
  conThck= 0.1; //contact thickness
  
  //JAE DX4R005J91
  r=0.25; //corner radius
  t=0.25; //sheet thickness
  
  //flaps
  flpLngth=0.6;
  flpDimTop=[6.2,flpLngth,t];
  flpDimBot=[5.2,flpLngth,t];
  flpDimSide=[0.75,flpLngth,t];
  
  flpAng=40;
  
  THT_OZ=-(5-1.8);
  legDim=[0.9,0.65-r/2,t];
  
  translate([0,-THT_OZ,0]){
    //THT pins
    color("silver"){
      for (ix=[-1,1]){
        translate([ix*(6.45/2-r),THT_OZ,t/2])
          rotate(ix*-90)
            bend(size=legDim,radius=r,angle=-90,center=true)
              flap(legDim);
      }
      translate([0,THT_OZ,t/2]) cube([6.45-r*2,0.9,t],true);  
    }
    
    //SMD pads
    padDim=[1,1,t];
    color("silver")
      for (ix=[-1,1]){
        translate([ix*(M+t)/2,-(padDim.x/2),r+t]) rotate([-90,0,ix*-90])
          bend(padDim,angle=-90,radius=r+t/2,center=true)
            flap(padDim);
        translate([ix*(M+t)/2,-(padDim.x/2),1.1/2+t/2+r])
          cube([t,padDim.x,1.1-r],true);
      }
      
    //SMD pins
      for (ix=[-H/2,-I/2,0,I/2,H/2]){
        color("gold")
        translate([ix,-0.7,r+conThck/2])
          rotate([-90,0,0])
            bend([conWdth,1-r,conThck],center=true,angle=90,radius=r)
              cube([conWdth,1-r,conThck],center=true);
        color("gold")
        translate([ix,-W/2-1-t,-X+t+N-(conThck)/2]) 
          cube([conWdth,W-fudge,conThck],true); 
     }
     
    //plastics
    color("darkSlateGrey")
      translate([0,-t,N/2+t])
        rotate([90,0,0])
         hull()
            for (ix=[-1,1],iy=[-1,1])
              translate([ix*(M/2-r),iy*(N/2-r)]) cylinder(r=r-0.01, h=1);
    color("darkSlateGrey")
       translate([0,-W/2-1-t,-X/2+t+N-U]) plastic();     
                
    //metal-body with cutouts
    color("silver"){
      difference(){
        shell();
        translate([0,THT_OZ,t+(t+1)/2]) cube([7.4+fudge,1,1+t],true);
        translate([0,-(1+t)/2+fudge/2,(t+1.1-fudge)/2]) cube([7.4+fudge,1+t+fudge,1.1+t+fudge],true);
        //Latch
        for (ix=[-1,1])
          translate([ix*S/2,THT_OZ,N+t*1.5]) cube([T,1.2,t+fudge],true);
      }
      //flaps
      translate([0,-5,N+t/2+t])
        rotate(180)
          bend(flpDimTop,angle=flpAng,radius=r,center=true)
            flap(flpDimTop);
      translate([0,-5,t/2])
        rotate(180)
        bend(flpDimBot,angle=-flpAng,radius=r,center=true)
          flap(flpDimBot);
      for (ix=[-1,1])
        translate([ix*(M+t)/2,-5,t+N-R/2])
          rotate([0,ix*-90,180])
            bend(flpDimSide,angle=flpAng,radius=r,center=true)
              flap(flpDimSide);
    }
  }

  module plastic(){
    difference(){
      cube([C,W,X],true);
      for (ix=[-H/2,-I/2,0,I/2,H/2])
        translate([ix,0,-X/2+(X-P+conThck-fudge)/2]) 
          cube([conWdth,W+fudge,X-P+conThck+fudge],true); 
    }
  }
  
  module shell(){
    translate([0,0,N-R/2+t])
      rotate([90,0,0]){
          difference(){ //2D
            shape(radius=r+t,length=5);
            translate([0,0,-fudge/2]) shape(radius=r,length=5+fudge);
          }
    }
  }

  //the usb shape
  module shape(radius=r,length=5){
    hull(){
      for (ix=[-1,1],iy=[-1,1])
        translate([ix*(M/2-r),iy*(R/2-r),0]) cylinder(r=radius,h=length);
      for (ix=[-1,1])
        translate([ix*(Q/2-r/2),-N+(R/2+r),0]) cylinder(r=radius,h=length);
    }
  }
 
  module flap(size){
    hull() for (ix=[-1,1])
      translate([ix*(size.x/2-r),size.y/2-r,0]) cylinder(r=r,h=size.z,center=true); 
    translate([0,-r/2,0]) cube([size.x,size.y-r,size.z],true);
  }
  module pcb(){
      difference(){
      translate([0,6.25,-0.75])
      cube([16.85,15.5,1.65], center=true);
      translate([-7.25,12.75,-0.75])
      cylinder(r=1, h=1.8, center=true);
      translate([7.25,12.75,-0.75])
      cylinder(r=1, h=1.8, center=true);  
   }
  }
 pcb();
module bend(size=[50,20,2],angle=45,radius=10,center=false, flatten=false){
  alpha=angle*PI/180; //convert in RAD
  strLngth=abs(radius*alpha);
  i = (angle<0) ? -1 : 1;
  
  
  bendOffset1= (center) ? [-size.z/2,0,0] : [-size.z,0,0];
  bendOffset2= (center) ? [0,0,-size.x/2] : [size.z/2,0,-size.x/2];
  bendOffset3= (center) ? [0,0,0] : [size.x/2,0,size.z/2];
  
  childOffset1= (center) ? [0,size.y/2,0] : [0,0,size.z/2*i-size.z/2];
  childOffset2= (angle<0 && !center) ? [0,0,size.z] : [0,0,0]; //check
  
  flatOffsetChld= (center) ? [0,size.y/2+strLngth,0] : [0,strLngth,0];  
  flatOffsetCb= (center) ? [0,strLngth/2,0] : [0,0,0];  
  
  angle=abs(angle);
  
  if (flatten){
    translate(flatOffsetChld) children();
    translate(flatOffsetCb) cube([size.x,strLngth,size.z],center);
  }
  else{
    //move child objects
    translate([0,0,i*radius]+childOffset2) //checked for cntr+/-, cntrN+
      rotate([i*angle,0,0]) 
      translate([0,0,i*-radius]+childOffset1) //check
        children(0);
    //create bend object
    
    translate(bendOffset3) //checked for cntr+/-, cntrN+/-
      rotate([0,i*90,0]) //re-orientate bend
       translate([-radius,0,0]+bendOffset2)
        rotate_extrude(angle=angle) 
          translate([radius,0,0]+bendOffset1) square([size.z,size.x]);
  }
}
}

module mUSB_Standoff(){
  union(){
    difference(){
      translate([6.1,0,-1.4])
      rotate([45,90,45])
      cylinder(2.3,1.38,1.38,$fn=3);
      translate([7.25,0,0])
      rotate([0,0,0])
      standoff();
    }
    difference(){
      translate([-8.4,0,-1.4])
      rotate([45,90,45])
      cylinder(2.3,1.38,1.38,$fn=3);
      translate([-7.25,0,0])
      rotate([0,0,0])
      standoff();
    }
    translate([-7.25,0,0])
    rotate([0,0,0])
    standoff();
    translate([7.25,0,0])
    rotate([0,0,0])
    standoff();
    translate([-8.4,0,-1.4])
    rotate([45,90,45])
    cylinder(2.3,1.38,1.38,$fn=3);
    translate([6.1,0,-1.4])
    rotate([45,90,45])
    cylinder(2.3,1.38,1.38,$fn=3);
  }
}

module mUSB_hole(){
    fillet(fillet=1.5, size=[8.5,10,3.25], $fn=64) {
    cube(size=[8.5,10,3.25], center=true);
 }
}

module HexNut(){
 cylinder(r=2.25, h=2, $fn=6);   
}

module battery_sled(){
    translate([0.5,0,-10.75])
    difference(){
    translate([-13.6,0,40.5])
    cube([24,24.5,81], center=true); // fix
    translate([-13.5,0,2])
    cylinder(h=77,d=22);
    translate([-24,0,40.5])
    cube([21,22,77], center=true);
    translate([-72,0,40.5])
    rotate([90,0,0])
    cylinder(r=60, h=30, center=true);
    translate([-10,0,2])
    rotate([0,0,0])
    cube([14,6.35,1], center=true);
    translate([-10,0,79])
    rotate([0,0,0])
    cube([14,6.35,1], center=true);
    translate([-4.5,0,2])
    cube([4,6.35,5], center=true);
    translate([-4.5,0,79])
    cube([4,6.35,5], center=true);
 }
}

module battery_21700(){
  translate([10,0,15.5])
  rotate([0,90,0])
  cylinder(h=70.5,d=21);
}

module standoff_mount (){
  rotate([90,0,0])
  difference () {
  cylinder(r=2.5,h=4.75,center=true);
  cylinder(r=0.75,h=5,center=true);
  }
}

module DNA60_Mount(){
  translate([9.21,-3,9.4])
  standoff_mount();
  translate([-9.15,-3,9.4])
  standoff_mount();
  translate([9.15,-3,-3.5])
  standoff_mount();
  translate([-9.15,-3,-3.5])
  standoff_mount();
}

module DNA60_Screen_Hole(){
  linear_extrude(5){
        minkowski(){
            square([6-2*2,23-2*2], center=true);
            circle(2);
        }
    }
}

module C510() {
    union(){
        cylinder(d=22.05,h=0.9, center=true);
        translate([0,0,-6.05])
        cylinder(d=10.25,h=13, center=true);
        translate([0,0,-4])
        HexNut510();
      }
}

module HexNut510 (){
  difference(){
    cylinder(d=12, h=2, $fn=6);
    cylinder(d=8.9, h=3);   
  }
}

module Button_Holes (){
    translate([22.7,0,0])
    up(5) fillet_hole_mask(r=5.5, fillet=2);
    translate([22.7,0,0])
    cylinder(d=11, h=10, center=true);
    translate([0,-5.75,0])
    up(5) fillet_hole_mask(r=2.5, fillet=2);
    translate([0,-5.75,0])
    cylinder(d=5, h=10, center=true);
    translate([0,5.75,0])
    up(5) fillet_hole_mask(r=2.5, fillet=2);
    translate([0,5.75,0])
    cylinder(d=5, h=10, center=true);
}

module Up_Down_Button(){
  translate([0,5.75,0])
    union(){
        difference(){
            cylinder(d=4.5,h=6);
            up(5.5) fillet_cylinder_mask(r=2.25, fillet=2.25);
        }
        translate([0,0,-0.75])
        cylinder(d=6,h=2.5);
    }
    translate([0,-5.75,0])
    union(){
        difference(){
            cylinder(d=4.5,h=6);
            up(5.5) fillet_cylinder_mask(r=2.25, fillet=2.25);
        }
        translate([0,0,-0.75])
        cylinder(d=6,h=2.5);
    }
}

module Fire_Button(){
    union(){
        difference(){
            cylinder(d=10.75,h=6);
            up(5.5) fillet_cylinder_mask(r=5.375, fillet=2.5);
        }
        cylinder(d=12,h=1.5);
    }
}

//#print_part();

/*translate([15,-40,18])
rotate([0,0,-90])
DNA60();*/
difference(){
translate([31.4,-48.25,29])
rotate([90,0,90])
DNA60_Mount();
translate([34.35,-48.25,24.32])
cube([28.5,15.25,1.4], center=true);
}
translate([-10,-47,30])
rotate([0,180,0])
DNA60_Screen();
/*translate([-17,-58,27])
rotate([-90,0,0])
mUSB();*/
translate([-17,-60.75,14.3])
rotate([0,180,0])
mUSB_Standoff();
translate([40,-18,30])
rotate([0,-90,0])
battery_sled();
//battery_21700();
difference(){
  print_part();
  translate([-17,-56.8,28])
  rotate([-90,0,0])
  mUSB_hole();
  translate([-10,-47,26])
  rotate([0,0,90])
  DNA60_Screen_Hole();
  translate ([20.5,-48.25,25.1])
  Button_Holes();
  translate([-17,-58,27])
  rotate([-90,0,0])
  mUSB();
  translate([-45,-17,29.75])
  C510();
  translate([-24.25,-60.555,14.3])
  rotate([90,0,0])
  cylinder(r=0.625,h=1.5,center=true);
  translate([-9.75,-60.555,14.3])
  rotate([90,0,0])
  cylinder(r=0.625,h=1.5,center=true);
}
/*translate([-45,-17,32.75])
#cylinder(d=30,h=10, center=true, $fa=0.1, $fs=0.1);*/

translate([43.25,-48.25,26.5])
Fire_Button();
translate ([20.6,-48.4,26])
Up_Down_Button();
//translate([-47,-15,29])
//C510();
