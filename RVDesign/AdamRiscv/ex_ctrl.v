`include "../AdamRiscv/define.vh"

module ex_ctrl(

    input wire [`REG_BUS] exception_i,
    input wire [`REG_BUS] pc_i,
    input wire [`REG_BUS] inst_i,


    output reg set_mcause_o,
    output reg ie_type_o,
    output reg [3:0] exception_code_o,

    output reg set_mepc_o,
    input wire [`REG_BUS] epc_i,// mret
    output wire [`REG_BUS] epc_o,

    input wire [`REG_BUS] mtvec_i,

    output reg ecall_en_o,
    output reg mret_en_o,

    output reg set_mtval_o,
    output reg [`REG_BUS] mtval_o,

    output reg flush_o,
    output reg [`REG_BUS] new_pc_o,



    input wire clk,
    input wire rst_n

);

    //the state_machine method
    parameter RESET = 4'b0001;
    parameter OPERATING = 4'b0010;
    parameter TRAP_TAKEN = 4'b0100;
    parameter TRAP_RETURN = 4'b1000;

    reg [3:0] CS;
    reg [3:0] NS;

    wire ecall;
    wire mret;
    wire breakpoint;
    wire inst_addr_misaligned;
    wire illegal_inst;
    wire load_addr_misaligned;
    wire store_addr_misaligned;

    wire trap_happend;

    assign epc_o = pc_i;
    assign {store_addr_misaligned, load_addr_misaligned, illegal_inst, inst_addr_misaligned, breakpoint, mret, ecall} = exception_i[6:0];
    assign trap_happend = store_addr_misaligned | load_addr_misaligned | illegal_inst | inst_addr_misaligned | ecall;

    // state skip
    always @(posedge clk) begin
        if(!rst_n) begin
            CS <= RESET;
        end
        else begin
            CS <= NS;
        end
    end


    // NS generation
    always @(*) begin
        case(CS)
            RESET: begin
                NS = OPERATING;
            end

            OPERATING: begin
                if(trap_happend) begin
                    NS = TRAP_TAKEN;
                end
                else if(mret) begin
                    NS = TRAP_RETURN;
                end
                else begin
                    NS = OPERATING;
                end
            end

            TRAP_TAKEN: begin
                NS = OPERATING;
            end

            TRAP_RETURN: begin
                NS = OPERATING;
            end

            default: begin
                NS = OPERATING;
            end
        endcase
        
    end

    wire [29:0] mtvec_base;
    wire [`REG_BUS] trap_vector;
    wire [`REG_BUS] interrupt_vector;
    wire [`REG_BUS] base_offset;
    
    assign mtvec_base = mtvec_i[31:2];
    assign base_offset = {26'b0, exception_code_o, 2'b00};
    assign interrupt_vector = mtvec_i[0]? {mtvec_base, 2'b00} + base_offset : {mtvec_base, 2'b00};
    assign trap_vector = ie_type_o? interrupt_vector : {mtvec_base, 2'b00};


    // output generation
    always @(*) begin
        case(CS)
            RESET: begin
                flush_o = 1'b0;
                new_pc_o = `REBOOT_ADDR;
                set_mepc_o = 1'b0;
                set_mcause_o = 1'b0;
                ecall_en_o = 1'b0;
                mret_en_o = 1'b0;
            end

            OPERATING: begin
                flush_o = 1'b0;
                new_pc_o = `ZERO;
                set_mepc_o = 1'b0;
                set_mcause_o = 1'b0;
                ecall_en_o = 1'b0;
                mret_en_o = 1'b0;
            end

            TRAP_TAKEN: begin
                flush_o = 1'b1;
                new_pc_o = trap_vector;
                set_mepc_o = 1'b1;
                set_mcause_o = 1'b1;
                ecall_en_o = 1'b1;
                mret_en_o = 1'b0;
            end

            TRAP_RETURN: begin
                flush_o = 1'b1;
                new_pc_o = epc_i;
                set_mepc_o = 1'b0;
                set_mcause_o = 1'b0;
                ecall_en_o = 1'b0;
                mret_en_o = 1'b1;
            end

            default: begin
                flush_o = 1'b0;
                new_pc_o = `ZERO;
                set_mepc_o = 1'b0;
                set_mcause_o = 1'b0;
                ecall_en_o = 1'b0;
                mret_en_o = 1'b0;
            end

        endcase
    end


    // csr info (exception done, todo: interrupt)
    always @(posedge clk) begin
        if(!rst_n) begin
            ie_type_o <= 1'b0;
            exception_code_o <= 4'b0000;
            set_mtval_o <= 1'b0;
            mtval_o <= 32'b0;
        end

        else if(CS == OPERATING) begin
            if(inst_addr_misaligned) begin
                ie_type_o <= 1'b0;
                exception_code_o <= 4'b0000;
                set_mtval_o <= 1'b1;
                mtval_o <= pc_i;
            end

            else if(illegal_inst) begin
                ie_type_o <= 1'b0;
                exception_code_o <= 4'b0010;
                set_mtval_o <= 1'b1;
                mtval_o <= inst_i;
            end

            else if(breakpoint) begin
                ie_type_o <= 1'b0;
                exception_code_o <= 4'b0011;
                set_mtval_o <= 1'b1;
                mtval_o <= pc_i;
            end

            else if(load_addr_misaligned) begin
                ie_type_o <= 1'b0;
                exception_code_o <= 4'b0100;
                set_mtval_o <= 1'b1;
                mtval_o <= pc_i;
            end

            else if(store_addr_misaligned) begin
                ie_type_o <= 1'b0;
                exception_code_o <= 4'b0110;
                set_mtval_o <= 1'b1;
                mtval_o <= pc_i;
            end

            else if(ecall) begin
                ie_type_o <= 1'b0;
                exception_code_o <= 4'b1011;
            end


        end
        
    end

endmodule