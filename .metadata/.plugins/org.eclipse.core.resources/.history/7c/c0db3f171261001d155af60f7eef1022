/**
* Name: areTheyHappy
* Based on the internal skeleton template. 
* Author: ADMIN
* Tags: 
*/

model areTheyHappy

global {
	/** Insert the global definitions, variables and actions here */
	geometry shape <- square(500#m);
	int nb_people <- 30000;
	float rate_similar_wanted <- 0.5;
	float neighbours_distance <- 5.0;
	int nb_happy_people <- 0 update: people count each.is_happy;
	
	init{
		create people number: nb_people;
	}
	
	reflex end_simulation when: nb_people = nb_happy_people {
		do pause;
	}
}

species people{
	rgb color <- flip(0.5) ? rgb(175, 34, 0) : rgb(242, 198, 0);
	bool is_happy <- false;
	list<people> neighbours update: people at_distance neighbours_distance;
	
	aspect circle{
		draw circle(2) border: rgb(88, 17, 0) color: color;
	}
	
	reflex computing_similarity {
		float rate_similar <- 0.0;
		if (empty(neighbours)) {
			rate_similar <- 1.0;
		} else {
			int nb_neighbours <- length(neighbours);
			int nb_neighbours_sim <- neighbours count (each.color = color);
			rate_similar <- nb_neighbours_sim /nb_neighbours ;
		}
		is_happy <- rate_similar >= rate_similar_wanted;
	}
	
	reflex moving when: not is_happy {
		location <- any_location_in(world);
	}
}

experiment runNow type: gui {
	/** Insert here the definition of the input and output of the model */
	parameter "number of people" var: nb_people;
	parameter "Rate similar wanted" var: rate_similar_wanted min: 0.0 max: 1.0;
	parameter "Neighbours distance" var: neighbours_distance step: 1.0;
	output {
		monitor "number of happy people" value: nb_happy_people;
		display map{
			species people aspect: circle;
		}
		
		display chart{
			chart "evolution of the number of happy people" type: series{
				data "number of happy people" value: nb_happy_people color: #green;
			}
		}
	}
}
