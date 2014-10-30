module spi_slave_dc_fifo #(
		parameter DATA_WIDTH = 32,
    	parameter BUFFER_DEPTH = 8
    	) 
    	(input logic                  clk_a,
		input  logic                  rstn_a,
		input  logic [DATA_WIDTH-1:0] data_a,
		input  logic                  valid_a,
		output logic                  ready_a,
		input  logic                  clk_b,
		input  logic                  rstn_b,
		output logic [DATA_WIDTH-1:0] data_b,
		output logic                  valid_b,
		input  logic                  ready_b
		);
	
	logic [DATA_WIDTH-1:0] data_async;
	logic [BUFFER_DEPTH-1:0] write_token;
	logic [BUFFER_DEPTH-1:0] read_pointer;

 dc_token_ring_fifo_din #(
 		.DATA_WIDTH(DATA_WIDTH),
 		.BUFFER_DEPTH(BUFFER_DEPTH)
 		) u_din (
 		.clk(clk_a), 
 		.rstn(rstn_a), 
 		.data(data_a), 
 		.valid(valid_a), 
 		.ready(ready_a), 
 		.write_token(write_token), 
 		.read_pointer(read_pointer), 
 		.data_async(data_async));
 
 dc_token_ring_fifo_dout #(
 		.DATA_WIDTH(DATA_WIDTH),
 		.BUFFER_DEPTH(BUFFER_DEPTH)
 		) u_dout (.clk(clk_b), 
 		.rstn(rstn_b), 
 		.data(data_b), 
 		.valid(valid_b), 
 		.ready(ready_b), 
 		.write_token(write_token), 
 		.read_pointer(read_pointer), 
 		.data_async(data_async));
 
endmodule
