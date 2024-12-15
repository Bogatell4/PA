module Execution(

    input wire clk,
    input wire [6:0] opcode,
    input wire [4:0] dstin,
    input wire [31:0] src1,
    input wire [4:0] src1_reg,
    input wire [4:0] src2_reg,
    input wire [31:0] src2,
    input wire [9:0] offsetlo,
    output reg [31:0] result,
    output reg [4:0] dstout,
    
    input wire [31:0] bp_data,
    input wire [31:0] bp_data_mem,
    input wire [4:0] bp_reg,
    input wire [4:0] bp_reg_mem

    );
    
    reg [31:0]reg0;
    reg [31:0]reg1;
    reg [31:0]reg2;
    reg [31:0]reg3;
    reg [2:0]count;
    
    //bypass muxes
    wire [31:0] src1w;
    wire [31:0] src2w;
    //order of the ternary operator puts higher priority to exec bypass (newer compared to mem)
    assign src1w = (src1_reg == bp_reg) ? bp_data:
                   (src1_reg == bp_reg_mem) ? bp_data_mem:
                   src1;
                   
    assign src2w = (src2_reg == bp_reg) ? bp_data:
                   (src2_reg == bp_reg_mem) ? bp_data_mem:
                   src2;
    
    wire doneMult; //signal for multiplication finish
    assign doneMult = count [2];
    
    always @(posedge clk)begin
        case(opcode)
            6'h00: result=src1w+src2w;
            6'h01: result=src1w-src2w;
            //need to implement pipeline stop for mult
            6'h02: begin //mult in 5 clk cycles
                reg0<=src1w*src2w;
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
            6'h3F: ;
        default: result<=32'hFFFFFFFF;   
        endcase
    end
endmodule
