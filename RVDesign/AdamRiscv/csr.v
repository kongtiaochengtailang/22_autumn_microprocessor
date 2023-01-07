// csr.v is included in the wb stage.
`include "csr_ffr.v"
`include "../AdamRiscv/define.vh"

module csr(
    // read csr
    input wire [`REG_BUS] raddr_csr_i,
    output reg [`REG_BUS] rdata_csr_o,  

    // write csr
    input wire               wr_csr_i,
    input wire[`REG_BUS]      waddr_csr_i,
    input wire[`REG_BUS]      wdata_csr_i,         

    // mcause
    input wire set_mcause_i,
    input wire ie_type_i,
    input wire [3:0] exception_code_i,
    
    // mepc
    input wire set_mepc_i,
    input wire [`REG_BUS] epc_i,

    // mstatus
    input wire ecall_en_i,
    input wire mret_en_i,

    // mtval
    input wire set_mtval_i,
    input wire [`REG_BUS] mtval_i,


    input wire clk,
    input wire rst_n
);

    // mcause
    wire [`REG_BUS] mcause;
    wire [`REG_BUS] mcause_nxt;
    wire wr_mcause_i;
    wire wr_mcause_en;

    assign wr_mcause_i = (waddr_csr_i[11:0] == `CSR_MCAUSE_ADDR) && wr_csr_i;
    assign wr_mcause_en = set_mcause_i | wr_mcause_i;
    assign mcause_nxt = set_mcause_i? {ie_type_i, {27{1'b0}}, exception_code_i}
                    : (wr_mcause_i? wdata_csr_i : mcause); 

    csr_ffr #(`XLEN) mcause_ffr(
        wr_mcause_en,
        mcause_nxt,
        mcause,
        clk,
        rst_n
    );


    // mepc
    wire [`REG_BUS] mepc;
    wire [`REG_BUS] mepc_nxt;
    wire wr_mepc_i;
    wire wr_mepc_en;

    assign wr_mepc_i = (waddr_csr_i[11:0] == `CSR_MEPC_ADDR) && wr_csr_i;
    assign wr_mepc_en = set_mepc_i | wr_mepc_i;
    assign mepc_nxt = set_mepc_i? epc_i
                    : (wr_mepc_i? {wdata_csr_i[31:2], 2'b00} : mepc);

    csr_ffr #(`XLEN) mepc_ffr(
        wr_mepc_en,
        mepc_nxt,
        mepc,
        clk,
        rst_n
    );


    // mtvec
    reg [`REG_BUS] mtvec;
    wire wr_mtvec_i;

    assign wr_mtvec_i = (waddr_csr_i[11:0] == `CSR_MTVEC_ADDR) && wr_csr_i;

    always @(posedge clk) begin
        if(!rst_n) begin
            mtvec <= `MTVEC_DEFAULT;
        end
        else if(wr_mtvec_i) begin
            mtvec <= wdata_csr_i;
        end
    end


    // mstatus
    wire [`REG_BUS] mstatus;
    wire mstatus_ie;
    wire mstatus_pie;
    wire mstatus_ie_nxt;
    wire mstatus_pie_nxt;
    wire wr_mstatus_i;
    wire wr_mstatus_en;

    assign wr_mstatus_i = (waddr_csr_i[11:0] == `CSR_MSTATUS_ADDR) && wr_csr_i;
    assign wr_mstatus_en = ecall_en_i | mret_en_i | wr_mstatus_i;
    assign mstatus_pie_nxt = wr_mstatus_en? (wr_mstatus_i? wdata_csr_i[7] 
                                                        : (mret_en_i? 1'b1 
                                                                : mstatus_ie))
                                        : mstatus_pie;                       
    assign mstatus_ie_nxt = wr_mstatus_en? (wr_mstatus_i? wdata_csr_i[3] 
                                                        : (ecall_en_i? 1'b0 
                                                                : mstatus_pie))
                                        : mstatus_ie;

    csr_ffr #(1) mstatus_ie_ffr(
        wr_mstatus_en,
        mstatus_ie_nxt,
        mstatus_ie,
        clk,
        rst_n
    );
    csr_ffr #(1) mstatus_pie_ffr(
        wr_mstatus_en,
        mstatus_pie_nxt,
        mstatus_pie,
        clk,
        rst_n
    );


    assign mstatus[31:13] = 19'b0;
    assign mstatus[12:11] = 2'b11;              // MPP 
    assign mstatus[10:8]  = 3'b0;
    assign mstatus[7]     = mstatus_pie;     // MPIE
    assign mstatus[6:4]   = 3'b0; 
    assign mstatus[3]     = mstatus_ie;      // MIE
    assign mstatus[2:0]   = 3'b0;


    // mtval
    wire [`REG_BUS] mtval;
    wire [`REG_BUS] mtval_nxt;
    wire wr_mtval_i;
    wire wr_mtval_en;

    assign wr_mtval_i = (waddr_csr_i[11:0] == `CSR_MTVAL_ADDR) && wr_csr_i;
    assign wr_mtval_en = set_mtval_i | wr_mtval_i;
    assign mtval_nxt = set_mtval_i? mtval_i
                    : (wr_mtval_i? wdata_csr_i : mtval);

    csr_ffr #(`XLEN) mtval_ffr(
        wr_mtval_en,
        mtval_nxt,
        mtval,
        clk,
        rst_n
    );


    // read csr
    always @(*) begin
        if((waddr_csr_i[11:0] == raddr_csr_i[11:0]) && wr_csr_i) begin
            rdata_csr_o = wdata_csr_i;
        end
        else begin
            case(raddr_csr_i[11:0])
                `CSR_MCAUSE_ADDR: begin
                    rdata_csr_o = mcause;
                end

                `CSR_MEPC_ADDR: begin
                    rdata_csr_o = mepc;
                end

                `CSR_MTVEC_ADDR: begin
                    rdata_csr_o = mtvec;
                end

                `CSR_MSTATUS_ADDR: begin
                    rdata_csr_o = mstatus;
                end

                `CSR_MTVAL_ADDR: begin
                    rdata_csr_o = mtval;
                end

                default: begin
                    rdata_csr_o = `ZERO;
                end

            endcase
        end
        
    end




endmodule