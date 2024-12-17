module Fetch(

input wire [4:0]jumpPC,
input wire clk,
output reg [31:0] insReg, //final reg of the fetch stage
input wire jump, //jump=1 means override the PC
input wire trapPC,
input wire enable,

//Cache inputs from mem
input wire WiCache,
input wire [127:0]WiCacheline,
input wire [8:0]WiCachetag,

output wire CacheMiss,
output wire [5:0]CacheMiss_tag

);

reg [31:0] insMem [31:0];
reg [4:0] PC;
integer i;

initial begin //initial block, only for simulation
    PC = 4'd0;
    for (i=0; i < 32; i=i+1) begin
        insMem[i]=32'd0;
    end
    //instr 0 ADD r1,r2->r3 R-TYPE
    insMem[0] [31:25]=7'h00; //opcode
    insMem[0] [24:20]=5'd3; //dst
    insMem[0] [19:15]=5'd1; //src1
    insMem[0] [14:10]=5'd2; //src2
    insMem[0] [9:0]=10'd0; //constant
    
    //instr 12  M-TYPE
    insMem[12] [31:25]=7'h00; //opcode
    insMem[12] [24:20]=5'd3; //dst
    insMem[12] [19:15]=5'd1; //src1
    insMem[12] [14:0]=5'd2; //offset
    
    //instr 22  B-TYPE
    insMem[22] [31:25]=7'h00; //opcode
    insMem[22] [24:20]=5'd3; //dst
    insMem[22] [19:15]=5'd1; //src1
    insMem[22] [14:10]=5'd2; //src2
    insMem[22] [9:0]=10'd0; //offsetLo
end

//Cache block definition:
//4 lines 128b each (32b instrmem blocks x4)
//Set associative: PC is 5b -> tag[4:2] + offset[1:0]. Need instr from OS write cache line
//LRU replacement (least recently used): 3b counter, adds +1 each clk and resets to 0 when accessed the line
//Final cache line tag-> [8]valid [7:5]counter [4:2]tag [1:0]offset = 9b

reg [127:0] iCache [3:0];
reg [8:0] iCtag [3:0];
wire [31:0] CacheOut [3:0];
wire [31:0] InstrOut;
wire [1:0] CacheAccess;  //will store the line number of just accessed Cache line (in this spexific clk cycle)

