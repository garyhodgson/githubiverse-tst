/* 
* Parameters
*/
bearing_diameter = 10;
bearing_bore_diameter = 3;
bearing_height = 4;
wheel_diameter = 90;
wheel_bore_diameter = 3;
wheel_height = 10;
frame_thickness = 2;


/* 
* Assembly / Printing
*/
wheel();
small_wheel();
// for print use rotate
//translate([0, 0, 54]) rotate([0, 90, 0]) rotate([0, 0, 30])
frame();


/* 
* Modules
*/
module frame(){
	a = wheel_diameter/2 + 15;
	b = wheel_diameter/4 + 20;

	translate([0,0,-6]){
		difference(){
			union(){
				cylinder(r=wheel_bore_diameter*2, h=frame_thickness, center=true);
				rotate([0,0,-75])
				linear_extrude(height=frame_thickness, center=true)
					polygon(points=[[-6,0],[0,-6],[a,15],[15,a]]);
			}
			cylinder(r=wheel_bore_diameter/2, h=frame_thickness, center=true);
		}
	}


	rotate([0, 0, -30])
	translate([(wheel_diameter/2)/2 + 0.7 ,0 , 5.5]){
		difference(){
			union(){
				cylinder(r=wheel_bore_diameter*2, h=frame_thickness, center=true);
				rotate([0,0,-45])
				linear_extrude(height=frame_thickness, center=true)
					polygon(points=[[-6,0],[0,-6],[b,0],[0,b]]);
			}
			cylinder(r=wheel_bore_diameter/2, h=frame_thickness, center=true);
		}
	}

	#rotate([0, 0, -30])
	translate([a - 7 ,0 , 3]){

		cube(size=[frame_thickness, 64, 20], center=true);
	}
	
}


module small_wheel(){

	bearings();

	rotate([0, 0, -30]) 
		small_wheel_arm();
	
	translate([wheel_diameter/2 - bearing_diameter/2,0,0])
	rotate([0, 0, -150]) 
	small_wheel_arm();

	rotate([0, 0, -60])
	translate([wheel_diameter/2 - bearing_diameter/2,0,0])
	rotate([0, 0, 150]) 
	small_wheel_arm();

	rotate([0, 0, -30])
	translate([(wheel_diameter/2)/2 + 0.7 ,0,3])	
		difference(){
			cylinder(r=10, h=2, center=true);
			cylinder(r=2, h=5, center=true);
		}
	

	module small_wheel_arm(){
		translate([0,0,3]){
			difference(){
				cylinder(r=bearing_diameter/2, h=2, center=true);
				cylinder(r=bearing_bore_diameter/2, h=2, center=true);
			}

			translate([wheel_diameter/8,0,0])
				cube(size=[wheel_diameter/4 - 6 , 4, 2], center=true);

		}		
	}

	module bearings(){
		%bearing();

		%translate([wheel_diameter/2 - bearing_diameter/2, 0, 0])
			bearing();

		%rotate([0, 0, -60])
		translate([wheel_diameter/2 - bearing_diameter/2, 0, 0])
			bearing();
	}
	
	module bearing(){
		difference(){
			cylinder(r=bearing_diameter/2, h=bearing_height, center=true);
			cylinder(r=bearing_bore_diameter/2, h=bearing_height+1, center=true);
		}
	}
}


module wheel(){
	difference(){
		union(){
			translate([0, 0, -3.25]) {
				difference(){
					cylinder(r=wheel_diameter/2 + 0.75, h=1.5, center=true);
					cylinder(r=wheel_diameter/2 - 4, h=2, center=true);
				}
			}
				

			grooves();	
		}
		cylinder(r=2, h=10, center=true);
	}

	module grooves(){
		difference(){

			union(){
				groove();

				rotate([0, 0, 60])
					groove();

				rotate([0, 0, -60])
					groove();
			}

			translate([0, 0, 2.5])
			cylinder(r=12.5, h=10, center=true);
		}
	}	

	module groove(){
		difference() {
			translate([0, 0, -1])
			cube(size=[wheel_diameter, bearing_diameter+4+0.5, bearing_height+2], center=true);

			cube(size=[wheel_diameter+10, bearing_diameter+0.5, bearing_height+1], center=true);
		}
		
	}
}