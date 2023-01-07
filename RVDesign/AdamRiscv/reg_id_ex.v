module reg_id_ex(
    input  wire clk,
    input  wire rst,
    input  wire[31:0] id_pc,
    input  wire[31:0] id_regs_data1,
    input  wire[31:0] id_regs_data2,
    input  wire[31:0] id_imm,
    input  wire[2:0]  id_func3_code, 
    input  wire       id_func7_code,
    input  wire[4:0]  id_rd,
    input  wire       id_br,
    input  wire       id_mem_read,
    input  wire       id_mem2reg,
    //input  wire[2:0]  id_alu_op,
    input  wire[31:0]  id_op_ctl,
    input  wire       id_mem_write,
    input  wire[1:0]  id_src1_sel,
    input  wire[1:0]  id_src2_sel,
    input  wire       id_br_addr_mode,
    input  wire       id_regs_write,

    input  wire       id_ex_flush,

    //forwarding
    input wire[4:0] id_rs1,
    input wire[4:0] id_rs2,
    output reg[4:0] ex_rs1,
    output reg[4:0] ex_rs2,

    output reg[31:0]  ex_pc,
    output reg[31:0]  ex_regs_data1,
    output reg[31:0]  ex_regs_data2,
    output reg[31:0]  ex_imm,
    output reg[2:0]   ex_func3_code, 
    output reg        ex_func7_code,
    output reg[4:0]   ex_rd,
    output reg        ex_br,
    output reg        ex_mem_read,
    output reg        ex_mem2reg,
    //output reg[2:0]   ex_alu_op,
    output reg[31:0]   ex_op_ctl,
    output reg        ex_mem_write,
    output reg[1:0]   ex_src1_sel,
    output reg[1:0]   ex_src2_sel,
    output reg        ex_br_addr_mode,
    output reg        ex_regs_write
);
always @(posedge clk) begin
    if (!rst || id_ex_flush)begin
        ex_pc           <= 0;
        ex_regs_data1   <= 0;
        ex_regs_data2   <= 0;
        ex_imm          <= 0;
        ex_func3_code   <= 0;
        ex_func7_code   <= 0;
        ex_rd           <= 0;
        ex_br           <= 0;
        ex_mem_read     <= 0;
        ex_mem2reg      <= 0;
        ex_op_ctl       <= 0;
        ex_mem_write    <= 0;
        ex_src1_sel     <= 0;
        ex_src2_sel     <= 0;
        ex_br_addr_mode <= 0;
        ex_regs_write   <= 0;

        ex_rs1          <= 0;
        ex_rs2          <= 0;
    end 
    else begin
        ex_pc           <= id_pc;
        ex_regs_data1   <= id_regs_data1;
        ex_regs_data2   <= id_regs_data2;
        ex_imm          <= id_imm;
        ex_func3_code   <= id_func3_code;
        ex_func7_code   <= id_func7_code;
        ex_rd           <= id_rd;
        ex_br           <= id_br;
        ex_mem_read     <= id_mem_read;
        ex_mem2reg      <= id_mem2reg;
        ex_op_ctl       <= id_op_ctl;
        ex_mem_write    <= id_mem_write;
        ex_src1_sel     <= id_src1_sel;
        ex_src2_sel     <= id_src2_sel;
        ex_br_addr_mode <= id_br_addr_mode;
        ex_regs_write   <= id_regs_write;

        ex_rs1          <= id_rs1;
        ex_rs2          <= id_rs2;
    end
    $display("ex_regs_data1: %h",ex_regs_data1 );
    $display("ex_regs_data2: %h",ex_regs_data2 );
    $display("ex_imm: %h",ex_imm );
    $display("ex_op_ctl: %h",ex_op_ctl );
end
endmodule