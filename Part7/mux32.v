/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 5 part 4
              mux32.v
Last Updated: Wednesday, May 31, 2023 2:56:49 AM
*/

module mux32(IN1,IN2,OUT,SELECT);
    input [31:0] IN1, IN2;
	input SELECT;
	output reg [31:0] OUT;

    always @(*) begin 
        if (SELECT) begin 
            OUT = IN2; 
        end 

        else OUT = IN1;  
    end	
endmodule