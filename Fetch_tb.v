module Fetch_tb( );
    reg clk;
    reg jump,trapPC,enable,ICacheMiss,WiCache;
    reg [127:0]WiCacheline;
    reg [8:0] WiCachetag;
    reg [4:0]ICacheMiss_tag,jumpPC;
    wire [31:0] insReg;
    
    initial begin
     clk=1'b0;
     jump=1'b0;
     jumpPC=5'd0;
     trapPC=1'b0;
     WiCache=1'b0;
     enable=1'b1;
    end

    always #5 clk = ~clk;
    
    Fetch my_Fetch(.jumpPC(jumpPC), .clk(clk), .jump(jump), .trapPC(trapPC), .enable(enable),
    .insReg(insReg),
    .WiCache(WiCache), .WiCacheline(WiCacheline), .WiCachetag(WiCachetag),
    .ICacheMiss(ICacheMiss), .ICacheMiss_tag(ICacheMiss_tag));

endmodule
