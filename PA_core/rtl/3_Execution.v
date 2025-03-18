module Execution(

    input wire clk,
    input wire [6:0] opcode,
    input wire [4:0] dstin,
    input wire [31:0] src1,
    //input wire [4:0] src1_reg,
    //input wire [4:0] src2_reg,
    input wire [31:0] src2,
    input wire [9:0] offsetlo,
    output reg [31:0] result,
    output reg [4:0] dstout,
    
    output reg [6:0] memOp,
    output reg [9:0]MemAddr, //variable that points to the memory address which has 2^20 instances of 32bits each
    
    /*input wire [31:0] bp_data,    //bypass inputs
    input wire [31:0] bp_data_mem,
    input wire [4:0] bp_reg,
    input wire [4:0] bp_reg_mem,*/
    
    input wire enable, //
    output wire Nop21    //this reg will go to other enable signals of the pipeline to efectuate the Nop
                        //goes down the pipeline, doesnt affect itself, could be computed with multing to effect itself and be more efficient

    );
    //bypass muxes and logic
    //wire [31:0] src1w;
    //wire [31:0] src2w;
    //order of the ternary operator puts higher priority to exec bypass (newer compared to mem)
    /*assign src1w = (src1_reg == bp_reg) ? bp_data:
                   (src1_reg == bp_reg_mem) ? bp_data_mem:
                   src1;
                   
    assign src2w = (src2_reg == bp_reg) ? bp_data:
                   (src2_reg == bp_reg_mem) ? bp_data_mem:
                   src2;*/
    
    reg Nop21_reg;
    reg doneMult; //signal for multiplication finish
    reg multing;
    //if doneMult Nop=0, if opcode=mult Nop=1, else Nop=Nopreg
    assign Nop21 = (doneMult==1'b1) ? 1'b0 : (opcode == 7'h02) ? 1'b1: Nop21_reg;
    
    reg [31:0]reg0;
    reg [31:0]reg1;
    reg [31:0]reg2;
    reg [31:0]reg3;
    reg [2:0]count;
    
    initial begin
        doneMult=1'b0;
        multing=1'b0;
        count=3'd0;
        Nop21_reg=1'b0;
        result=32'd0;
    end
    

   // wire [14:0]BEQoffset;
   // wire [19:0]JUMPoffset;   
   // assign BEQoffset = {dstin,offsetlo};
   // assign JUMPoffset = {dstin,src2,offsetlo};
    
    //TO DO: add new custom opcode for the kyber block
    always @(posedge clk)begin
        if(enable==1'b1) begin
            case(opcode)
                7'h00: result=src1+src2;
                7'h01: result=src1-src2;
                //need to implement pipeline stop for mult
                7'h02: begin //mult in 5 clk cycles, specification by the teacher
                    if (multing==1'b0) begin
                        reg0<=src1*src2;
                        multing<=1'b1;
                        Nop21_reg<=1'b1;
                        count<=3'd0;
                    end else if (count==3'd4)begin
                        doneMult<=1'b1;
                        multing<=1'b0;
                        Nop21_reg<=1'b0;
                        count<=3'd0;
                    end else begin
                        count<=count+1;
                        reg1<=reg0;
                        reg2<=reg1;
                        reg3<=reg2;
                        result<=reg3;
                    end
                end
                
                
                7'h10: begin //LDB base register + offset
                    result<=src1;
                    MemAddr<=offsetlo+dstin;
                    memOp<=7'h10;
                end
                7'h11: begin //LDW base register + offset
                    result<=src1;
                    MemAddr<=offsetlo+dstin;
                    memOp<=7'h11;
                end
                7'h12: begin //STB base register + offset
                    result<=src1;
                    MemAddr<=offsetlo+dstin;
                    memOp<=7'h12;
                end
                7'h13: begin //STW base register + offset
                    result<=src1;
                    MemAddr<=offsetlo+dstin;
                    memOp<=7'h13;
                end
                7'h3F: ;
                default: result<=32'hFFFFFFFF;
            endcase
        end         
    end
endmodule
