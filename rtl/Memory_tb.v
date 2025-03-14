module Memory_tb();
    reg clk;
    reg enable;
    reg [9:0] MemAddr;
    reg [4:0] dst;
    reg [31:0] data_in;
    reg [6:0] memOP;
    
    wire WB;
    wire [4:0] dstout;
    wire [31:0] data_out;
    
    always #5 clk = ~clk;   
    
    initial begin
        clk=1'b0;
        enable =1'b1;
        MemAddr=10'd0;
        data_in=32'd0;
        memOP=7'd0;        
    end
    
    Memory Memory_1(
        .clk(clk),
        .enable(enable),
        .MemAddr(MemAddr),
        .dst(dst),
        .data_in(data_in),
        .memOP(memOP),
        .WB(WB),
        .dstout(dstout),
        .data_out(data_out)       
    
    
    );
    
endmodule
