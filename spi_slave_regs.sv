module spi_slave_regs #(
	parameter REG_SIZE = 8
) (
	input  logic                sclk,
	input  logic                rstn,
	input  logic [REG_SIZE-1:0] wr_data,
	input  logic [1:0]          wr_addr,
	input  logic                wr_data_valid,
	output logic [REG_SIZE-1:0] rd_data,
	input  logic [1:0]          rd_addr,
	output logic [7:0]          dummy_cycles,
	output logic                en_qpi,
	output logic [15:0]         wrap_length
);
	
	logic [REG_SIZE-1:0] reg0; // bit 0 enables qpi
	logic [REG_SIZE-1:0] reg1; // number of dummy cycles
	logic [REG_SIZE-1:0] reg2; // wrap length, low
	logic [REG_SIZE-1:0] reg3; // wrap length, high
	
	assign en_qpi       = reg0[0];
	assign dummy_cycles = reg1;
	assign wrap_length  = {reg3,reg2};

	always_comb
	begin
		case(rd_addr)
			2'b00:
				rd_data = reg0;
			2'b01:
				rd_data = reg1;
			2'b10:
				rd_data = reg2;
			2'b11:
				rd_data = reg3;
		endcase
	end
	
	always @(posedge sclk or negedge rstn)
	begin
		if (rstn == 0)
		begin
			reg0= 'h0;
			reg1= 'd32;
			reg2= 'h0;
			reg3= 'h0;
		end
		else
		begin
			if (wr_data_valid)
			begin
				case(wr_addr)
					2'b00:
						reg0=wr_data;
					2'b01:
						reg1=wr_data;
					2'b10:
						reg2=wr_data;
					2'b11:
						reg3=wr_data;
				endcase
			end
		end
	end
endmodule
