
module Memory(
    input wire enable,
    input wire clk,
    input wire [9:0 ]MemAddr,
    input wire [4:0] dst,
    input wire [31:0] data_in,
    input wire [6:0] memOP,
    output reg WB,
    output reg [4:0] dstout,
    output reg [31:0] data_out
    );
    
    reg [255:0]memory[31:0]; //MemAddr is 10 bit, low 2 bits will if there is a load byte. This leaves 2^8 mem addresses
    wire [7:0] highAddr;
    wire [1:0] lowAddr;
    assign highAddr = MemAddr[9:2];
    assign lowAddr = MemAddr[1:0];
    
   //TO DO: finish concat logic for  datatrans in STB and LDB
    //wire [31:0] data_trans;
    //assign data_trans = data_in ? (lowAddr==2'd0):
                        
    
    
    always @(posedge clk)begin
        if(enable==1'b1) begin
            case(memOP)
                7'h10: begin //LDB
                end
                7'h11: begin //LDW
                    data_out<=memory[highAddr];
                    dstout<= dst;
                    WB<=1'd1;
                end
                7'h12: begin //STB
                end
                7'h13: begin //STW
                    memory[highAddr]<=data_in;
                    data_out<=32'd0;
                    dstout<= 5'd0;
                    WB<=1'd0;
                end
            endcase
        end
    end
    
endmodule
