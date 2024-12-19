module eshelby_screen (
    input clk,
    input rstn,
    input timer,
    input mode,     // 0: search for next prime, 1: suspend 
    output [19:0] prime_num
);
    // sram
    reg [19:0] w_addr;
    reg  w_data;
    wire [19:0] r_addr;
    wire  r_data;
    
    blk_mem_gen_0 blk_ram(
        .clka(clk),
        .clkb(clk),
        .wea(1'b1),
        .addra(w_addr),
        .dina(w_data),
        .addrb(r_addr),
        .doutb(r_data)
    );

    reg [19:0] index_kill;
    reg [19:0] index_prime;
    reg [19:0] last_prime;
    wire [39:0] index_prime_square;
    localparam IS_PRIME = 1'b0;
    localparam NOT_PRIME = 1'b1;


    // state
    reg [2:0] state;
    localparam KILLER_STATE = 3'b000;
    localparam CHECK_PRIME_STATE = 3'b001;
    localparam READ_TO_CHECK_STATE = 3'b010;
    localparam INITIAL_STATE = 3'b011;
    localparam DONE_STATE = 3'b100;
    localparam WAITING_FOR_TWO_T_STATE = 3'b101;// 所有这些都要减少一个周期

    reg [2:0] output_state;
    localparam SEARCHING_NEXT_STATE=3'b000;
    localparam WAITING_FOR_OUTPUT_STATE=3'b001;
    localparam READ_TO_SEARCH_STATE=3'b010;
    localparam WAITING_FOR_PRIME_STATE=3'b011;
    // localparam WAITING_FOR_O_STATE

    reg [19:0] index_output;
    reg [19:0] prime_num_reg;
    assign prime_num=prime_num_reg;

    // arbiter
    reg [1:0] req;
    wire [1:0] prio;
    wire [1:0] ack;

    assign prio=(index_output<last_prime || state==DONE_STATE)?(2'b10):(2'b01);
    assign index_prime_square=index_prime*index_prime;
    assign r_addr=(ack==0)?(0):(ack[0])?(index_prime):(index_output);

    ArbPriority#(.N(2)) arbiter (
        .clk(clk),
        .rstn(rstn),
        .req_i(req),
        .prio(prio),
        .ack_i(ack),
        .req_o(),
        .ack_o(1'b1)
    );

    // assign r_addr=(ack==0)?(0):()

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            w_addr<=2;
            w_data<=IS_PRIME;
            // r_addr<=0;
            index_kill<=0;
            index_prime<=0;
            last_prime<=0;
            state<=INITIAL_STATE;
            req[0]<=0;
        end else begin
            case (state)
                INITIAL_STATE: begin
                    index_kill<=4;
                    index_prime<=2;
                    last_prime<=2;
                    w_addr<=2;
                    w_data<=IS_PRIME;
                    state<=KILLER_STATE;
                end
                KILLER_STATE: begin
                    if (index_kill<index_prime_square && index_kill<=999999) begin
                        index_kill<=index_prime_square;
                        state<=KILLER_STATE;
                    end else if (index_kill>=index_prime_square && index_kill<=999999) begin
                        w_addr<=index_kill;
                        w_data<=NOT_PRIME;
                        index_kill<=index_kill+index_prime;
                        state<=KILLER_STATE;
                    end else begin
                        state<=READ_TO_CHECK_STATE;
                        index_kill<=index_prime+1;
                        index_prime<=index_prime+1;
                        last_prime<=index_prime;
                        req[0]<=1'b1;
                    end
                end
                READ_TO_CHECK_STATE: begin
                    if (ack[0]&&~ack[1]) begin
                        // r_addr<=index_prime;
                        req[0]<=1'b0;
                        state<=WAITING_FOR_TWO_T_STATE;
                    end else begin
                        req[0]<=1'b1;
                        state<=READ_TO_CHECK_STATE;
                    end
                end
                CHECK_PRIME_STATE: begin
                    if (r_data==NOT_PRIME && index_prime<=999999) begin
                        index_prime<=index_prime+1;
                        state<=READ_TO_CHECK_STATE;
                    end else if (r_data==IS_PRIME && index_prime<=999999) begin
                        if (index_prime_square>999999) begin
                            state<=DONE_STATE;
                        end else begin
                            index_kill<=index_prime_square;
                            state<=KILLER_STATE;
                        end
                    end else begin
                        state<=DONE_STATE;
                    end
                end
                WAITING_FOR_TWO_T_STATE: begin
                    state<=CHECK_PRIME_STATE;
                end
                DONE_STATE: begin
                    state<=DONE_STATE;
                end
            endcase
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            index_output<=2;
            req[1]<=0;
            output_state<=READ_TO_SEARCH_STATE;
        end else begin
            case (output_state)
                READ_TO_SEARCH_STATE: begin
                    if (ack[1]&&~ack[0]) begin
                        // r_addr<=index_output;
                        req[1]<=1'b0;
                        output_state<=WAITING_FOR_TWO_T_STATE;
                    end else begin
                        req[1]<=1'b1;
                        output_state<=READ_TO_SEARCH_STATE;
                    end
                end
                SEARCHING_NEXT_STATE: begin
                    if (r_data==NOT_PRIME && (index_output<last_prime || state==DONE_STATE)) begin 
                        index_output<=index_output+1;
                        output_state<=READ_TO_SEARCH_STATE;
                    end else if (r_data==IS_PRIME && (index_output<last_prime || state==DONE_STATE)) begin
                        output_state<=WAITING_FOR_OUTPUT_STATE;
                    end else begin
                        output_state<=WAITING_FOR_PRIME_STATE;
                    end
                end
                WAITING_FOR_OUTPUT_STATE: begin
                    if(prime_num==index_output && mode) begin
                        output_state<=READ_TO_SEARCH_STATE;
                        index_output<=index_output+1;
                        req[1]<=1'b1;
                    end else begin
                        output_state<=WAITING_FOR_OUTPUT_STATE;
                    end
                end
                WAITING_FOR_PRIME_STATE: begin
                    if (index_output<last_prime || state==DONE_STATE) begin
                        req[1]<=1'b1;
                        output_state<=READ_TO_SEARCH_STATE;
                    end else begin
                        output_state<=WAITING_FOR_PRIME_STATE;
                    end
                end
                WAITING_FOR_TWO_T_STATE: begin
                    output_state<=SEARCHING_NEXT_STATE;
                end
            
            endcase
        end
    end

    always @(posedge timer or negedge rstn) begin
        if (~rstn) begin
            prime_num_reg<=2;
        end else begin
            if (output_state==WAITING_FOR_OUTPUT_STATE) begin
                prime_num_reg<=index_output;
            end
        end
    end

endmodule