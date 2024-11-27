
module Decode(clk,instruction,opcode,dst,src1,src2,offsetlo);
    input wire clk;
    input wire [31:0] instruction;
    
    output reg [5:0] opcode;
    output reg [4:0] dst;
    
    output reg [31:0]src1;
    output reg [31:0]src2;
    output reg [9:0]offsetlo;
       
    //instruction [31:25] opcode
    //instruction [24:20] dst
    // [19:15] src1 [14:10]src2

    reg [31:0] regData [31:0];

always @(posedge clk) begin
    opcode <= instruction[31:25];
    dst <= instruction [24:20];
    offsetlo <= instruction [9:0];
    src1 <= regData[instruction[19:15]];
    src2 <= regData[instruction[14:10]];
    
end

endmodule
