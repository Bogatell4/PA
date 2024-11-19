module Adder(
    input wire [3:0] A,
    input wire [3:0] B,
    output wire [3:0] C,
    output wire cout   
    );
    
    wire [4:0] result;
    assign result = A+B;
    assign cout = result [4];
    assign C = result [3:0];
    
    
    
endmodule
