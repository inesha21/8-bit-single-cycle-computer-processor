/*
Authers     : WIJERATHNA I.M.K.D.I.     e19446@eng.pdn.ac.lk
              DISSANAYAKE D.M.I.G.      e19090@eng.pdn.ac.lk
Lab         : Lab 5 part 3
              mux.v
Last Updated: Tuesday, May 23, 2023 4:00:11 PM
*/

//tested - working properly
module mux(IN1,IN2,SELECT,OUT);

    //declaring ports
    input [7:0] IN1, IN2;   // 2 inputs
    input SELECT;           // select bit input
    output reg [7:0] OUT;   // output

    // always taking inputs and updating the regarding output accordingly
    always @(IN1,IN2,SELECT)

    begin
        //if select bit is low
        if (SELECT==1'b0)
            begin
                assign OUT = IN1;  //switch to IN1
            end
        // else select bit is high
        else
            begin
                assign OUT = IN2;  //switch to IN2
            end
    end

endmodule

/*

//test mux 
module stimulus;
    
    reg [7:0] IN1, IN2;   // 2 inputs
    reg SELECT;           // select bit input
    wire [7:0] OUT;        // output


    //calling mux module
    mux testmux(IN1,IN2,SELECT,OUT);

    initial begin
        IN1=8'b00001000;
        IN2=8'b00000001;
        SELECT=1'b1;
        
        $monitor("%d",OUT);

        #5
        SELECT=1'b0;
        #5
        SELECT=1'b1;
        

    end
endmodule


*/