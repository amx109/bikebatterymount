/*
Some known units

units=mm
bike tube has 24mm dia
battery is 70x48x21
dc2dc 45x30x12

*/

/***** variables ******/
bikeTubeDiameter = 24;
rBike = bikeTubeDiameter/2; //radius of bike steel tube
lHolder = 50; //length of battery holder
batteryX = 70; 
batteryY = 48; 
batteryZ = 21; 
dc2dcX = 45;
dc2dcY = 30;
dc2dcZ = 12;

usbSocketX = 19;
usbSocketY = 12;
usbSocketZ = 4.5;

usbSocketNotToExpose = 8.6; // 19-8.6 = 10.4



module gimmeCube(x,y,z)
{
	rotate([0,-90,0])
	{
		cube([x,y,z]);
	}
}

module boltHole(size) //generic of given diameter bolt (long)
{
	rotate([0,90,0])
	{
		cylinder(rBike*6,size/2,size/2,$fn=50);
	}

}

module bikeClipOutline() //the bike clip shape
{
	union()
	{
		//the bit that sits around the tube
		rotate([90,0,0])
		{
			cylinder(lHolder,rBike+3,rBike+3,$fn=50);
		}
	
		//the bit where the nut+bolts go to hold it onto the bike
		translate([-rBike-3,-lHolder,(-rBike*2.5)+3])
		{
			cube([(rBike*2)+6,lHolder,(rBike*2.5)-3]);
		}
	}
}

/*************** the bit that clips onto the bike *******************/
module bikeClip()
{
	difference()
	{
		bikeClipOutline();
			
		//bike tube
		translate([0,30,0])
		{
			rotate([90,0,0])
			{
				#cylinder(lHolder*2,rBike+0.5,rBike+0.5,$fn=50); //+0.5mm to r to give a better fit
			}
		}
	
		//gap under the bike tube
		translate([-rBike+0.5,-lHolder-5,-rBike*3])
		{
			cube([(rBike*2)-1,lHolder+10,rBike*3]);
		}
	
		//hole for bolts #1
		translate([-35,-10,-20])
		{	
			boltHole(5);
		}
	
		//hole for bolts #2
		translate([-35,-lHolder+10,-20])
		{	
			boltHole(5);
		}
		
		//gap between holes is lholder-20
	}
}

/******************** the battery+dc2dc holder ***********************/
module dc2dcCase()
{
	difference()
	{
		//outside case
		gimmeCube(batteryY+6,dc2dcY+13,batteryZ+7); //2mm walls

		//space for dc2dc converter
		translate([-3,8.6,3])
		{
			gimmeCube(dc2dcX+2,dc2dcY+2,batteryZ+2); //1mm space all round
		}
		
		//hole for wiring
		translate([-15,37,45])
		{
			rotate([0,0,90])
			{
				boltHole(4);
			}
		}
	}
}

module batteryCaseMountHole()
{
	difference()
	{
		union()
		{
			translate([-4,0,0])
			{
				cube([8,9,(rBike*2)-2]);
			}
			cylinder((rBike*2)-2,4,4,$fn(50));
			
		}
	
		rotate([0,90,0])
		{
			translate([-50,0,0])
			{
				boltHole(5);
			}
		}
	}
}

module batteryCase()
{
	rotate([90,0,0])
	{
		difference()
		{	
			//outsdide casing
			gimmeCube(batteryX+8,batteryY+6,batteryZ+7); //3mm walls

			//battery
			translate([-3,2,0])
			{
				gimmeCube(batteryX+2,batteryY+2,batteryZ+2); //1mm spacing all round
			}
			
			//gap to allow battery into holder
			translate([7,-5,40])
			{
				gimmeCube(batteryX-30,batteryY+20,batteryZ+20); //3mm walls
			}

			//hole for battery strap
			translate([-21,17,37])
			{
				rotate([-90,0,0])
				{
					gimmeCube(20,2,8); //holes to place retaining velcro strap
				}
			}
		}
	}
}

/****************** the actual caseing and clip 8********************/
module case()
{
	difference()
	{	
		//add the two case together, plus mount holes
		union()
		{
			dc2dcCase();
			batteryCase();
			translate([-4,0+3,61.5])
			{
				rotate([-90,0,90])
				{
					batteryCaseMountHole(); //front mount
				}
			}
			
			translate([-4,30+3,61.5])
			{
				rotate([-90,0,90])
				{
					batteryCaseMountHole(); //rear mount
				}
			}
		}
		
		//remove usb connector
		translate([-3-5.86,-8,2+21.6])
		{
			rotate([0,90,90])
			{
				gimmeCube(usbSocketX+1, usbSocketY+1, usbSocketZ+1);
			}
		}
	}
}

module caseWithoutLid()
{
	difference()
	{
		case();
		
		//remove area for lid
		translate([2.5,-85,-3.5])
		{
			gimmeCube(60,140,6);
		}
	}
}

module caseLid()
{
	difference()
	{
		case();
		
		//remove everything but lid
		translate([-3.5,-85,-3.5])
		{
			gimmeCube(80,140,50);
		}
	}
}


module display()
{
	bikeClip();
	translate([15,-43,-81.5])
	{
		case();
		//caseWithoutLid();
		//caseLid();
	}
}

module printClip()
{
	rotate([-90,0,0])
	{
		bikeClip();
	}
}

module printCase()
{
	translate([0,0,26])
	{
		rotate([0,-90,0])
		{
			caseWithoutLid();
		}
	}
	
	translate([10,0,0])
	{
		rotate([0,90,0])
		{
			caseLid();
		}
	}
}

// display option allows you to view the model
// the case almost fills a typical reprap bed
// recommend printing the clip and case seperately
render()
{
	display();
	//printClip();
	//printCase();
}


