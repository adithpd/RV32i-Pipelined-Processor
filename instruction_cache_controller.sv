// module instruction_cache_controller(
//     input logic clk,
//     input logic instr_cache_enable,
//     output logic instr_cache_processing
// );
//     typedef enum logic { LOOKUP } state_t;

//     // State Transition Logic
//     always_comb begin
//         // Preventing unintentional latches
//         next_state = state;

//         // FSM Transition Conditions
//         case(state)
//             LOOKUP: begin
//                 if(instr_cache_processing || instr_cache_enable)
//                     next_state = LOOKUP;
//             end
//         endcase
//     end

//     // State Transition 
//     always @(posedge clk) begin
//         if(!reset_n) 
//             state <= LOOKUP;
//         else 
//             state <= next_state;
//     end
// endmodule