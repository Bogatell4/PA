
module Fetch(jumpPC,clk);

input wire [4:0]jumpPC;
input wire clk;

reg [31:0] insMem [31:0];
reg [4:0] PC;

wire jump; //jump=1 means override the PC
wire [4:0] newPC;
assign newPC = jump? (jump):(PC+1);

always @(posedge clk) begin
    PC=newPC;
end
    
endmodule