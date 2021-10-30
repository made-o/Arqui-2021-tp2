`timescale 1ns / 1ps

module Modulo_Uart_Top#(
        parameter   DBIT        =   8           ,
        parameter   SB_TICK     =   16          ,
        parameter   DIV         =   163         ,
        parameter   SIZ         =   8           
    )
    (
        input   wire    i_clock ,   i_reset     ,
        
        // interface rx
        input   wire    i_data                  ,   //  Entrada del modulo
        
        //  interface tx
        output  wire    tx_done                 ,   //  Señal de finalizacion
        output  wire    o_result                    //  Resultado final
    );
    
    wire    rx_done ,   s_tick  ,   tx_start    ;
    wire    [DBIT-1:0]  data_line_rtoi          ;   //  Cable entre el receptor y la interfaz
    wire    [DBIT-1:0]  data_line_itot          ;   //  Cable entre la interfaz y el transmisor
    
    Baud_rate_generator  #(
        .N              (SIZ)                   ,
        .M              (DIV)
    )   tickGen     (
        .i_clk          (i_clock)               ,
        .i_reset        (i_reset)               ,
        .flag_max_tick     (s_tick)
    );
    
    RX_Uart         #(
        .D_BIT           (DBIT)                  ,
        .SB_TICK        (SB_TICK)
    )   receiver (
        .i_clk            (i_clock)               ,
        .i_reset          (i_reset)               ,
        .i_s_tick         (s_tick)                ,
        .o_data           (data_line_rtoi)        ,
        .o_rx_done_tick   (rx_done)               ,
        .i_rx             (i_data)
    );
    
    TX_Uart         #(
        .D_BIT           (DBIT)                  ,
        .SB_TICK        (SB_TICK)
    )   transmitter (
        .i_clk            (i_clock)               ,
        .i_reset          (i_reset)               ,
        .i_tx_start       (tx_start)              ,
        .i_s_tick         (s_tick)                ,
        .i_data            (data_line_itot)        ,
        .o_tx_done_tick        (tx_done)               ,
        .o_tx             (o_result)
    );
endmodule
