module reg_ex_mem(
    input  wire clk,
    input  wire rst,
    input  wire[31:0] ex_regs_data2,
    input  wire[31:0] ex_alu_o,
    input  wire[4:0]  ex_rd,
    input  wire       ex_mem_read,
    input  wire       ex_mem2reg,
    input  wire       ex_mem_write,
    input  wire       ex_regs_write,
    input  wire[2:0]  ex_func3_code, 

    //forwarding
    input wire[4:0]   ex_rs2,
    output reg[4:0]   me_rs2,

    output reg[31:0]  me_regs_data2,
    output reg[31:0]  me_alu_o,
    output reg[4:0]   me_rd,
    output reg        me_mem_read,
    output reg        me_mem2reg,
    output reg        me_mem_write,
    output reg        me_regs_write,
    output reg[2:0]   me_func3_code,

    //exception handler
    input wire ex_me_flush,
    input wire[31:0] ex_exception,
    input wire ex_wr_csr,
    input wire[31:0] ex_waddr_csr,
    input wire[31:0] ex_wdata_csr,
    input wire[31:0] ex_raddr_csr,
    input wire[31:0] ex_pc,
    input wire[31:0] ex_inst,
    output reg[31:0] me_exception,
    output reg me_wr_csr,
    output reg[31:0] me_waddr_csr,
    output reg[31:0] me_wdata_csr,
    output reg[31:0] me_raddr_csr,
    output reg[31:0] me_pc,
    output reg[31:0] me_inst
);

always @(posedge clk) begin
    if (!rst || ex_me_flush)begin
        me_regs_data2  <= 0;         
        me_alu_o       <= 0;     
        me_rd          <= 0; 
        me_mem_read    <= 0;     
        me_mem2reg     <= 0;     
        me_mem_write   <= 0;         
        me_regs_write  <= 0;  
        me_rs2         <= 0;   
        me_func3_code  <= 0;

        me_pc <= 0;
        me_inst <= 0;
        me_exception <= 0;
        me_waddr_csr <= 0;
        me_wdata_csr <= 0;
        me_wr_csr <= 0;
        me_raddr_csr <= 0;

    end 
    else begin  
        me_regs_data2  <= ex_regs_data2;         
        me_alu_o       <= ex_alu_o;     
        me_rd          <= ex_rd; 
        me_mem_read    <= ex_mem_read;     
        me_mem2reg     <= ex_mem2reg;     
        me_mem_write   <= ex_mem_write;         
        me_regs_write  <= ex_regs_write;
        me_rs2         <= ex_rs2;    
        me_func3_code  <= ex_func3_code;

        me_pc <= ex_pc;
        me_inst <= ex_inst;
        me_exception <= ex_exception;
        me_waddr_csr <= ex_waddr_csr;
        me_wdata_csr <= ex_wdata_csr;
        me_wr_csr <= ex_wr_csr;
        me_raddr_csr <= ex_raddr_csr; 
    end

    $display("me_alu_o: %h",me_alu_o);

end

endmodule