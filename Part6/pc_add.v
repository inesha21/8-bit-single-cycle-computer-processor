/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 5 part 3
              pc.v
Last Updated: Sunday, May 28, 2023 2:54:54 PM
*/

// tested - working properly
module pc_add(PC,PCADDED); 
    

    // declaring ports
    input [31:0] PC;    //initial PC value
    output reg [31:0] PCADDED;  //final PC value

    always @(PC) begin
    // assign PC_value +1 with 1 s  artificial delay
        #1 PCADDED=PC+4;
    end

endmodule