//Muxing each cache line with the offset.
assign CacheOut[0] = (PC[1:0]==2'd0) ? iCache[0] [31:0]: 
                     (PC[1:0]==2'd1) ? iCache[0] [63:32]:
                     (PC[1:0]==2'd2) ? iCache[0] [95:64]: 
                     (PC[1:0]==2'd3) ? iCache[0] [127:96]:
                      32'hFFFFFFFF;
assign CacheOut[1] = (PC[1:0]==2'd0) ? iCache[1] [31:0]: 
                     (PC[1:0]==2'd1) ? iCache[1] [63:32]:
                     (PC[1:0]==2'd2) ? iCache[1] [95:64]: 
                     (PC[1:0]==2'd3) ? iCache[1] [127:96]:
                      32'hFFFFFFFF;                      
assign CacheOut[2] = (PC[1:0]==2'd0) ? iCache[2] [31:0]: 
                     (PC[1:0]==2'd1) ? iCache[2] [63:32]:
                     (PC[1:0]==2'd2) ? iCache[2] [95:64]: 
                     (PC[1:0]==2'd3) ? iCache[2] [127:96]:
                      32'hFFFFFFFF;                      
assign CacheOut[3] = (PC[1:0]==2'd0) ? iCache[3] [31:0]: 
                     (PC[1:0]==2'd1) ? iCache[3] [63:32]:
                     (PC[1:0]==2'd2) ? iCache[3] [95:64]: 
                     (PC[1:0]==2'd3) ? iCache[3] [127:96]:
                      32'hFFFFFFFF;

//Now check for the tag and valid bit
assign InstrOut = (PC[4:2]==iCtag[0][4:2] && iCtag[0][0]==1'b1) ? CacheOut[0]:
                  (PC[4:2]==iCtag[1][4:2] && iCtag[1][0]==1'b1) ? CacheOut[1]:
                  (PC[4:2]==iCtag[2][4:2] && iCtag[2][0]==1'b1) ? CacheOut[2]:
                  (PC[4:2]==iCtag[3][4:2] && iCtag[3][0]==1'b1) ? CacheOut[3]:
                  32'hFFFFFFFF;
//determine Cache miss
assign CacheMiss = (PC[4:2]==iCtag[0][4:2] && iCtag[0][0]==1'b1) ? 1'b0:
                   (PC[4:2]==iCtag[1][4:2] && iCtag[1][0]==1'b1) ? 1'b0:
                   (PC[4:2]==iCtag[2][4:2] && iCtag[2][0]==1'b1) ? 1'b0:
                   (PC[4:2]==iCtag[3][4:2] && iCtag[3][0]==1'b1) ? 1'b0:
                   1'b1;
//in case of miss put the tag out
assign CacheMiss_tag = (CacheMiss==1'b1) ? PC : 5'd0;
//determine Cache access
assign CacheAccess = (PC[4:2]==iCtag[0][4:2] && iCtag[0][0]==1'b1) ? 2'd0:
                     (PC[4:2]==iCtag[1][4:2] && iCtag[1][0]==1'b1) ? 2'd1:
                     (PC[4:2]==iCtag[2][4:2] && iCtag[2][0]==1'b1) ? 2'd2:
                     (PC[4:2]==iCtag[3][4:2] && iCtag[3][0]==1'b1) ? 2'd3:
                     2'd0;
                     
wire [1:0]LRU ; //stores the value number of the lest accessed line
//hard to read but it's combinational
assign LRU = (iCtag[0][7:5] > iCtag[1][7:5]) ? 
                 ((iCtag[0][7:5] > iCtag[2][7:5]) ? 
                     ((iCtag[0][7:5] > iCtag[3][7:5]) ? 2'd0 : 2'd3) : 
                     ((iCtag[2][7:5] > iCtag[3][7:5]) ? 2'd2 : 2'd3)) : 
                 ((iCtag[1][7:5] > iCtag[2][7:5]) ? 
                     ((iCtag[1][7:5] > iCtag[3][7:5]) ? 2'd1 : 2'd3) : 
                     ((iCtag[2][7:5] > iCtag[3][7:5]) ? 2'd2 : 2'd3));
                     
//Cache access counter for each tag, did one always for each of the 4 lines/counters
//write Cache from mem
always @(posedge clk)begin
    if(WiCache==1'b1)begin
        iCache[LRU]<=WiCacheline;
        iCtag[LRU]<=WiCachetag;
    end else begin
        if (CacheAccess==2'd0) iCtag[0][7:5]<=3'd0;
        else if (iCtag[0][7:5]!=3'b111) iCtag[0][7:5]<=iCtag[0][7:5]+1;
        if (CacheAccess==2'd1) iCtag[1][7:5]<=3'd0;
        else if (iCtag[1][7:5]!=3'b111) iCtag[1][7:5]<=iCtag[1][7:5]+1;
        if (CacheAccess==2'd2) iCtag[2][7:5]<=3'd0;
        else if (iCtag[2][7:5]!=3'b111) iCtag[2][7:5]<=iCtag[2][7:5]+1;
        if (CacheAccess==2'd3) iCtag[3][7:5]<=3'd0;
        else if (iCtag[3][7:5]!=3'b111) iCtag[3][7:5]<=iCtag[3][7:5]+1;
    end
end

//PC count and register
wire [4:0]newPC;
assign newPC = jump ? (jumpPC): trapPC ? PC :(PC+1);
always @(posedge clk) begin
    if (enable==1'b1) begin
        PC<=newPC;
        insReg<=InstrOut;
    end
end 
endmodule

