
//this moduleis meant to include all the stages of the pipeline connected together

module fullsystem();
    reg clk;
    always #5 clk = ~clk;
        initial begin
     clk=1'b0;     
    end   
    
    
    
endmodule

/*module TopModule (
    input wire clk,
    input wire enable,
    input wire jump,
    input wire trapPC,
    input wire [4:0] jumpPC,
    input wire [31:0] WB_data,
    input wire [4:0] WB_add,
    input wire WB_in
);

    // Intermediate signals between stages
    wire [31:0] fetched_instruction;
    wire [6:0] decoded_opcode;
    wire [4:0] decoded_dst;
    wire [31:0] decoded_src1;
    wire [4:0] decoded_src1_reg;
    wire [4:0] decoded_src2_reg;
    wire [31:0] decoded_src2;
    wire [9:0] decoded_offsetlo;

    wire [31:0] execution_result;
    wire [4:0] execution_dstout;
    wire [6:0] execution_memOp;
    wire [9:0] execution_MemAddr;
    wire execution_Nop21;

    wire memory_WB;
    wire [4:0] memory_dstout;
    wire [31:0] memory_data_out;

    // Fetch Stage
    Fetch fetch_inst (
        .jumpPC(jumpPC),
        .clk(clk),
        .insReg(fetched_instruction),
        .jump(jump),
        .trapPC(trapPC),
        .enable(enable)
    );

    // Decode Stage
    Decode decode_inst (
        .clk(clk),
        .WB(WB_in),
        .WB_add(WB_add),
        .datain(WB_data),
        .instruction(fetched_instruction),
        .opcode(decoded_opcode),
        .dst(decoded_dst),
        .src1(decoded_src1),
        .src1_reg(decoded_src1_reg),
        .src2_reg(decoded_src2_reg),
        .src2(decoded_src2),
        .offsetlo(decoded_offsetlo),
        .enable(enable)
    );

    // Execution Stage
    Execution execution_inst (
        .clk(clk),
        .opcode(decoded_opcode),
        .dstin(decoded_dst),
        .src1(decoded_src1),
        .src2(decoded_src2),
        .offsetlo(decoded_offsetlo),
        .result(execution_result),
        .dstout(execution_dstout),
        .memOp(execution_memOp),
        .MemAddr(execution_MemAddr),
        .enable(enable),
        .Nop21(execution_Nop21)
    );

    // Memory Stage
    Memory memory_inst (
        .enable(enable),
        .clk(clk),
        .MemAddr(execution_MemAddr),
        .dst(execution_dstout),
        .data_in(execution_result),
        .memOP(execution_memOp),
        .WB(memory_WB),
        .dstout(memory_dstout),
        .data_out(memory_data_out)
    );

endmodule
*/