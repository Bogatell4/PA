module Adder_tb( );
    
    reg clk;
    reg [4:0] result ;
    reg [3:0] A ;
    reg [3:0] B ;
    
    always #5 clk = ~clk;
    
    Adder Adder_1(A,B,result);
    
    initial begin
        #5 clk = 0;
        #10 A=1; B=1;
        #15 A=3; B=4;
        #20 A=8; B=8;
    end
endmodule
