/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 5 part 4
              sign_extend.v
Last Updated: Tuesday, May 30, 2023 8:14:30 PM
*/

module sign_extend(IN,OUT);
    //declaring ports
    input [7:0] IN;
    output reg [31:0] OUT;

    //always block to offset
    always @(IN) begin
        OUT={{24{IN[7]}},IN};
    end
endmodule