module splitter (
    input logic signed [1:0] in,
    output logic [7:0] out
    );

    assign out = (in == 1) ? 8'b00000111 :  // Allume LED 0, 1 et 2
                 (in == -1) ? 8'b11100000 : // Allume LED 6,7 et 8
                 8'b00000000; // Éteint toutes les LEDs si in = 0

endmodule