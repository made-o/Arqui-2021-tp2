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
    
    wire s_tick;
    reg  tx_start;
    
    wire rx_done;
    
    wire rx;
    reg rx_next;
    
    wire tx;
    reg [7:0] n_clocks = 0;
    reg [3:0] n_ticks  = 4'b0111;
    
    initial 
    begin
      i_clock           =   1'b0    ;
      i_reset           =   1'b1    ;
      #20

      i_reset           =   1'b0    ;

      // transmito a (20)
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b1;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b1;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b1;
      #522160
      
      // transmito b (7)
      rx_next = 1'b0;
      #522160
      rx_next = 1'b1;
      #522160
      rx_next = 1'b1;
      #522160
      rx_next = 1'b1;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b1;
      #522160
      
      // transmito codigo de operacion (30)
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b1;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b0;
      #522160
      rx_next = 1'b1;
      
     end // initial
     
     assign rx = rx_next;
     
     always @(posedge i_clock)begin
        if(~tx)
        begin
            if(n_clocks >= 163)
            begin
                if(n_ticks >= 15)
                begin
                    dato_tranmitido = {tx, dato_tranmitido[7:1]};
                    n_ticks = {4{1'b0}};
                end
                else
                begin
                    n_ticks = n_ticks+1;
                end
                n_clocks = {8{1'b0}};
            end
            else
            begin
                n_clocks = n_clocks+1;
            end
        end
        else
        dato_tranmitido = 0;
     end
    
    always begin
      #10
      i_clock = ~i_clock;
    end
    
    always @(posedge i_clock)begin
        if(rx_done == 1'b1)
        begin
            if(dato_tranmitido == 8'b00011011)
            begin
                  $display("#############     Test OK    ############");
                  $finish();
            end
            else
            begin
                $display("#############     Test ERROR    ############");
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
      .i_data           (rx),    //rx
      .tx_done          (tx_done),
      .o_result         (tx)     //tx
    );

endmodule
