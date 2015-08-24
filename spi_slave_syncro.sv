module spi_slave_syncro
		#(
		parameter AXI_ADDR_WIDTH = 32
		)
    (
		input  logic                       sys_clk,
		input  logic                       rstn,
		input  logic                       cs,
		input  logic [AXI_ADDR_WIDTH-1:0]  address,
		input  logic                       address_valid,
		input  logic                       rd_wr,
		output logic                       cs_sync,
		output logic [AXI_ADDR_WIDTH-1:0]  address_sync,
		output logic                       address_valid_sync,
		output logic                       rd_wr_sync
		);
	
	logic [1:0] cs_reg;
	logic [1:0] valid_reg;
	logic [1:0] rdwr_reg;
	
	assign cs_sync = cs_reg[1];
	assign address_valid_sync = valid_reg[1];
	assign address_sync = address;
	assign rd_wr_sync = rdwr_reg[1];
	
	always @(posedge sys_clk or negedge rstn)
	begin
		if(rstn == 0)
		begin
			cs_reg     =  2'b11;
			valid_reg  =  2'b00;
			rdwr_reg   =  2'b00;
		end
		else
		begin
			cs_reg     = {cs_reg[0],cs};
			valid_reg  = {valid_reg[0],address_valid};
			rdwr_reg   = {rdwr_reg[0],rd_wr};
		end
	end
	
endmodule
