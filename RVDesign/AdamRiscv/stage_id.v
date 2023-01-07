module stage_id(
    input wire         clk,
    input wire         rst,
    input wire[31:0]   id_inst,
    input wire         w_regs_en,
    input wire[4:0]    w_regs_addr,
    input wire[31:0]   w_regs_data,
    input wire         ctrl_stall,
    output  wire[31:0] id_regs_data1,
    output  wire[31:0] id_regs_data2,
    output  wire[31:0] id_imm,
    output  wire[2:0]  id_func3_code, 
    output  wire       id_func7_code,
    output  wire[4:0]  id_rd,
    output  wire       id_br,
    output  wire       id_mem_read,
    output  wire       id_mem2reg,
    //output  wire[2:0]  id_alu_op,
    output  wire[31:0]  id_op_ctl,
    output  wire       id_mem_write,
    output  wire[1:0]  id_src1_sel,
    output  wire[1:0]  id_src2_sel,
    output  wire       id_br_addr_mode,
    output  wire       id_regs_write,
    //forwarding
    output  wire[4:0]  id_rs1,
    output  wire[4:0]  id_rs2

);

wire        br          ;
wire        mem_read    ;
wire        mem2reg     ;
//wire[2:0]   alu_op      ;
wire [31:0]  op_ctl;
wire        mem_write   ;
//wire[1:0]   alu_src1    ;
//wire[1:0]   alu_src2    ;
wire [1:0]   src1_sel;
wire [1:0]   src2_sel;
wire        br_addr_mode;
wire        regs_write  ;


regs u_regs(
    .clk          (clk              ),
    .rst          (rst              ),
    .r_regs_addr1 (id_inst[19:15]   ),
    .r_regs_addr2 (id_inst[24:20]   ),
    .w_regs_addr  (w_regs_addr      ),
    .w_regs_data  (w_regs_data      ),
    .w_regs_en    (w_regs_en        ),
    .r_regs_o1    (id_regs_data1    ),
    .r_regs_o2    (id_regs_data2    )
);

//ctrl u_ctrl(
//    .inst_op        (id_inst[6:0] ),
//    .br             (br           ),
//    .mem_read       (mem_read     ),
//    .mem2reg        (mem2reg      ),
//    .alu_op         (alu_op       ),
//    .mem_write      (mem_write    ), 
//    .alu_src1       (alu_src1     ),
//    .alu_src2       (alu_src2     ),
//    .br_addr_mode   (br_addr_mode ),
//    .regs_write     (regs_write   )
//);
//
//imm_gen u_imm_gen(
//    .inst  (id_inst  ),
//    .imm_o (id_imm   )
//);

//inset assign logic by script
//begin br
assign br = (!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]
    &!id_inst[4]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[14]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (!id_inst[13]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[6]
    &id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]);

//end br

//begin mem_write
assign mem_write = (!id_inst[14]&!id_inst[12]&!id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (!id_inst[14]
    &!id_inst[13]&!id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]);

//end mem_write

//begin mem_read
assign mem_read = (!id_inst[14]&!id_inst[12]&!id_inst[6]&!id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (!id_inst[13]
    &!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

//end mem_read

//begin regs_write
assign regs_write = (!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &id_inst[1]&id_inst[0]) | (!id_inst[31]&!id_inst[29]&!id_inst[28]
    &!id_inst[27]&!id_inst[26]&!id_inst[25]&id_inst[14]&!id_inst[13]
    &id_inst[12]&!id_inst[6]&id_inst[4]&!id_inst[3]&id_inst[1]&id_inst[0]) | (
    !id_inst[31]&!id_inst[30]&!id_inst[29]&!id_inst[28]&!id_inst[27]
    &!id_inst[26]&!id_inst[25]&!id_inst[6]&id_inst[4]&!id_inst[3]
    &id_inst[1]&id_inst[0]) | (!id_inst[31]&!id_inst[29]&!id_inst[28]
    &!id_inst[27]&!id_inst[26]&!id_inst[25]&!id_inst[14]&!id_inst[13]
    &!id_inst[12]&!id_inst[6]&id_inst[4]&!id_inst[3]&id_inst[1]
    &id_inst[0]) | (!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]
    &id_inst[5]&!id_inst[4]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]
    &id_inst[0]) | (!id_inst[14]&!id_inst[12]&!id_inst[6]&!id_inst[5]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (!id_inst[13]
    &!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[13]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&id_inst[1]&id_inst[0]) | (!id_inst[6]
    &id_inst[4]&!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]);

