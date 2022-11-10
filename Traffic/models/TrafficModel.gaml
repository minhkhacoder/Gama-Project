/**
* Name: TrafficModel
* Based on the internal skeleton template. 
* Author: B1906448
* Tags: 
*/

model TrafficModel

global {
	file shapeFileBuilding <- file("../includes/buildings.shp");
	file shapeFileRoad <- file("../includes/roads.shp");
	geometry shape <- envelope(shapeFileBuilding);
	graph roadNetwork;
	
	init{
		create building from: shapeFileBuilding with: [height::int(read("height"))];
		create road from: shapeFileRoad;
		create inhabitant number: 1000{
			location <- any_location_in(any(building));
		}
		roadNetwork <- as_edge_graph(road);
	}
	
	reflex updateSpeed{
		map<road, float> newWeights <- road as_map (each::each.shape.perimeter * each.speedRate);
		roadNetwork <- roadNetwork with_weights newWeights;
	}
}

species building{
	int height;
	
	aspect geom{
		draw shape color: #powderblue;
	}
	
	aspect threeD{
		draw shape color: #grey depth: rnd(10) texture: ["../includes/roof_top.jpg", "../includes/texture5.jpg"];
	}
}

species road{
	float capacity <- 1 + shape.perimeter / 30;
	int noDriver <- 0 update: length(inhabitant at_distance 1);
	float speedRate <- 1.0 update: exp(-noDriver/capacity);
	
	aspect geom{
		draw (shape + 3 * speedRate) color: #firebrick;
	}
}

species inhabitant skills: [moving]{
	point target;
	rgb color <-rnd_color(255);
	float proba_leave <- 0.005;
	float speed <- 5 #km/#h;
	
	reflex leave when: (target = nil) and (flip(proba_leave)){
		target <- any_location_in(any(building));
	}
	
	reflex move when: target != nil{
		do goto target: target on: roadNetwork;
		if (location = target){
			target <- nil;
		}
	}
	
	aspect circle{
		draw circle(5) color: color;
	}
	
	aspect threeD{
		draw pyramid(5) color: color;
		draw sphere(2) at: location + {0, 0, 5} color: color;
	}
}

experiment TrafficModel type: gui {
	output {
		display map type: opengl{
			species building aspect: threeD refresh: false;
			species road aspect: geom;
			species inhabitant aspect: threeD;
		}
	}
}
