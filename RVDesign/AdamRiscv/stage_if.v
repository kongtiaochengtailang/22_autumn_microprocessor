module stage_if(
    input  wire          clk,
    input  wire          rst,
    input  wire          pc_stall,
    input  wire[31:0]    br_addr,
    input  wire          br_ctrl,
    output wire[31:0]    if_inst,
    output wire[31:0]    if_pc,

    input wire flush_i,
    input wire [31:0] new_pc_i

);

pc u_pc(
    .clk      (clk      ),
    .br_ctrl  (br_ctrl  ),
    .br_addr  (br_addr  ),
    .rst      (rst      ),
    .pc_o     (if_pc    ),
    .pc_stall (pc_stall ),
    .flush_i  (flush_i),
    .new_pc_i (new_pc_i)
);

inst_memory #(
    .IROM_SPACE (1024 )
)inst_memory(
    .inst_addr (if_pc     ),
    .inst_o    (if_inst      )
);


endmodule