//end regs_write

//begin br_addr_mode
assign br_addr_mode = (!id_inst[13]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[14]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]
    &id_inst[0]);

//end br_addr_mode

//begin src1_sel
assign src1_sel[1] = (!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]
    &id_inst[5]&!id_inst[4]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]
    &id_inst[2]&id_inst[1]&id_inst[0]);

assign src1_sel[0] = (!id_inst[6]&id_inst[5]&id_inst[4]&!id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]);

//end src1_sel

//begin src2_sel
assign src2_sel[1] = (!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]
    &id_inst[5]&!id_inst[4]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]
    &id_inst[0]);

assign src2_sel[0] = (!id_inst[31]&!id_inst[30]&!id_inst[29]&!id_inst[28]
    &!id_inst[27]&!id_inst[26]&!id_inst[25]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&id_inst[1]&id_inst[0]) | (!id_inst[31]
    &!id_inst[29]&!id_inst[28]&!id_inst[27]&!id_inst[26]&!id_inst[25]
    &id_inst[14]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &id_inst[1]&id_inst[0]) | (!id_inst[12]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&id_inst[1]&id_inst[0]) | (!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (!id_inst[14]&!id_inst[13]&!id_inst[6]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[13]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&id_inst[1]
    &id_inst[0]) | (!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (!id_inst[6]
    &id_inst[4]&!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]);

//end src2_sel

//begin id_imm
assign id_imm[31] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]&!id_inst[13]
    &!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[14]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[6]&id_inst[5]
    &!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[6]
    &id_inst[4]&!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]);

assign id_imm[30] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[14]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[30]&!id_inst[6]&id_inst[4]
    &!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[29] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[14]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[29]&!id_inst[6]&id_inst[4]
    &!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[28] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[14]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[28]&!id_inst[6]&id_inst[4]
    &!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[27] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[14]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[27]&!id_inst[6]&id_inst[4]
    &!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[26] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[14]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[26]&!id_inst[6]&id_inst[4]
    &!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[25] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[14]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[25]&!id_inst[6]&id_inst[4]
    &!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[24] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[14]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[24]&!id_inst[6]&id_inst[4]
    &!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[23] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[14]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[23]&!id_inst[6]&id_inst[4]
    &!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[22] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[14]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[22]&!id_inst[6]&id_inst[4]
    &!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[21] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[14]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[21]&!id_inst[6]&id_inst[4]
    &!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[20] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[14]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[20]&!id_inst[6]&id_inst[4]
    &!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[19] = (id_inst[31]&!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[19]&id_inst[6]
    &id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[14]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[19]&!id_inst[6]&id_inst[4]&!id_inst[3]
    &id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[18] = (id_inst[31]&!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[18]&id_inst[6]
    &id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[14]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[18]&!id_inst[6]&id_inst[4]&!id_inst[3]
    &id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[17] = (id_inst[31]&!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[17]&id_inst[6]
    &id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[14]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[17]&!id_inst[6]&id_inst[4]&!id_inst[3]
    &id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[16] = (id_inst[31]&!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[16]&id_inst[6]
    &id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[14]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[16]&!id_inst[6]&id_inst[4]&!id_inst[3]
    &id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[15] = (id_inst[31]&!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[15]&id_inst[6]
    &id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[14]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[15]&!id_inst[6]&id_inst[4]&!id_inst[3]
    &id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]);

assign id_imm[14] = (id_inst[31]&!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[14]&id_inst[6]
    &id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[14]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]&!id_inst[12]
    &!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&!id_inst[13]&!id_inst[6]&!id_inst[5]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[14]&!id_inst[6]&id_inst[4]&!id_inst[3]&id_inst[2]&id_inst[1]
    &id_inst[0]);

assign id_imm[13] = (id_inst[31]&!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[13]&id_inst[6]
    &id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[14]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&!id_inst[13]&!id_inst[6]&!id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[13]&!id_inst[6]
    &id_inst[4]&!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]);

assign id_imm[12] = (id_inst[31]&!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]&!id_inst[13]
    &!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &id_inst[1]&id_inst[0]) | (id_inst[12]&id_inst[6]&id_inst[5]
    &!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[14]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[31]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[12]&!id_inst[6]&id_inst[4]&!id_inst[3]
    &id_inst[2]&id_inst[1]&id_inst[0]);

