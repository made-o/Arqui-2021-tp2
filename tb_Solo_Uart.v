`timescale 10ns / 10ns

module tb_Solo_Uart();

    //local parameters
    localparam  DBIT        =       8       ;
    localparam  SBTICK      =       16      ;
    localparam  SIZ         =       8       ;
    localparam  DIV         =       163     ;
    //Inputs
    reg                 i_clock ,   i_reset ;
    reg                             i_data  ;
    wire                o_data  ,   tx_done ;
    
    initial begin
      i_clock           =   1'b0    ;
      i_reset           =   1'b1    ;
      #20
      i_data            =   1'b1    ;

      i_reset           =   1'b0    ;

      //DATO 1 = 8'h1
      #3250
      i_data            =   1'b1    ; //idle
      #50000
      i_data            =   1'b0    ; //Start
      #50000
      i_data            =   1'b1    ; //Data
      #50000
      i_data            =   1'b0    ;
      #50000
      i_data            =   1'b0    ;
      #50000
      i_data            =   1'b0    ;
      #50000
      i_data            =   1'b0    ;
      #50000
      i_data            =   1'b0    ;
      #50000
      i_data            =   1'b0    ;
      #50000
      i_data            =   1'b0    ;
      #50000
      i_data            =   1'b1    ;   //  Stop
      
      #50000
      i_data            =   1'b1    ;   //  Se pone la entrada en alto asi el receptor deja de recibir
      
     
      
      #25000000
      $display("#############     Test OK    ############");
      $finish();
    end // initial
    
    always begin
      #10
      i_clock       =   ~i_clock    ;
    end
    
    Modulo_Uart_Top
    #(
      .DBIT             (DBIT)      ,
      .SB_TICK          (SBTICK)    ,
      .DIV              (DIV)       ,
      .SIZ              (SIZ)    
    )
    u_uart
    (
      .i_clock          (i_clock)   ,
      .i_reset          (i_reset)   ,
      .i_data           (i_data)    ,
      .tx_done          (tx_done)   ,
      .o_result         (o_data)
    );
endmodule
