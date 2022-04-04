module multiplier_tb;
	reg [7:0] x,y; // 1 bit for sign + 7 bit for number
	wire [15:0] out; // 1 bit for sign + 14 bit for number
	
    multiplier u_multiplier(x,y,out);

    initial begin
        #4 x = 127; y = 127;
        #4 x = 127; y = -128;
        #4 x = -128; y = -128;
        #4 x = -1; y = 1;
        #4 x = 0; y = 1;
        #4 x = 1; y = 0;
        #4 x = 0; y = 0;
        #4 x = 1; y = 1;
    end


    initial begin
        #40 $finish;
    end

    initial begin
        $vcdpluson; 
    end

endmodule