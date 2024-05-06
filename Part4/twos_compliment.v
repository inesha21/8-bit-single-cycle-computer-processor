/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 5 part 3
              twos_compliment.v
Last Updated: Tuesday, May 23, 2023 4:25:00 PM
*/

module twos_compliment(IN,OUT);
    // declaring ports
    input [7:0] IN;
    output [7:0] OUT;

    // 2's complement operation
        //adding artificial delay of 1 second
        // Out = (fipping the bits in IN) + 1
    assign #1 OUT =(~IN)+1;

endmodule



/*

//test twos_compliment
module stimulus;

    reg [7:0] IN;
    wire [7:0] OUT;

    twos_compliment test_tc(IN,OUT);

    initial begin
        IN=8'b00001111;
        #5
        $display("%b",OUT);

    end
endmodule 
*/