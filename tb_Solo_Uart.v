`timescale 10ns / 10ns

module tb_Solo_Uart();

    //local parameters
    localparam  DBIT        =       8       ;
    localparam  SBTICK      =       16      ;
    localparam  SIZ         =       8       ;
    localparam  DIV         =       163     ;
    //Inputs
    reg                 i_clock ,   i_reset ;
    
    wire                 tx_p1_to_p2 ,rx_p1_to_p2  ;
    //wire                o_data  ;
    
    wire                 tx_p2_to_p1, rx_p2_to_p1  ;
    //wire                o_data ;
    reg p1_tx_start;
    wire tx_done_p1,tx_done_p2;
    
    wire [DBIT-1:0] data_line_rtoi;
    reg [DBIT-1:0] data_line_itoi;
    
    initial begin
      i_clock           =   1'b0    ;
      i_reset           =   1'b1    ;
      #20

      i_reset           =   1'b0    ;

      //DATO 1 = 8'h1
      
      data_line_itoi = 8'b00011011;
      #10
      p1_tx_start = 1'b1; 
     
      
      #25000000
      
      if(data_line_rtoi != data_line_itoi)
      begin
            $display("%c[2;31m",27);
            $display("#############     Test ERROR    ############");
            $display("%c[0m",27);
            $finish();
      end
      
      $display("%c[2;34m",27);
      $display("#############     Test OK    ############");
      $display("%c[0m",27);
      $finish();
    end // initial
    
    always begin
      #10
      i_clock       =   ~i_clock    ;
    end
    
    always @(posedge i_clock) begin
        if(tx_done_p1)begin
            p1_tx_start = 1'b0;
        end
    end
    
    Modulo_Uart_Top
    #(
      .DBIT             (DBIT)      ,
      .SB_TICK          (SBTICK)    ,
      .DIV              (DIV)       ,
      .SIZ              (SIZ)    
    )
    p1
    (
      .data_line_itot   (data_line_itoi),
      .data_line_rtoi   (8'b00000000),
      .tx_start         (p1_tx_start),//este transmite
      .i_clock          (i_clock)   ,
      .i_reset          (i_reset)   ,
      .i_data           (rx_p1_to_p2)    ,//rx
      .tx_done          (tx_done_p1)   ,
      .o_result         (tx_p1_to_p2)     //tx
    );
    
     Modulo_Uart_Top
    #(
      .DBIT             (DBIT)      ,
      .SB_TICK          (SBTICK)    ,
      .DIV              (DIV)       ,
      .SIZ              (SIZ)    
    )
    p2
    (
      .data_line_itot   (8'b00000000),
      .data_line_rtoi   (data_line_rtoi),
      .tx_start         (1'b0),//no transmite
      .i_clock          (i_clock)   ,
      .i_reset          (i_reset)   ,
      .i_data           (tx_p1_to_p2)    ,//rx
      .tx_done          (tx_done_p2)   ,
      .o_result         (rx_p1_to_p2)     //tx
    );
endmodule