assign id_imm[11] = (id_inst[31]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[20]
    &id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[14]&id_inst[7]&id_inst[6]&id_inst[5]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&id_inst[13]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (!id_inst[13]&id_inst[7]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[31]&!id_inst[13]&!id_inst[6]&!id_inst[5]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[31]&!id_inst[14]&!id_inst[12]&!id_inst[6]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[31]
    &!id_inst[14]&!id_inst[13]&!id_inst[6]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]);

assign id_imm[10] = (id_inst[30]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[30]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[30]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[30]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[30]&id_inst[14]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[30]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[30]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[30]&!id_inst[14]&!id_inst[12]&!id_inst[6]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]);

assign id_imm[9] = (id_inst[29]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[29]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[29]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[29]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[29]&id_inst[14]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[29]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[29]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[29]&!id_inst[14]&!id_inst[12]&!id_inst[6]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]);

assign id_imm[8] = (id_inst[28]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[28]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[28]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[28]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[28]&id_inst[14]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[28]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[28]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[28]&!id_inst[14]&!id_inst[12]&!id_inst[6]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]);

assign id_imm[7] = (id_inst[27]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[27]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[27]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[27]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[27]&id_inst[14]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[27]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[27]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[27]&!id_inst[14]&!id_inst[12]&!id_inst[6]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]);

assign id_imm[6] = (id_inst[26]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[26]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[26]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[26]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[26]&id_inst[14]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[26]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[26]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[26]&!id_inst[14]&!id_inst[12]&!id_inst[6]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]);

assign id_imm[5] = (id_inst[25]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[25]
    &!id_inst[14]&!id_inst[13]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[25]&!id_inst[14]
    &!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&id_inst[1]&id_inst[0]) | (id_inst[25]&id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[25]&id_inst[14]&id_inst[6]
    &id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[25]&id_inst[6]&id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[25]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[25]&!id_inst[14]&!id_inst[12]&!id_inst[6]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]);

assign id_imm[4] = (!id_inst[31]&!id_inst[30]&!id_inst[29]&!id_inst[28]
    &!id_inst[27]&!id_inst[26]&!id_inst[25]&id_inst[24]&!id_inst[6]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[31]&!id_inst[29]&!id_inst[28]&!id_inst[27]&!id_inst[26]
    &!id_inst[25]&id_inst[24]&id_inst[14]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[24]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[24]
    &!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]
    &!id_inst[4]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[14]
    &id_inst[11]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[24]&id_inst[6]&id_inst[5]
    &!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[14]&!id_inst[13]&id_inst[11]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[24]
    &id_inst[13]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (!id_inst[14]&!id_inst[12]
    &id_inst[11]&!id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[24]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[5]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[24]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]);

assign id_imm[3] = (!id_inst[31]&!id_inst[30]&!id_inst[29]&!id_inst[28]
    &!id_inst[27]&!id_inst[26]&!id_inst[25]&id_inst[23]&!id_inst[6]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[31]&!id_inst[29]&!id_inst[28]&!id_inst[27]&!id_inst[26]
    &!id_inst[25]&id_inst[23]&id_inst[14]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[23]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[23]
    &!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]
    &!id_inst[4]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[14]
    &id_inst[10]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[23]&id_inst[6]&id_inst[5]
    &!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[14]&!id_inst[13]&id_inst[10]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[23]
    &id_inst[13]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (!id_inst[14]&!id_inst[12]
    &id_inst[10]&!id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[23]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[5]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[23]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]);

