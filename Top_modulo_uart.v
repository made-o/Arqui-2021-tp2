`timescale 1ns / 1ps

module Top_modulo_uart#(
        parameter   DBIT    =   8,
        parameter   SBTICK =   16,
        parameter   DIV     =   163,
        parameter   SIZ     =   8           
 )(  
        input   wire i_clock, 
        input   wire i_reset,
        
        // interface rx
        input   wire i_data,   //  Entrada del modulo
        output  wire rx_done,
        //  interface tx
        output  wire    tx_done_tx,  //Señal de finalizacion
        output  wire    o_data  //  Resultado final
  );
    wire    cable_transmicion;
    wire    cable_recepcion;
    
    wire tx_done_modulo;
    
    wire [DBIT-1:0] dato_recibido;
    reg  [DBIT-1:0] dato_tranmitido;
    
    wire s_tick;
    reg  tx_start;
    
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
