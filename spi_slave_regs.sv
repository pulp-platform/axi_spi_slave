module spi_slave_regs #(
		parameter REG_SIZE = 8
		) (
		input  logic       sclk,
		input  logic       rstn,
		input  logic [REG_SIZE-1:0] wr_data,
		input  logic [1:0] wr_addr,
		input  logic       wr_data_valid,
		output logic [REG_SIZE-1:0] rd_data,
		input  logic [1:0] rd_addr,
		output logic       en_qpi
		);
	
	logic [REG_SIZE-1:0] reg0;
	logic [REG_SIZE-1:0] reg1;
	logic [REG_SIZE-1:0] reg2;
	logic [REG_SIZE-1:0] reg3;
	
	assign en_qpi = reg0[0];
		
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
			reg1= 'h0;
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
