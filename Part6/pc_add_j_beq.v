/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 5 part 4
              pc_add_j_beq.v
Last Updated: Monday, May 29, 2023 8:40:37 PM
*/


module pc_add_j_beq (PC,INSTRUCTION,OFFSET,PCADDED);
    //declaring ports
    input [31:0] PC;
    input [31:0] INSTRUCTION;
    input [31:0] OFFSET;
    output reg [31:0] PCADDED;

    //always read INSTRUCTION
    always @(INSTRUCTION)   begin
        #2 PCADDED=PC+OFFSET;
    end

endmodule