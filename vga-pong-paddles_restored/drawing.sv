module drawing (
    input logic clk25,
    input logic [9:0] x, y,
    input logic signed [1:0] dir2,
    input logic signed [1:0] dir1,
    input logic inDisplayArea,
    input logic hsync, vsync,
    output logic [3:0] vga_r, vga_g, vga_b,
    output logic vga_hsync, vga_vsync
);


    localparam PADDLE_WIDTH  = 60;
    localparam PADDLE_HEIGHT = 20;
    localparam SCREEN_WIDTH  = 640;
    localparam INIT_POSITION = (SCREEN_WIDTH - PADDLE_WIDTH) / 2; // raquette initialement au centre
    localparam X = 0;
    localparam Y = 1;
   
    logic [1:0][1:0] dir; // Tableau contenant 2 bus de 2 bits chacun
    assign dir = '{dir1, dir2};


    logic [9:0] paddle [2][2] = '{ 
                                   '{INIT_POSITION, 440},  // Paddle 1
                                   '{INIT_POSITION,  20}   // Paddle 2
                                 };

   
    integer speed = 10; // Réglage de la vitesse



    always_ff @(posedge clk25) begin 
       for (int i = 0; i < 2; i++) begin
          if (dir[i] != 0) begin
            if (dir[i] == 1) begin
              paddle[i][X] <= (paddle[i][X] + speed < SCREEN_WIDTH - PADDLE_WIDTH) ? paddle[i][X] + speed : SCREEN_WIDTH - PADDLE_WIDTH;
            end else begin
              paddle[i][X] <= (paddle[i][X] > speed) ? paddle[i][X] - speed : 0;
            end
          end
       end
    end


// ----- Gestion de l'affichage -----
    logic [3:0] r, g, b;

    always_comb begin
      r = 4'h0;  // Couleur de fond
      g = 4'hF;
      b = 4'hF; 

      if (inDisplayArea) begin
          for (int i = 0; i < 2; i++) begin
            if (x > paddle[i][X] && x < paddle[i][X] + PADDLE_WIDTH &&
                y > paddle[i][Y] && y < paddle[i][Y] + PADDLE_HEIGHT) begin
                  r = 4'hF;  // Couleur de la raquette
                  g = 4'h0;
                  b = 4'h0;
           end
        end
      end
   end   

    always_ff @(posedge clk25) begin
        {vga_hsync, vga_vsync} <= {hsync, vsync};
        {vga_r, vga_g, vga_b}  <= {r, g, b};
    end

endmodule
