
module Memory(
    input wire enable,
    input wire clk,
    input wire [4:0] dst,
    input wire [31:0] data_in,
    input wire [6:0] memOP,
    output reg [31:0] data_out
    );
    
    
    reg []memory[31:0]; //How much memory do we want?!!!
    always @(posedge clk)begin
        if(enable==1'b1) begin
            case(memOP)
            endcase
        end
    end
    
endmodule
