/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 6 part 2
              mux.v
Last Updated: Tuesday, May 23, 2023 4:00:11 PM
*/
module mux4to1(IN1, IN2, IN3, IN4, SELECT, OUT);
    input [7:0] IN1, IN2, IN3, IN4;  // 4 inputs
    input [1:0] SELECT;              // select bit input
    output reg [7:0] OUT;            // output

    always @*
    begin
        case (SELECT)
            2'b00: OUT = IN1;  // switch to IN1
            2'b01: OUT = IN2;  // switch to IN2
            2'b10: OUT = IN3;  // switch to IN3
            2'b11: OUT = IN4;  // switch to IN4
            default: OUT = 8'b0;  // default case
        endcase
    end
endmodule

