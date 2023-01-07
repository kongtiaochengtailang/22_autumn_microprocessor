`include "../AdamRiscv/define.vh"

module stage_ex(
    input  wire[31:0]  ex_pc,  //pc_now
    input  wire[31:0]  ex_regs_data1,
    input  wire[31:0]  ex_regs_data2,
    input  wire[31:0]  ex_imm,
    input  wire[2:0]   ex_func3_code, 
    input  wire        ex_func7_code,
    //input  wire[2:0]   ex_op_ctl,
    input  wire[31:0]   ex_op_ctl,
    input  wire[1:0]   ex_src1_sel,
    input  wire[1:0]   ex_src2_sel,
    input  wire        ex_br_addr_mode,
    input  wire        ex_br,
    //forwarding
    input  wire[1:0]   forwardA,
    input  wire[1:0]   forwardB,
    input  wire[31:0]  me_alu_o,
    input  wire[31:0]  w_regs_data,

    output wire[31:0]  ex_alu_o,
    output wire[31:0]  br_pc, //branch address
    output wire        br_ctrl,

    //exception handler
    input wire[31:0]   ex_exception_i,
    output wire[31:0]  ex_exception_o
);

wire [3:0]  alu_ctrl;
wire [31:0] op_A;
wire [31:0] op_A_pre;
wire [31:0] op_B;
wire [31:0] op_B_pre;
wire        br_mark;
wire [31:0] br_addr_op_A; 

wire [3:0]  fb_sel; //0:ALU, 1:B1, 2:B2, 3:MUL, 4:DIV
wire [27:0] fb_ctl;
wire [31:0] alu_result;
wire [31:0] b1_result; //wait for b1 designer extend RTL
wire [31:0] b2_result; //wait for b2 designer extend RTL
wire [31:0] mul_result; //wait for mul designer extend RTL
wire [31:0] div_result; //wait for div designer extend RTL

assign fb_sel = ex_op_ctl[3:0];
assign fb_ctl = ex_op_ctl[31:4];

assign ex_alu_o[31:0] = (fb_sel==4'd0) ? alu_result[31:0] :
                        (fb_sel==4'd1) ? b1_result[31:0]  :
                        (fb_sel==4'd2) ? b2_result[31:0]  :
                        (fb_sel==4'd3) ? mul_result[31:0] :
                        (fb_sel==4'd4) ? div_result[31:0] :
                        {32{1'b0}};

alu_control u_alu_control(
    //.alu_op     (ex_op_ctl     ),
    .alu_op     (fb_ctl[2:0]   ),
    .func3_code (ex_func3_code ),
    .func7_code (ex_func7_code ),
    .alu_ctrl_r (alu_ctrl      )
);


alu u_alu(
    .alu_ctrl (alu_ctrl      ),
    .op_A     (op_A          ),
    .op_B     (op_B          ),
    //.alu_o    (ex_alu_o      ),
    .alu_o    (alu_result      ),
    .br_mark  (br_mark       )
);

assign br_addr_op_A = (ex_br_addr_mode == `J_REG) ? ex_regs_data1 : ex_pc;
assign br_pc        = br_addr_op_A + ex_imm;
assign op_B         = (ex_src2_sel == `PC_PLUS4)? 32'd4 : (ex_src2_sel == `IMM)? ex_imm : op_B_pre;
assign op_A         = (ex_src1_sel == `NULL)? 32'd0 : (ex_src1_sel == `PC)? ex_pc : op_A_pre;
assign op_B_pre     = (forwardB == `EX_MEM_B)? me_alu_o : (forwardB == `MEM_WB_B)? w_regs_data : ex_regs_data2;
assign op_A_pre     = (forwardA == `EX_MEM_A)? me_alu_o : (forwardA == `MEM_WB_A)? w_regs_data : ex_regs_data1;
assign br_ctrl      = br_mark && ex_br;
assign ex_exception_o = ex_exception_i;

always @(*) begin
    if (|forwardA)
        $display("forwardA! OP_A: %h",op_A);
    else if (|forwardB)
        $display("forwardB! OP_B: %h",op_B);
end

endmodule
