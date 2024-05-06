/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 5 part 4
              shift.v
Last Updated: Tuesday, May 30, 2023 8:19:49 PM
*/

module shift(OFFSET,SHIFTED_OFFSET);
    //declaring ports 
    input [31:0]   OFFSET;
    output reg [31:0]   SHIFTED_OFFSET;

    //always block
    always @(OFFSET) begin
        SHIFTED_OFFSET=OFFSET<<2;
    end
endmodule