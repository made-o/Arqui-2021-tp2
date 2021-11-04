`timescale 10ns / 10ns

module Tb_Interface_Uart();
    //local parameters
    localparam  DBIT        =       8       ;
    localparam  SBTICK      =       16      ;
    localparam  SIZ         =       8       ;
    localparam  DIV         =       163     ;
    //Inputs
    reg                 i_clock ,   i_reset ;
    
    wire                 tx_p1_to_p2 ,rx_p1_to_p2  ;
    //wire                o_data  ;
    wire    cable_transmicion;
    wire    cable_recepcion;
    
    //wire                o_data ;
    
    wire tx_done_modulo;
    wire tx_done_tx;
    
    wire [DBIT-1:0] dato_recibido;
    reg  [DBIT-1:0] dato_tranmitido;
    
    wire s_tick;
    reg  tx_start;
    
    wire rx_done;
    
    initial 
    begin
      i_clock           =   1'b0    ;
      i_reset           =   1'b1    ;
      #20

      i_reset           =   1'b0    ;

      // transmito a
      dato_tranmitido = 8'b00010100;
      #10
      tx_start = 1'b1;
      #600000
      
      // transmito b
      dato_tranmitido = 8'b00000111;
      #10
      tx_start = 1'b1;
      #600000
      
      // transmito codigo de operacion
      dato_tranmitido = 8'b00100000;
      #10
      tx_start = 1'b1;
      
     end // initial
    
    always begin
      #10
      i_clock = ~i_clock;
    end
    
    always @(posedge i_clock) begin
        if(tx_done_tx)begin
            tx_start = 1'b0;
        end
    end
    
    always @(posedge i_clock)begin
        if(rx_done == 1'b1)
        begin
            if(dato_recibido == 8'b00011011)
            begin
                  $display("%c[2;34m",27);
                  $display("#############     Test OK    ############");
                  $display("%c[0m",27);
                  $finish();
            end
            else
            begin
                $display("%c[2;31m",27);
                $display("#############     Test ERROR    ############");
                $display("%c[0m",27);
                $finish();
            end
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
      .i_clock          (i_clock),
      .i_reset          (i_reset),
      .i_data           (cable_transmicion),    //rx
      .tx_done          (tx_done_modulo),
      .o_result         (cable_recepcion)     //tx
    );
    
    
    TX_Uart         #(
        .D_BIT           (DBIT),
        .SB_TICK        (SBTICK)
    )   transmitter (
        .i_clk          (i_clock),
        .i_reset        (i_reset),
        .i_tx_start     (tx_start),
        .i_s_tick       (s_tick),
        .i_data         (dato_tranmitido), //8-bits que se van a enviar
        .o_tx_done_tick (tx_done_tx),
        .o_tx           (cable_transmicion) //tx
    );
    
    RX_Uart         #(
        .D_BIT           (DBIT),
        .SB_TICK        (SBTICK)
    )   receiver (
        .i_clk            (i_clock),
        .i_reset          (i_reset),
        .i_s_tick         (s_tick),
        .o_data           (dato_recibido),    //8-bits recibidos
        .o_rx_done_tick   (rx_done),
        .i_rx             (cable_recepcion)   // rx
    );
    
    
    Baud_rate_generator  #(
        .N              (SIZ),
        .M              (DIV)
    )   tickGen     (
        .i_clk          (i_clock),
        .i_reset        (i_reset),
        .flag_max_tick  (s_tick)
    );
    

endmodule
