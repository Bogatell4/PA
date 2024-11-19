module Adder_tb( );
    
    reg clk;
    reg [4:0] result ;
    wire [4:0] resultw;
    reg [3:0] A ;
    reg [3:0] B ;
    
    always #5 clk = ~clk;
    
    Adder Adder_1(A,B,resultw);
    
    always @(posedge clk)
        result = resultw;  
    
    initial begin
        #5 clk = 0;
        #10 A=1; B=1;
        #15 A=3; B=4;
        #20 A=8; B=8;
    end
endmodule
