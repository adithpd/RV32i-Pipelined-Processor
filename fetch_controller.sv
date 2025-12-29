module fetch_controller#(
    parameter CACHE_SWITCH = 1'b0,
)(
    input   logic   clk,                        
    input   logic   fetch_enable,               // From Testbench
    input   logic   instr_cache_processing,     // From instruction_cache_controller
    input   logic   fetch_stall_external,       // From decode_controller

    output  logic   decode_enable,              // To decode_controller

    output  logic   fetch_stall_control,        // To fetch_datapath
    output  logic   fetch_enable_control        // To fetch_datapath
);
    // FSM State Definition
    typedef enum logic { IDLE, FETCH } state_t;
    state_t state, next_state;

    // Fetch Stall Latch
    logic fetch_stall_internal;
    assign fetch_stall_internal = (instr_cache_processing);

    // Control Signal Assignments
    assign fetch_stall_control = (fetch_stall_internal) || (fetch_stall_external);
    assign fetch_enable_control = fetch_enable;

    // Decode Enable Assignment
    assign decode_enable = (state == FETCH) && (!fetch_stall_internal && !fetch_stall_external);
    
    // State Transition Logic
    always_comb begin
        // Preventing unintentional latches
        next_state = state;

        // FSM Transition Conditions
        case(state)
            IDLE: begin
                if(fetch_enable)
                    next_state = FETCH;
            end

            FETCH: begin
                if(fetch_stall_internal || fetch_stall_external || fetch_enable)
                    next_state = FETCH;
                else
                    next_state = IDLE;
            end
        endcase
    end

    // State Transition 
    always @(posedge clk) begin
        if(!reset_n) 
            state <= IDLE;
        else 
            state <= next_state;
    end
endmodule