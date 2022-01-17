include <BOSL/constants.scad>
use <BOSL/masks.scad>
use <BOSL/transforms.scad>

$fa = 0.1; // Set these to 1 for faster preview.
$fs = 0.1; // ----------------------------------
fudge=0.1; // Don't change this value

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
        #cube([11.6,10,33], center=true);      
  }
 }
}
DNA60_Screen();