module Fetch_tb( );
    reg clk;
    wire [31:0] insRegw;
    reg jump;
    reg [4:0] jumpPC;
    
    initial begin
     clk=1'b0;
     jump=1'b0;
     jumpPC=4'd0;
    end

    always #5 clk = ~clk;
    
    Fetch Fetch_1(clk,insRegw,jump,jumpPC);

endmodule