assign id_imm[2] = (!id_inst[31]&!id_inst[30]&!id_inst[29]&!id_inst[28]
    &!id_inst[27]&!id_inst[26]&!id_inst[25]&id_inst[22]&!id_inst[6]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[31]&!id_inst[29]&!id_inst[28]&!id_inst[27]&!id_inst[26]
    &!id_inst[25]&id_inst[22]&id_inst[14]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[22]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[22]
    &!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]
    &!id_inst[4]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[14]
    &id_inst[9]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[22]&id_inst[6]&id_inst[5]
    &!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[14]&!id_inst[13]&id_inst[9]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[22]
    &id_inst[13]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (!id_inst[14]&!id_inst[12]
    &id_inst[9]&!id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[22]&!id_inst[14]&!id_inst[12]
    &!id_inst[6]&!id_inst[5]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[22]&!id_inst[13]&!id_inst[6]&!id_inst[5]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]);

assign id_imm[1] = (!id_inst[31]&!id_inst[30]&!id_inst[29]&!id_inst[28]
    &!id_inst[27]&!id_inst[26]&!id_inst[25]&id_inst[21]&!id_inst[6]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[31]&!id_inst[29]&!id_inst[28]&!id_inst[27]&!id_inst[26]
    &!id_inst[25]&id_inst[21]&id_inst[14]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[21]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[21]
    &!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]
    &!id_inst[4]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[14]
    &id_inst[8]&id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[21]&id_inst[6]&id_inst[5]
    &!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[14]&!id_inst[13]&id_inst[8]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[21]
    &id_inst[13]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (!id_inst[14]&!id_inst[12]
    &id_inst[8]&!id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[21]&!id_inst[14]&!id_inst[12]
    &!id_inst[6]&!id_inst[5]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[21]&!id_inst[13]&!id_inst[6]&!id_inst[5]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]);

assign id_imm[0] = (!id_inst[31]&!id_inst[30]&!id_inst[29]&!id_inst[28]
    &!id_inst[27]&!id_inst[26]&!id_inst[25]&id_inst[20]&!id_inst[6]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[31]&!id_inst[29]&!id_inst[28]&!id_inst[27]&!id_inst[26]
    &!id_inst[25]&id_inst[20]&id_inst[14]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[20]&!id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[20]
    &!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]
    &!id_inst[4]&!id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[14]&!id_inst[12]&id_inst[7]&!id_inst[6]&id_inst[5]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[14]&!id_inst[13]&id_inst[7]&!id_inst[6]&id_inst[5]
    &!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    id_inst[20]&id_inst[13]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[20]&!id_inst[14]
    &!id_inst[12]&!id_inst[6]&!id_inst[5]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (id_inst[20]&!id_inst[13]&!id_inst[6]
    &!id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]);

//end id_imm

//begin op_ctl
assign op_ctl[31] = 1'b0 ;

assign op_ctl[30] = 1'b0 ;

assign op_ctl[29] = 1'b0 ;

assign op_ctl[28] = 1'b0 ;

assign op_ctl[27] = 1'b0 ;

assign op_ctl[26] = 1'b0 ;

assign op_ctl[25] = 1'b0 ;

assign op_ctl[24] = 1'b0 ;

assign op_ctl[23] = 1'b0 ;

assign op_ctl[22] = 1'b0 ;

assign op_ctl[21] = 1'b0 ;

assign op_ctl[20] = 1'b0 ;

assign op_ctl[19] = 1'b0 ;

assign op_ctl[18] = 1'b0 ;

assign op_ctl[17] = 1'b0 ;

assign op_ctl[16] = 1'b0 ;

assign op_ctl[15] = 1'b0 ;

assign op_ctl[14] = 1'b0 ;

assign op_ctl[13] = 1'b0 ;

