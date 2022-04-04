
module tb_multi_seq();

	parameter width=8;
    reg clk;
	reg rst_n;
	reg en,
	 
    reg [width-1:0]A;
    reg [width-1:0]B;

    wire done;
    wire [2*width-1:0]M;

   	parameter CLK_PERIOD = 20;
    initial begin
        clk = 0;
        forever begin
            #(CLK_PERIOD/2) clk = ~clk;
        end
    end
	
    initial begin      
        rst_n = 0;
		#10;
		rst_n = 1;
	end

	booth_mult#(.width(8)) 
	U1 (
		.clk(clk),
		.rst_n(rst_n),
		.en(en),
		.A(A),
		.B(B),
		.done(done),
		.M(M)
	);

    always @ (posedge rst_n or negedge rst_n) begin
        if (!rst_n) begin
        $display("%t:%m: resetting ......", $time); 
        end
        else begin
        $display("%t:%m: resetting finish", $time); 
        end
    end

  initial begin
    		A = 0; B = 0; en = 0;
    #200	A = 1; B = 1; en = 1;
	#100	en = 0;
    #200	A = 1; B = -1; en = 1;
	#100	en = 0;
    #200	A = -1; B = -1; en = 1;
	#100	en = 0;
	#200	A = -10; B = -100; en = 1;
	#100	en = 0;
	#200	A = 10; B = -5; en = 1;
	#100	en = 0;
	#200	A = 5; B = 8; en = 1;
	#100	en = 0;
	#200	A = -128; B = -128; en = 1;
	#100	en = 0;
	#200	A = -128; B = 127; en = 1;
	#100	en = 0;
	#200	A = 100; B = 127; en = 1;
	#100	en = 0;
			$finish;
  end

  initial begin
    $monitor("@ time=%0t,  A=%d, B=%d, M=%d",$time, A, B, M);
  end

  initial begin
    #450   if (M != 0) $display("Error: for M=%d", M);
    #300   if (M != 1) $display("Error: for M=%d", M);
	#300   if (M != -1) $display("Error: for M=%d", M);
	#300   if (M != 1) $display("Error: for M=%d", M);
	#300   if (M != 1000) $display("Error: for M=%d", M);
	#300   if (M != -50) $display("Error: for M=%d", M);
	#300   if (M != 40) $display("Error: for M=%d", M);
	#300   if (M != 16384) $display("Error: for M=%d", M);
	#300   if (M != -16256) $display("Error: for M=%d", M);
	#300   if (M != 12700) $display("Error: for M=%d", M);
  end


    initial begin
        $vcdpluson; 
    end
 endmodule

