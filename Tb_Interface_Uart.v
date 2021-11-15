`timescale 10ns / 10ns

module Tb_Interface_Uart();
    //local parameters
    localparam  DBIT        =       8       ;
    localparam  SBTICK      =       16      ;
    localparam  SIZ         =       8       ;
    localparam  DIV         =       163     ;
    //Inputs
    reg                 i_clock ,   i_reset ;
    
    wire tx_done;
    
    reg  [DBIT-1:0] dato_tranmitido;
    wire  [DBIT-1:0] dato_recibido;
    
    wire s_tick;
    
    wire rx_done;
    
    wire rx;
    reg rx_next;
    
    wire tx;
    
    initial 
    begin
      rx_next           =   1'b1;
      i_clock           =   1'b0;
      i_reset           =   1'b1;
      #20

      i_reset           =   1'b0;

      // transmito A (20)
      rx_next = 1'b0;
        #52216 // (163 * 16 * 2) → (mod-163 * 16 de sobremuestreo * 2 ciclo reloj)
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b1;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b1;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b1;
      #52216
      
      // transmito b (7)
      rx_next = 1'b0;
      #52216
      rx_next = 1'b1;
      #52216
      rx_next = 1'b1;
      #52216
      rx_next = 1'b1;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b1;
      #52216
      
      // transmito codigo de operacion (30)
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b1;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b0;
      #52216
      rx_next = 1'b1;
      
      #522160
      
      $display("#############     Test Finalizado    ############");
      $finish();

     end // initial
     
     assign rx = rx_next;
     
    always begin
      #10 // Un período cada #20
      i_clock = ~i_clock;
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
      .i_clock          (i_clock),
      .i_reset          (i_reset),
      .i_data           (rx),    //rx
      .tx_done          (tx_done),
      .o_result         (tx)     //tx
    );

endmodule
