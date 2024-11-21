module Fetch(jumpPC,clk,insReg);

input wire [4:0]jumpPC;
input wire clk;
output reg [31:0] insReg; //final reg of the fetch stage

wire [31:0]insRegwire;
reg [31:0] insMem [31:0];
reg [4:0] PC;




//PC count and register
wire jump; //jump=1 means override the PC
wire [4:0] newPC;
assign newPC = jump? (jump):(PC+1);
always @(posedge clk) begin
    PC<=newPC;
    insReg<=insRegwire;
end 

assign insRegwire = insMem [PC]; //instruction mem Mux controled by PC

endmodule

