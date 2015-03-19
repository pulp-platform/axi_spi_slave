module spi_slave_rx
(
    input  logic        sclk,
    input  logic        cs,
    input  logic        sdi0,
    input  logic        sdi1,
    input  logic        sdi2,
    input  logic        sdi3,
    input  logic        en_quad_in,
    input  logic  [7:0] counter_in,
    input  logic        counter_in_upd,
    output logic [31:0] data,
    output logic        data_ready
);

    reg [31:0] data_int;
    reg [31:0] data_int_next;
    reg  [7:0] counter;
    reg  [7:0] counter_trgt;
    reg  [7:0] counter_next;
    reg  [7:0] counter_trgt_next;

    logic      running;
    logic      running_next;

    assign data = data_int_next;

    always_comb
    begin
        if (counter_in_upd)
            counter_trgt_next = counter_in;
        else if ((counter_trgt == 8'h1) && !en_quad_in)
                counter_trgt_next = 8'h7;
             else
                counter_trgt_next = counter_trgt;

        if (counter_in_upd)
            running_next = 1'b1;
        else if (counter == counter_trgt)
                running_next = 1'b0;
             else
                running_next = running;

        if (running)
        begin
                if (counter == counter_trgt)
                begin
                    counter_next =  'h0;
                    data_ready   = 1'b1;
                end
                else
                begin
                    counter_next = counter + 1;
                    data_ready   = 1'b0;
                end
                if (en_quad_in)
                    data_int_next = {data_int[27:0],sdi3,sdi2,sdi1,sdi0};
                else
                    data_int_next = {data_int[30:0],sdi0};
        end
        else
        begin
            counter_next  = counter;
            data_ready    = 1'b0;
            data_int_next = data_int;
        end
    end


    always @(posedge sclk or posedge cs)
    begin
        if (cs == 1'b1)
        begin
            counter      = 0;
            counter_trgt = 'h1;
            data_int     = 'h0;
            running      = 'h1;
        end
        else
        begin
            counter      = counter_next;
            counter_trgt = counter_trgt_next;
            data_int     = data_int_next;
            running      = running_next;
        end
    end
endmodule