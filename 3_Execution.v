module Execution(clk,opcode,dst,src1,src2,
offsetlo,result);
    input wire clk;
    input wire [5:0] opcode;
    input wire [4:0] dst;
    input wire [31:0] src1;
    input wire [31:0] src2;
    input wire [9:0] offsetlo;
    output reg [31:0] result;
    
    reg [31:0]reg0;
    reg [31:0]reg1;
    reg [31:0]reg2;
    reg [31:0]reg3;
    reg [2:0]count;
    wire doneMult; //signal for multiplication finish
    assign doneMult = count [2];
    
    always @(posedge clk)begin
        case(opcode)
            6'h00: result=src1+src2;
            6'h01: result=src1-src2;
            //need to implement pipeline stop for mult
            6'h02: begin //mult in 5 clk cycles
                reg0<=src1*src2;
                reg1<=reg0;
                reg2<=reg1;
                reg3<=reg2;
                result<=reg3;
                
                //count from 0 to 4 for the delay
                if (count==3'd4) begin
                    count=3'b0;
                end else begin
                    count=count+1;
                end
            end
        default: result<=32'hFFFFFFFF;   
        endcase
    end
endmodule
