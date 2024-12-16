module Execute_tb( );
    
    reg clk;
    reg [6:0] opcode;
    reg [4:0] dstin;
    reg [31:0] src1;
    reg [31:0] src2;
    reg [9:0] offsetlo;
    wire [31:0] result;
    wire [4:0] dstout;
    reg [4:0] src1_reg;
    reg [4:0] src2_reg;
    
    reg [31:0] bp_data;
    reg [31:0] bp_data_mem;
    reg [4:0] bp_reg;
    reg [4:0] bp_reg_mem;
    reg enable;
    wire Nop21;
    //assign enable = ~Nop;
    
    Execution Execution_1(
    .clk(clk),
    .opcode(opcode),
    .dstin(dstin),
    .src1(src1),
    .src1_reg(src1_reg),
    .src2_reg(src2_reg),
    .src2(src2),
    .offsetlo(offsetlo),
    .result(result),
    .dstout(dstout),
    .bp_data(bp_data),
    .bp_data_mem(bp_data_mem),
    .bp_reg(bp_reg),
    .bp_reg_mem(bp_reg_mem),
    .enable(enable),
    .Nop21(Nop21)
    );
    
    always #5 clk = ~clk;   
    initial begin
    enable=1'd1;
    bp_reg=5'd0;
    bp_reg_mem=5'd0;
    src1_reg=5'd1;
    src2_reg=5'd1;
    
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
    
    #10 opcode=7'h02; //opcode
    dstin=5'd8; //dst
    src1=32'd10; //src1
    src2=32'd40; //src2
    offsetlo=10'd0; //constant
    
    end
endmodule
