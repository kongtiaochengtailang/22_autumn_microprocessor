`include "../AdamRiscv/define.vh"

module stage_mem(
    input  wire        clk,
    input  wire        rst,
    input  wire[31:0]  me_regs_data2,
    input  wire[31:0]  me_alu_o,
    input  wire        me_mem_read,
    input  wire        me_mem_write,
    input  wire[2:0]   me_func3_code,
    //forwarding
    input wire         forward_data,
    input wire[31:0]   w_regs_data,

    output wire[31:0]  me_mem_data,

    //exception handler
    input wire[31:0] me_exception_i,
    input wire[31:0] me_pc_i,
    input wire[31:0] me_inst_i,
    input wire wr_csr_i,
    input wire[31:0] waddr_csr_i,
    input wire[31:0] wdata_csr_i,
    input wire[31:0] raddr_csr_i,
    output wire[31:0] me_exception_o,
    output wire[31:0] me_pc_o,
    output wire[31:0] me_inst_o,
    output wire wr_csr_o,
    output wire[31:0] waddr_csr_o,
    output wire[31:0] wdata_csr_o,   
    output wire[31:0] raddr_csr_o
);

wire[31:0]  w_data_mem;
wire[31:0]  r_data_mem;

data_memory 
#(
    .DROM_SPACE (1024       )
)
u_data_memory(
    .clk        (clk               ),
    .rst        (rst               ),
    .data_addr  (me_alu_o          ),
    .w_data_mem (w_data_mem        ),
    .r_en_mem   (me_mem_read       ),
    .w_en_mem   (me_mem_write      ),
    .byte_sel   (me_func3_code[1:0]),
    .r_data_mem (r_data_mem        )
);

assign w_data_mem  = forward_data ? w_regs_data : me_regs_data2;

assign me_mem_data = (me_func3_code == `LB) ? {{24{r_data_mem[7]}},r_data_mem[7:0]}:
                     (me_func3_code == `LH) ? {{16{r_data_mem[7]}},r_data_mem[15:0]}:
                     (me_func3_code == `LBU)? {24'b0,r_data_mem[7:0]}:
                     (me_func3_code == `LHU)? {16'b0,r_data_mem[15:0]}:
                     r_data_mem;

// exception handler
wire addr_halfword;
wire addr_word;
wire addr_align_halfword;
wire addr_align_word;

wire load_operation;
wire store_operation;

wire load_addr_misaligned;
wire store_addr_misaligned;

assign load_operation = !me_mem_write ? ((me_func3_code == `LB) || (me_func3_code == `LH) || (me_func3_code == `LBU) || (me_func3_code == `LHU) || (me_func3_code == `LW)) : 0;
assign store_operation = me_mem_write;

assign addr_halfword = me_mem_write ? (me_func3_code[1:0] == 2'b01) : ((me_func3_code == `LH) || (me_func3_code == `LHU));
assign addr_word = me_mem_write ? (me_func3_code[1:0] == 2'b10) : (me_func3_code == `LW);
assign addr_align_halfword = addr_halfword && (me_alu_o[0] == 1'b0);
assign addr_align_word = addr_word && (me_alu_o[1:0] == 2'b00);

assign load_addr_misaligned = (~(addr_align_halfword || addr_align_word)) & load_operation;
assign store_addr_misaligned = (~(addr_align_halfword || addr_align_word)) & store_operation;

assign me_exception_o = {25'b0, load_addr_misaligned, store_addr_misaligned, me_exception_i[4:0]};
assign me_pc_o = me_pc_i;
assign me_inst_o = me_inst_i;
assign wr_csr_o = wr_csr_i;
assign waddr_csr_o = waddr_csr_i;
assign wdata_csr_o = wdata_csr_i;
assign raddr_csr_o = raddr_csr_i;


endmodule
