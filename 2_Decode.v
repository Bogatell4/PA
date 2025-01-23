
module Decode(
    input wire clk,
    input wire [31:0] instruction,
    
    output reg [6:0] opcode,
    output reg [4:0] dst,
  
    output reg [31:0]src1,
    output reg [4:0] src1_reg,
    output reg [4:0] src2_reg,    
    output reg [31:0]src2,
    output reg [9:0]offsetlo,
    
    input wire WriteReg,
    input wire [4:0] WriteRegdst,
    input wire [31:0] WriteRegData,
    
    input wire enable
    );
       
    //instruction [31:25] opcode
    //instruction [24:20] dst
    // [19:15] src1 [14:10]src2

    reg [31:0] regData [31:0];
    
    //Update register data from WriteBack
    always @(posedge clk)begin
        if (WriteReg==1'b1)begin
            regData[WriteRegdst]<=WriteRegData;
        end
    end
    
    //initial block only used during simulations
    initial begin
    regData [0]=32'd10;
    regData [1]=32'd11;
    regData [2]=32'd12;
    regData [3]=32'd13;
    regData [4]=32'd14;
    regData [5]=32'd15;
    regData [6]=32'd16;
    regData [7]=32'd17;
    regData [8]=32'd18;
    regData [9]=32'd19;
    regData [10]=32'd20;
    regData [11]=32'd21;
    regData [12]=32'd22;
    regData [13]=32'd23;
    regData [14]=32'd24;
    regData [15]=32'd25;
    regData [16]=32'd26;
    regData [17]=32'd27;
    regData [18]=32'd28;
    regData [19]=32'd29;
    regData [20]=32'd30;
    regData [21]=32'd31;
    regData [22]=32'd32;
    regData [23]=32'd33;
    regData [24]=32'd34;
    regData [25]=32'd35;
    regData [26]=32'd36;
    regData [27]=32'd37;
    regData [28]=32'd38;
    regData [29]=32'd39;
    regData [30]=32'd40;
    regData [31]=32'd41;
    end
    

always @(posedge clk) begin
    if (enable==1'b1) begin
        opcode <= instruction[31:25];
        dst <= instruction [24:20];
        offsetlo <= instruction [9:0];
        src1_reg <=instruction[19:15];
        src2_reg <=instruction[14:10];
        src1 <= regData[instruction[19:15]];
        src2 <= regData[instruction[14:10]];
    end
    
end

endmodule
