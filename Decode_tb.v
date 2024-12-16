module Decode_tb( );
    reg clk;
    reg [31:0] instruction;
    wire [6:0] opcode;
    wire [4:0] dst;
    wire [9:0] offsetlo;
    
    wire [31:0] src1;
    wire [31:0] src2;
    
    always #5 clk = ~clk;   
    initial begin
     clk=1'b0;
     
     #10 instruction[31:25]=7'h01; //opcode
     instruction[24:20]=5'd3; //dst
     instruction[19:15]=5'd1; //src1
     instruction[14:10]=5'd12; //src2
     instruction[9:0]=10'd0; //constant
     
    end
    
    Decode Decode_1(clk,instruction,opcode,dst,src1,src2,offsetlo);



endmodule
