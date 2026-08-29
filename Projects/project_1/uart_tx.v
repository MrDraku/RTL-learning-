module uart_tx #(parameter CLK_PER_BIT = 434 )  // 50 MHZ / 115200 baud  ~ 434
(
    //inputs
  input  wire  clk,
  input wire  reset,
  input  wire [7 : 0] tx_data,
  input  wire tx_start,

  // outputs 
  output reg tx_busy,
  output reg tx
);
//===============================================================
//FSM STATES 
//===============================================================
localparam IDEL  = 2'b00,
           START = 2'b01,
           DATA  = 2'b10,
           STOP  = 2'b11;

reg [1 : 0] state , next_state ;
//===============================================================
//  TX REGISTER  (data , shift -> 7 )
//===============================================================
reg [7 : 0] data_reg ;
reg [7 : 0] shift_reg ;
//===============================================================
// CONTERS -> baud_counter (16 bit ) & baud_bit (8 bit )
//===============================================================
reg [15 : 0 ] baud_counter ; // counte width for CLK_PER_BIT - 1 ( 434 - 1 = 433)
reg [ 2: 0 ] bit_counter ;   // 8 bit reg -> 8 bit counter  2^3 =8
wire baud_done = (baud_counter == CLK_PER_BIT -1);
//===============================================================
//FSM STATE REGISTER (SEQUENTIAL)
//===============================================================
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDEL ;
    end else begin
        state <= next_state ;
    end
end
//===============================================================
//FSM  NEXT STATE REGISTER (COMBINATIONAL)
//===============================================================
always @(*) begin
    next_state = state ;
    case (state)
    IDEL : begin
        if(tx_start)
         next_state = START ;
    end
    START : begin
        if (baud_done)
        next_state = DATA ;
    end
    DATA : begin
        if (baud_done && bit_counter == 3'd7)
            next_state = STOP ;
    end
    STOP : begin
        if (baud_done)
         next_state = IDEL ;
    end
    default :
    next_state = IDEL ;
    endcase
end
//===============================================================
//DATAPATH & REGISTER  ( sequential)
//===============================================================
always @(posedge clk or posedge reset) begin
    if(reset) begin
        data_reg     <= 8'b0 ;
        shift_reg    <= 8'b0 ;
        baud_counter <= 16'b0 ;
        bit_counter  <= 3'b0 ;
    end else begin
    case(state)
     IDEL :begin
         baud_counter <= 16'b0 ;
         bit_counter  <= 3'b0 ;
         if(tx_start)begin
            data_reg <= tx_data ;
         end
    end
    START :begin
        if(baud_done)begin
            baud_counter <= 16'b0 ;
            //  moving data_reg => shift_reg 
            shift_reg <= data_reg ;
        end
        else begin
            baud_counter <= baud_counter + 1 ;
        end
    end
    DATA : begin
        if(baud_done) begin
            baud_counter <= 16'b0 ;
            if (bit_counter != 3'd7) begin
                shift_reg <= shift_reg >> 1 ;
                bit_counter <= bit_counter + 1;
            end
        end else begin
            baud_counter <= baud_counter + 1;
        end
    end
    STOP : begin
        if(baud_done) begin
            baud_counter <= 16'b0 ;
        end else begin
            baud_counter <= baud_counter + 1;
        end
    end
    endcase
end
end 

//===============================================================
// OUTPUT LOGIC ( COMBINATIONAL)
//===============================================================
always @(*) begin
    case (state)
    IDEL :begin
        tx = 1'b1 ;
        tx_busy = 1'b0;
    end
    START : begin
        tx = 1'b0;
        tx_busy = 1'b1;
    end
    DATA : begin
        tx = shift_reg [0] ;
        tx_busy = 1'b1 ;
    end
    STOP : begin
        tx = 1'b1 ;
        tx_busy = 1'b1 ;
    end
    default : begin
        tx = 1'b1 ;
        tx_busy = 1'b0 ;
    end
    endcase
end
endmodule 