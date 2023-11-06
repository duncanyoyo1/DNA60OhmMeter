include <BOSL/constants.scad>
use <BOSL/masks.scad>
use <BOSL/transforms.scad>
use <BOSL/metric_screws.scad>

$fa = 0.05; // Set these to 1 for faster preview.
$fs = 0.05; // ----------------------------------

metric_bolt(size=1.6, l=12, coarse=false);