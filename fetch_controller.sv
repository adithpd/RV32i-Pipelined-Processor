module fetch_controller#(
    parameter CACHE_SWITCH = 1'b0,
)(
    input logic clk
    output logic i_mem_din,
    output logic decode_enable,
    input logic decode_stall,
    output logic memory_control,
    output logic i_mem_fetch_done_control,
    output logic fetch_stall_control,
    output logic fetch_busy_control
);
    // fetch_busy and fetch_stall Latches
    logic fetch_busy, fetch_stall, i_mem_fetch_done;

    // Control Signal Assignments
    assign i_mem_fetch_done_control = i_mem_fetch_done;
    assign fetch_stall_control = fetch_stall;
    assign fetch_busy_control = fetch_busy;

    // FSM State Definition
    typedef enum logic { READY, CHECK_CACHE, FETCH_FROM_MEMORY } state_t;
    state_t state, next_state;

    // State Transition Logic
    always_comb begin
        // Preventing unintentional latches
        next_state = state;
        fetch_busy = 1'b0;
        fetch_stall = 1'b0;
        i_mem_fetch_done = 1'b0;
        decode_enable = 1'b0;


        // FSM Transition Conditions
        case(state)
            READY: begin
                if(!fetch_busy && !fetch_stall)
                    next_state = CHECK_CACHE;
            end

            CHECK_CACHE: begin
                if(!CACHE_SWITCH)
                    next_state = FETCH_FROM_MEMORY;
            end

            FETCH_FROM_MEMORY: begin
                // Memory modelled by Behavioral Testbench
                // --->
                i_mem_fetch_done = 1'b1;
                if(i_mem_fetch_done && !decode_stall) begin
                    decode_enable = 1'b1;
                    next_state = READY;
                end
            end

        endcase
    end

    assign fetch_busy = (state != READY);
    assign fetch_stall = (state != READY);

    // State Transition 
    always @(posedge clk) begin
        if(!reset_n) 
            state <= READY;
        else 
            state <= next_state;
    end
endmodule