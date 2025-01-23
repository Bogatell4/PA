module fullsystem();

reg clk;
wire jump,trapPC,enable,ICacheMiss,WiCache;
wire [127:0]WiCacheline;
wire [8:0] WiCachetag;
wire [4:0]ICacheMiss_tag,jumpPC;
wire [31:0] insReg;
//---------------------------------For decode down here
wire WriteReg;
wire [4:0] WriteRegdst,dst, src1_reg, src2_reg;
wire [31:0] WriteRegData, src1, src2;
wire [6:0] opcode;
wire [9:0] offsetlo;
//----------------------------------For Execution down here
wire [6:0] memOp;
wire [31:0] result;
wire [4:0] dstout;
wire Nop21;
//-------------------------For Memory (Cache)
wire [31:0] regData;
wire [4:0] regdst, DCacheMiss_tag;
wire writereg, WDCache, DCacheMiss, Nop31;
wire [127:0] WDCacheline;
wire [8:0] WDCachetag;

Fetch my_Fetch(.jumpPC(jumpPC), .clk(clk), .jump(jump), .trapPC(trapPC), .enable(enable),
.insReg(insReg),
.WiCache(WiCache), .WiCacheline(WiCacheline), .WiCachetag(WiCachetag),
.ICacheMiss(ICacheMiss), .ICacheMiss_tag(ICacheMiss_tag));

Decode my_Decode( .clk(clk), .instruction(insReg),
.WriteReg(WriteReg), .WriteRegdst(WriteRegdst), .WriteRegData(WriteRegData),
.opcode(opcode), .dst(dst), .src1(src1), .src1_reg(src1_reg), .src2_reg(src2_reg), .src2(src2), .offsetlo(offsetlo),
.enable());

Execution my_Execute( .clk(clk),
.opcode(opcode), .dstin(dst), .src1(src1), .src1_reg(src1_reg), .src2_reg(src2_reg), .src2(src2), .offsetlo(offsetlo),
.memOp(memOp), .result(result), .dstout(dstout),
.bp_data(result), .bp_reg(dstout), .bp_data_mem(regData), .bp_reg_mem(regdst),
.jumpPC(jumpPC), .jump(jump),
.enable(), .Nop21(Nop21));

Memory my_Memory( .clk(clk), .memOp(memOp), .data(result), .dst(dstout),
.regData(regData), .regdst(regdst), .writereg(writereg),
.WDCache(WDCache), .WDCacheline(WDCacheline), .WDCachetag(WDCachetag),
.DCacheMiss(DCacheMiss), .DCacheMiss_tag(DCacheMiss_tag), .Nop31(Nop31));

endmodule

