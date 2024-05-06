/*
Module  : Data Cache 
Author  : Isuru Nawinne, Kisaru Liyanage
Date    : 25/05/2020

Description	: Modified code 
*/
module dcache(
    // port declaration
    input clock,         // Clock signal
    input reset,         // Reset signal
    input read,          // Read signal
    input write,         // Write signal
    input [7:0] address, // Memory address
    input [31:0] writedata, // Data to be written
    output busywait,     // Busy wait signal
    input mem_Busywait,  // Memory busy wait signal
    input [2:0] Tag,     // Tag bits
    input [2:0] Tag1,    // Tag bits for write
    input [2:0] Index,   // Index bits
    input hit,           // Cache hit signal
    input dirty,         // Dirty bit signal
    output mem_read,     // Memory read signal
    output mem_write,    // Memory write signal
    output [31:0] mem_writedata, // Data to be written to memory
    output [5:0] mem_address    // Memory address
);
    reg [31:0] mem_writedata;    // Data to be written to memory
    reg [5:0] mem_address;       // Memory address
    reg mem_read, mem_write, busywait;
      
    /* dcache FSM Start */
    //        IDLE = not performing any operation, MEM_READ = Memory Read, MEM_WRITE = Memory Write
    parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010;
    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE:                                      // While in this state
                if ((read || write) && !dirty && !hit) // if not dirty and not hit and ( read signal or write signal )
                    next_state = MEM_READ;             // goto state -> MEM_READ 

                else if ((read || write) && dirty && !hit) // else if dirty and not hit and ( read signal or write signal )
                    next_state = MEM_WRITE;                // goto state -> MEM_WRITE

                else                                   // else
                    next_state = IDLE;                 // remain in IDLE state
            
            MEM_READ:                  // while in this state
                if (!mem_Busywait)     // if memory is signaling not busy 
                    next_state = IDLE; // remain idle
                else                       // else if memory is signaling busy
                    next_state = MEM_READ; // goto MEM_READ
            
            MEM_WRITE:                      // while in this state
                if (!mem_Busywait)          // if memory is signaling not busy
                    next_state = MEM_READ;  // goto MEM_READ
                else                        // else if memory is signaling busy
                    next_state = MEM_WRITE; // stay in MEM_WRITE
        endcase
    end

    // Combinational output logic
    always @(*) begin
        case(state)
            IDLE: begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 8'dx;        // Placeholder value for memory address
                mem_writedata = 8'dx;      // Placeholder value for data to be written
                busywait = 0;
            end
         
            MEM_READ: begin
                mem_read = 1;
                mem_write = 0;
                mem_address = {Tag, Index}; // Memory address based on tag and index bits
                mem_writedata = 32'dx;     // Placeholder value for data to be written
                busywait = 1;
            end

            MEM_WRITE: begin
                mem_read = 0;
                mem_write = 1;
                mem_address = {Tag1, Index}; // Memory address based on tag1 and index bits
                mem_writedata = writedata;   // Data to be written to memory
                busywait = 1;
            end
        endcase
    end

    // Sequential logic for state transitioning 
    always @(posedge clock, reset)
    begin
        if(reset)
            state = IDLE;
        else
            state = next_state;
    end
    /* dcache FSM End */
endmodule
