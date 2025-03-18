module Fetch(

input wire [4:0]jumpPC,
input wire clk,
output reg [31:0] insReg, //final reg of the fetch stage
input wire jump, //jump=1 means override the PC
input wire trapPC,
input wire enable

);

wire [31:0]insRegwire;

reg [31:0] insMem [31:0];
reg [4:0] PC;
integer i;

initial begin //initial block, only for simulation
    PC = 4'd0;
    for (i=0; i < 32; i=i+1) begin
        insMem[i]=32'd0;
    end
    //instr 0 ADD r1,r2->r3 R-TYPE
    insMem[0] [31:25]=7'h00; //opcode
    insMem[0] [24:20]=5'd3; //dst
    insMem[0] [19:15]=5'd1; //src1
    insMem[0] [14:10]=5'd2; //src2
    insMem[0] [9:0]=10'd0; //constant
    
    //instr 12  M-TYPE
    insMem[12] [31:25]=7'h00; //opcode
    insMem[12] [24:20]=5'd3; //dst
    insMem[12] [19:15]=5'd1; //src1
    insMem[12] [14:0]=5'd2; //offset
    
    //instr 22  B-TYPE
    insMem[22] [31:25]=7'h00; //opcode
    insMem[22] [24:20]=5'd3; //dst
    insMem[22] [19:15]=5'd1; //src1
    insMem[22] [14:10]=5'd2; //src2
    insMem[22] [9:0]=10'd0; //offsetLo
end

//PC count and register

wire [4:0]newPC;
assign newPC = jump ? (jumpPC): trapPC ? newPC :(PC+1);

always @(posedge clk) begin
    if (enable==1'b1) begin
        PC<=newPC;
        insReg<=insRegwire;
    end
end 

assign insRegwire = insMem [PC]; //instruction mem Mux controled by PC

endmodule

