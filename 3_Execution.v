module Execution(

    input wire clk,
    input wire [6:0] opcode,
    output reg [6:0] memOp, //Instruction for the Cache: x10-LDB  x11-LDW  x12-STB x13-STW  x3F-do nothing
    
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
    input wire [4:0] bp_reg_mem,
    
    output wire [4:0]jumpPC, //needs to be wire so logic is faster and in 1 less clock
    output wire jump,        //TO DO, this signal should kill also and reset pipeline for fetch and decode
    
    input wire enable, //
    output wire Nop21    //this reg will go to other enable signals of the pipeline to efectuate the Nop
                        //goes down the pipeline, doesnt affect itself, could be computed with multing to effect itself and be more efficient

    );
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
    
    reg Nop21_reg;
    reg doneMult; //signal for multiplication finish
    reg multing;
    //if doneMult Nop=0, if opcode=mult Nop=1, else Nop=Nopreg
    assign Nop21 = (doneMult==1'b1) ? 1'b0 : (opcode == 6'h02) ? 1'b1: Nop21_reg;
    
    reg [31:0]reg0;
    reg [31:0]reg1;
    reg [31:0]reg2;
    reg [31:0]reg3;
    reg [2:0]count;
    
    wire [14:0]bigOffset;
    wire [14:0]BEQoffset;
    wire [19:0]JUMPoffset;
    assign bigOffset = {src2_reg,offsetlo};    
    assign BEQoffset = {dstin,offsetlo};
    assign JUMPoffset = {dstin,src2_reg,offsetlo};
    
    initial begin
        doneMult=1'b0;
        multing=1'b0;
        count=3'd0;
        Nop21_reg=1'b0;
        result=32'd0;
        memOp=7'h3F;
    end
    
    assign jump = (opcode==7'h31) ? (1'b1) : 
                  (opcode==7'h30 && src1w==src2w) ? (1'b1): 
                  1'b0;

    assign jumpPC = (opcode==7'h31) ? (src1w[4:0]+JUMPoffset[4:0]) : 
                    (opcode==7'h30 && src1w==src2w) ? (src1w[4:0]+BEQoffset[4:0]) :
                    5'd0;
    
    
    always @(posedge clk)begin
        if(enable==1'b1) begin
            case(opcode)
                7'h00: begin //ADD
                    result<=src1w+src2w;
                    memOp<=7'h13;
                end 
                7'h01: begin //Subtract
                    result=src1w-src2w;
                    memOp<=7'h13;
                end 
                7'h02: begin //Mult in 5 clk cycles
                    if (multing==1'b0) begin
                        reg0<=src1w*src2w;
                        memOp<=7'h3F;
                        multing<=1'b1;
                        Nop21_reg<=1'b1;
                        count<=3'd0;
                    end else if (count==3'd4)begin
                        memOp<=7'h13;
                        doneMult<=1'b1;
                        multing<=1'b0;
                        Nop21_reg<=1'b0;
                        count<=3'd0;
                    end else begin
                        count<=count+1;
                        memOp<=7'h3F;
                        reg1<=reg0;
                        reg2<=reg1;
                        reg3<=reg2;
                        result<=reg3;
                    end
                end
                7'h10: begin //LDB base register + offset
                    result<=src1w;
                    memOp<=7'h10;
                    dstout<=dstin + bigOffset[4:0]; //offset has too many bits for just 32 regs?!
                end
                7'h11: begin //LDW base register + offset
                    result<=src1w;
                    memOp<=7'h11;
                    dstout<=dstin + bigOffset[4:0]; //offset has too many bits for just 32 regs?!
                end
                7'h12: begin //STB base register + offset
                    result<=src1w;
                    memOp<=7'h12;
                    dstout<=dstin + bigOffset[4:0]; //offset has too many bits for just 32 regs?!
                end
                7'h13: begin //STW base register + offset
                    result<=src1w;
                    memOp<=7'h13;
                    dstout<=dstin + bigOffset[4:0]; //offset has too many bits for just 32 regs?!
                end
                7'h30: memOp<=7'h3F;  //BEQ Both jump and BEQ implemented logically
                7'h31: memOp<=7'h3F;  //JUMP
                default: result<=32'hFFFFFFFF;
            endcase
        end         
    end
endmodule