assign op_ctl[12] = 1'b0 ;

assign op_ctl[11] = 1'b0 ;

assign op_ctl[10] = 1'b0 ;

assign op_ctl[9] = 1'b0 ;

assign op_ctl[8] = 1'b0 ;

assign op_ctl[7] = 1'b0 ;

assign op_ctl[6] = (!id_inst[14]&!id_inst[13]&!id_inst[12]&id_inst[6]&id_inst[5]
    &!id_inst[4]&id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[6]
    &id_inst[5]&!id_inst[4]&id_inst[3]&id_inst[2]&id_inst[1]&id_inst[0]);

assign op_ctl[5] = (!id_inst[31]&!id_inst[29]&!id_inst[28]&!id_inst[27]
    &!id_inst[26]&!id_inst[25]&!id_inst[14]&!id_inst[13]&!id_inst[12]
    &!id_inst[6]&id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[31]&!id_inst[29]&!id_inst[28]&!id_inst[27]&!id_inst[26]
    &!id_inst[25]&id_inst[14]&!id_inst[13]&id_inst[12]&!id_inst[6]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[31]&!id_inst[30]&!id_inst[29]&!id_inst[28]&!id_inst[27]
    &!id_inst[26]&!id_inst[25]&!id_inst[6]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[13]&!id_inst[6]
    &!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[12]&!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]
    &!id_inst[2]&id_inst[1]&id_inst[0]);

assign op_ctl[4] = (!id_inst[31]&!id_inst[30]&!id_inst[29]&!id_inst[28]
    &!id_inst[27]&!id_inst[26]&!id_inst[25]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (
    !id_inst[31]&!id_inst[29]&!id_inst[28]&!id_inst[27]&!id_inst[26]
    &!id_inst[25]&id_inst[14]&!id_inst[6]&!id_inst[5]&id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (!id_inst[13]
    &id_inst[6]&id_inst[5]&!id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]
    &id_inst[0]) | (id_inst[14]&id_inst[6]&id_inst[5]&!id_inst[4]
    &!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]) | (id_inst[13]
    &!id_inst[6]&!id_inst[5]&id_inst[4]&!id_inst[3]&!id_inst[2]
    &id_inst[1]&id_inst[0]) | (!id_inst[12]&!id_inst[6]&!id_inst[5]
    &id_inst[4]&!id_inst[3]&!id_inst[2]&id_inst[1]&id_inst[0]);

assign op_ctl[3] = 1'b0 ;

assign op_ctl[2] = 1'b0 ;

assign op_ctl[1] = 1'b0 ;

assign op_ctl[0] = 1'b0 ;

//end op_ctl

assign id_rd         = id_inst[11:7];
assign id_func3_code = id_inst[14:12];
assign id_func7_code = id_inst[30];

assign id_rs1 = id_inst[19:15];
assign id_rs2 = id_inst[24:20];

//stall
assign id_br           = (ctrl_stall == 1) ? 0 : br             ;
assign id_mem_read     = (ctrl_stall == 1) ? 0 : mem_read       ;       
assign id_mem2reg      = (ctrl_stall == 1) ? 0 : mem2reg        ;      
//assign id_alu_op       = (ctrl_stall == 1) ? 0 : alu_op         ; 
assign id_op_ctl       = (ctrl_stall == 1) ? 0 : op_ctl         ;     
assign id_mem_write    = (ctrl_stall == 1) ? 0 : mem_write      ;            
//assign id_alu_src1     = (ctrl_stall == 1) ? 0 : alu_src1       ;
//assign id_alu_src2     = (ctrl_stall == 1) ? 0 : alu_src2       ; 
assign id_src1_sel     = (ctrl_stall == 1) ? 0 : src1_sel       ;
assign id_src2_sel     = (ctrl_stall == 1) ? 0 : src2_sel       ; 
assign id_br_addr_mode = (ctrl_stall == 1) ? 0 : br_addr_mode   ;       
assign id_regs_write   = (ctrl_stall == 1) ? 0 : regs_write     ;             



endmodule

