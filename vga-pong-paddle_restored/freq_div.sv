module freq_div (
    // diviseur de fréquence
    input logic clk_in,     // Horloge d'entrée
    output logic clk_out    // Horloge de sortie
);

    logic [14:0] counter = 0;

    always_ff @(posedge clk_in) begin
        counter <= counter + 1;
    end

    assign clk_out = counter[14];
endmodule