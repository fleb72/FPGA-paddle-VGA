module drawing (
    input logic clk25,
    input logic [9:0] x, y,
    input logic signed [1:0] dir,
    input logic inDisplayArea,
    input logic hsync, vsync,
    output logic [3:0] vga_r, vga_g, vga_b,
    output logic vga_hsync, vga_vsync
);


    localparam PADDLE_WIDTH  = 60;
    localparam PADDLE_HEIGHT = 20;
    localparam SCREEN_WIDTH  = 640;
    localparam INIT_POSITION = (SCREEN_WIDTH - PADDLE_WIDTH) / 2; // raquette initialement au centre


    integer paddle_x = INIT_POSITION;
    integer paddle_y = 440;
    integer speed = 10; // Réglage de la vitesse



    always_ff @(posedge clk25) begin

        // Mise à jour de la position, verrouille la position si sortie de l'écran
        if (dir != 0) begin
            if (dir == 1)
                paddle_x <= (paddle_x + speed < SCREEN_WIDTH - PADDLE_WIDTH) ? paddle_x + speed : SCREEN_WIDTH - PADDLE_WIDTH;
            else
                paddle_x <= (paddle_x > speed) ? paddle_x - speed : 0;
        end
    end


// ----- Gestion de l'affichage -----
    logic [3:0] r, g, b;

    always_comb begin
        r = 4'h0; // par défaut
        g = 4'h0;
        b = 4'h0;       

        if (inDisplayArea) begin
            r = 4'h0; // Couleur de fond
            g = 4'h0;
            b = 4'h0; 
        
            // Dessin de la raquette à la nouvelle position
            if (x > paddle_x && x < paddle_x + PADDLE_WIDTH &&
                y > paddle_y && y < paddle_y + PADDLE_HEIGHT) begin
                    r = 4'hF; // Couleur de la raquette
                    g = 4'h0;
                    b = 4'h0;
            end
        end
    end


    always_ff @(posedge clk25) begin
        {vga_hsync, vga_vsync} <= {hsync, vsync};
        {vga_r, vga_g, vga_b}  <= {r, g, b};
    end

endmodule
