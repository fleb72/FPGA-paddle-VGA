module encoder	(
						input logic clock,					// horloge principale
						input logic DT, CLK, 				// signaux de l'encodeur en quadrature
						output logic signed [1:0] dir		// sens de rotation +1 ou -1, 0 si pas de mouvement
);

    logic [2:0] chA, chB;	// pipelines channelA, channelB
	 logic edge_detection;	// détection de front
	 logic up_down;			// avance ou retard de phase ?
	 
	 always_ff @(posedge clock) begin
		chA <= {chA[1:0], DT}; 	// channel A, pipeline signal DT       
		chB <= {chB[1:0], CLK}; // channel B, pipeline signal CLK
	 end
	 
	 // assign edge_detection = (chA[1] ^ chA[2]) || (chB[1] ^ chB[2]);	// prise en compte de TOUS les fronts
	 assign edge_detection = (chA[1] ^ chA[2]);	 
	 assign up_down = chA[1] ^ chB[2];
	 	 
	 always @(posedge clock) begin
      if (edge_detection) 
			dir <= up_down ? 1 : -1; // dir=+1 ou dir=-1 selon le sens de rotation			
		else
         dir <= 0; // dir=0 si pas de rotation détectée		
    end
	  
endmodule
