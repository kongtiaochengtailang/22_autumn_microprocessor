module reg_mem_wb(
    input  wire clk,
    input  wire rst,
    input  wire[31:0] me_mem_data,
    input  wire[31:0] me_alu_o,
    input  wire[4:0]  me_rd,
    input  wire       me_mem2reg,
    input  wire       me_regs_write,
    output reg[31:0]  wb_mem_data,
    output reg[31:0]  wb_alu_o,
    output reg[4:0]   wb_rd,
    output reg        wb_mem2reg,
    output reg        wb_regs_write,

    //exception handler
    input wire me_wb_flush,
    input wire me_wr_csr,
    input wire[31:0] me_waddr_csr,
    input wire[31:0] me_wdata_csr,
    input wire[31:0] me_raddr_csr,
    output reg wb_wr_csr,
    output reg[31:0] wb_waddr_csr,
    output reg[31:0] wb_wdata_csr,
    output reg[31:0] ctrl_raddr_csr
);

always @(posedge clk) begin
    if (!rst || me_wb_flush)begin
        wb_mem_data    <= 0;     
        wb_alu_o       <= 0;     
        wb_rd          <= 0; 
        wb_mem2reg     <= 0;     
        wb_regs_write  <= 0;

        wb_wr_csr <= 0;
        wb_waddr_csr <= 0;
        wb_wdata_csr <= 0;
        ctrl_raddr_csr <= 0;
    end 
    else begin
        wb_mem_data    <= me_mem_data;     
        wb_alu_o       <= me_alu_o;     
        wb_rd          <= me_rd; 
        wb_mem2reg     <= me_mem2reg;     
        wb_regs_write  <= me_regs_write;

        wb_wr_csr <= me_wr_csr;
        wb_waddr_csr <= me_waddr_csr;
        wb_wdata_csr <= me_wdata_csr;
        ctrl_raddr_csr <= me_raddr_csr;   
    end
    $display("wb_mem_data  : %h",wb_mem_data);
    $display("wb_alu_o     : %h",wb_alu_o);
    $display("wb_mem2reg   : %h",wb_mem2reg);
    $display("wb_regs_write: %h",wb_regs_write);
end

endmodule