module Memory(
    
    input wire clk,
    
    input wire [6:0] memOP, //Instruction for the Cache: x10-LDB  x11-LDW  x12-STB x13-STW  x3F-do nothing
    
    input wire [31:0] data,
    input wire [4:0] dst,
    
    output reg [31:0] regData,
    output reg [4:0] regdst,
    output reg writereg,
    
    
    //Cache inputs from mem
    input wire WDCache,
    input wire [127:0]WDCacheline,
    input wire [8:0]WDCachetag,

    
    output wire DCacheMiss,
    output wire [4:0] DCacheMiss_tag,
    output wire Nop31 //This Nop needs to be sended back to stages from 3 to 1
    );
    
reg [127:0] DCache [3:0];
reg [8:0] DCtag [3:0];
wire [31:0] CacheOut [3:0];
wire [31:0] CacheDataOut;
wire [1:0] CacheAccess;  //will store the line number of just accessed Cache line (in this spexific clk cycle)

//Muxing each cache line with the offset.
assign CacheOut[0] = (dst[1:0]==2'd0) ? DCache[0] [31:0]: 
                     (dst[1:0]==2'd1) ? DCache[0] [63:32]:
                     (dst[1:0]==2'd2) ? DCache[0] [95:64]: 
                     (dst[1:0]==2'd3) ? DCache[0] [127:96]:
                      32'hFFFFFFFF;
assign CacheOut[1] = (dst[1:0]==2'd0) ? DCache[1] [31:0]: 
                     (dst[1:0]==2'd1) ? DCache[1] [63:32]:
                     (dst[1:0]==2'd2) ? DCache[1] [95:64]: 
                     (dst[1:0]==2'd3) ? DCache[1] [127:96]:
                      32'hFFFFFFFF;                      
assign CacheOut[2] = (dst[1:0]==2'd0) ? DCache[2] [31:0]: 
                     (dst[1:0]==2'd1) ? DCache[2] [63:32]:
                     (dst[1:0]==2'd2) ? DCache[2] [95:64]: 
                     (dst[1:0]==2'd3) ? DCache[2] [127:96]:
                      32'hFFFFFFFF;                      
assign CacheOut[3] = (dst[1:0]==2'd0) ? DCache[3] [31:0]: 
                     (dst[1:0]==2'd1) ? DCache[3] [63:32]:
                     (dst[1:0]==2'd2) ? DCache[3] [95:64]: 
                     (dst[1:0]==2'd3) ? DCache[3] [127:96]:
                      32'hFFFFFFFF;

//Now check for the tag and valid bit
assign CacheDataOut = (dst[4:2]==DCtag[0][4:2] && DCtag[0][0]==1'b1) ? CacheOut[0]:
                  (dst[4:2]==DCtag[1][4:2] && DCtag[1][0]==1'b1) ? CacheOut[1]:
                  (dst[4:2]==DCtag[2][4:2] && DCtag[2][0]==1'b1) ? CacheOut[2]:
                  (dst[4:2]==DCtag[3][4:2] && DCtag[3][0]==1'b1) ? CacheOut[3]:
                  32'hFFFFFFFF;
//determine Cache miss
assign DCacheMiss = (dst[4:2]==DCtag[0][4:2] && DCtag[0][0]==1'b1) ? 1'b0:
                   (dst[4:2]==DCtag[1][4:2] && DCtag[1][0]==1'b1) ? 1'b0:
                   (dst[4:2]==DCtag[2][4:2] && DCtag[2][0]==1'b1) ? 1'b0:
                   (dst[4:2]==DCtag[3][4:2] && DCtag[3][0]==1'b1) ? 1'b0:
                   1'b1;
//in case of miss put the tag out
assign DCacheMiss_tag = (DCacheMiss==1'b1) ? dst : 5'd0;
//determine Cache access
assign CacheAccess = (dst[4:2]==DCtag[0][4:2] && DCtag[0][0]==1'b1) ? 2'd0:
                     (dst[4:2]==DCtag[1][4:2] && DCtag[1][0]==1'b1) ? 2'd1:
                     (dst[4:2]==DCtag[2][4:2] && DCtag[2][0]==1'b1) ? 2'd2:
                     (dst[4:2]==DCtag[3][4:2] && DCtag[3][0]==1'b1) ? 2'd3:
                     2'd0;
                     
wire [1:0]LRU ; //stores the value number of the lest accessed line
//hard to read but it's combinational
assign LRU = (DCtag[0][7:5] > DCtag[1][7:5]) ? 
                 ((DCtag[0][7:5] > DCtag[2][7:5]) ? 
                     ((DCtag[0][7:5] > DCtag[3][7:5]) ? 2'd0 : 2'd3) : 
                     ((DCtag[2][7:5] > DCtag[3][7:5]) ? 2'd2 : 2'd3)) : 
                 ((DCtag[1][7:5] > DCtag[2][7:5]) ? 
                     ((DCtag[1][7:5] > DCtag[3][7:5]) ? 2'd1 : 2'd3) : 
                     ((DCtag[2][7:5] > DCtag[3][7:5]) ? 2'd2 : 2'd3));
                     
//Cache access counter for each tag, did one always for each of the 4 lines/counters
//write Cache from mem
always @(posedge clk)begin
    
end    
    
always @(posedge clk)begin
    if(WDCache==1'b1)begin
        DCache[LRU]<=WDCacheline;
        DCtag[LRU]<=WDCachetag;
    end else begin
        case(memOP)//Instruction for the Cache: x10-LDB  x11-LDW  x12-STB x13-STW  x3F-do nothing
            7'h10: begin
                if(DCacheMiss==1'b0)begin
                    regdst<=dst;
                    regData<=CacheDataOut;
                    writereg<=1'b1;
                    //Update tags for LRU
                    if (CacheAccess==2'd0) DCtag[0][7:5]<=3'd0;
                    else if (DCtag[0][7:5]!=3'b111) DCtag[0][7:5]<=DCtag[0][7:5]+1;
                    if (CacheAccess==2'd1) DCtag[1][7:5]<=3'd0;
                    else if (DCtag[1][7:5]!=3'b111) DCtag[1][7:5]<=DCtag[1][7:5]+1;
                    if (CacheAccess==2'd2) DCtag[2][7:5]<=3'd0;
                    else if (DCtag[2][7:5]!=3'b111) DCtag[2][7:5]<=DCtag[2][7:5]+1;
                    if (CacheAccess==2'd3) DCtag[3][7:5]<=3'd0;
                    else if (DCtag[3][7:5]!=3'b111) DCtag[3][7:5]<=DCtag[3][7:5]+1;
               end
            end
            7'h11: begin
                if(DCacheMiss==1'b0)begin
                    regdst<=dst;
                    regData<=CacheDataOut;
                    writereg<=1'b1;
                    //Update tags for LRU
                    if (CacheAccess==2'd0) DCtag[0][7:5]<=3'd0;
                    else if (DCtag[0][7:5]!=3'b111) DCtag[0][7:5]<=DCtag[0][7:5]+1;
                    if (CacheAccess==2'd1) DCtag[1][7:5]<=3'd0;
                    else if (DCtag[1][7:5]!=3'b111) DCtag[1][7:5]<=DCtag[1][7:5]+1;
                    if (CacheAccess==2'd2) DCtag[2][7:5]<=3'd0;
                    else if (DCtag[2][7:5]!=3'b111) DCtag[2][7:5]<=DCtag[2][7:5]+1;
                    if (CacheAccess==2'd3) DCtag[3][7:5]<=3'd0;
                    else if (DCtag[3][7:5]!=3'b111) DCtag[3][7:5]<=DCtag[3][7:5]+1;
                end
            end
            7'h12: begin
                writereg<=1'b1;
                regdst<=dst;
                regData<=data;
            end
            7'h13: begin
                writereg<=1'b1;
                regdst<=dst;
                regData<=data;
                if(DCacheMiss==1'b1)begin
                    DCache[LRU]<=WDCacheline;
                    DCtag[LRU]<=WDCachetag;
                end else begin
                    
                end
            end
            7'h3F: writereg<=1'b0;
            default: writereg<=1'b0;
        endcase
    end
end
    
    
reg Nop31_reg;    
assign Nop31 = (DCacheMiss==1'b1) ? 1'b1: Nop31_reg;

endmodule
