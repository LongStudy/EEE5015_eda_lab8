
module booth_mult#(parameter width=8)(
     input clk,
	 input rst_n,
	 
	 input [width-1:0]A,
	 input [width-1:0]B,
	 
	 output reg done,
	 output reg [2*width-1:0]M
);
	 
	 reg [1:0]					state;
	 reg [2*width-1:0]			mult_A;  // result of A
	 reg [width:0]				mult_B;  // result of A
	 reg [2*width-1:0]			inv_A;  // reverse result of A
	 reg  [2*width-1:0]			result_tmp;  // operation register 
	 wire [1:0]					booth_code;
	 assign booth_code = mult_B[1:0];
	 assign stop=(~|mult_B)||(&mult_B);

	 always @ ( posedge clk or negedge rst_n )
		if( !rst_n ) begin
			state <= 0;
			mult_A <= 0;
			inv_A <= 0;
			result_tmp  <= 0;
			done <= 0;
			M<=0;
		end
        else
            case( state )	
                0: begin 
                    mult_A <= {{width{A[width-1]}},A}; 
                    inv_A <= ~{{width{A[width-1]}},A} + 1'b1 ; 
                    result_tmp <= 0; 
                    mult_B <= {B,1'b0};
                    state <= state + 1'b1; 
                end
                1: begin
                    if(~stop) begin 
                        case(booth_code)
                            2'b01 : result_tmp <= result_tmp + mult_A;
                            2'b10 : result_tmp <= result_tmp + inv_A;
                            default: result_tmp <= result_tmp;
                        endcase 
                        mult_A <= {mult_A[14:0],1'b0};
                        inv_A <=  {inv_A[14:0],1'b0};
                        mult_B <= {mult_B[8],mult_B[8:1]};
                    end
                    else 
                        state <= state + 1'b1;
                end
                2:begin
                    done<=1'b1;
                    M<= result_tmp;
                    state <= state+1;
                end
                3: begin
                    done<=1'b0;
                    state<=0;
                end
            endcase
endmodule


