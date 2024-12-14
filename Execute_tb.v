module Execute_tb( );
    
    reg clk;
    reg [6:0] opcode;
    reg [4:0] dstin;
    reg [31:0] src1;
    reg [31:0] src2;
    reg [9:0] offsetlo;
    wire [31:0] result;
    wire [4:0] dstout;
    
    Execution Execution_1(clk,opcode,dstin,src1,src2,offsetlo,result, dstout);
    
    always #5 clk = ~clk;   
    initial begin
        clk=1'b0;
    opcode=7'h00; //opcode
    dstin=5'd3; //dst
    src1=32'd20; //src1
    src2=32'd10; //src2
    offsetlo=10'd0; //constant
    
    #10 opcode=7'h01; //opcode
    dstin=5'd3; //dst
    src1=32'd20; //src1
    src2=32'd10; //src2
    offsetlo=10'd0; //constant
    
    #10 opcode=7'h01; //opcode
    dstin=5'd8; //dst
    src1=32'd10; //src1
    src2=32'd40; //src2
    offsetlo=10'd0; //constant
    
    end
endmodule
