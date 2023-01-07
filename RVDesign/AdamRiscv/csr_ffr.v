module csr_ffr #(
    parameter DW = 32
)(	
    input wire			en,
    input wire [DW-1:0]	d,
    output wire [DW-1:0] q,
    
    input wire clk,
    input wire rst_n
);
    reg	[DW-1:0]		q_r;

    always @(posedge clk) begin
        if(!rst_n) begin
            q_r <= {DW{1'b0}};
        end
        else if(en == 1'b1) begin
            q_r <= d;
        end
    end
    
    assign q = q_r;
    
endmodule

