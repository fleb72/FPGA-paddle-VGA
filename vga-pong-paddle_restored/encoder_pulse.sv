module encoder_pulse (
    input logic clk25,  // Horloge rapide 25 MHz
    input logic signed [1:0] dir, // Signal encodeur (+1, -1, ou 0)
    output logic signed [1:0] pulse_dir // Impulsion unique et verrouillée
    );

logic signed [1:0] dir_old;
logic signed [1:0] locked_dir;

always_ff @(posedge clk25) begin
    dir_old <= dir;

        // Si changement, mise à jour de la direction
        if (dir != dir_old) begin
            locked_dir <= dir;  // Stocke la nouvelle direction
        end else begin
            locked_dir <= 0;  // Remise à zéro après un cycle
        end
    end

    assign pulse_dir = locked_dir; // Sortie stabilisée

endmodule
