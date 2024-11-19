module Adder(
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [4:0] C
    );
    
    assign C = A+B;
     
endmodule
