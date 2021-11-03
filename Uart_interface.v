`timescale 10ns/10ns

module Uart_interface #(
        parameter DBIT = 8
    )
    (
        input   wire [DBIT-1:0] i_data,
        input   wire            rx_done,
        input   wire            reset,   
        input   wire            clk,
        input   wire            o_tx_done_tick,
        
        output  wire [DBIT-1:0] o_result,   //  Resultado de la ALU
        output  reg             tx_start
    );
    
    //  Estados
    localparam[1:0]
        esperando_op1        = 2'b00,   //  Esperando el primer operando
        esperando_op2        = 2'b01,   //  Esperando el segundo operando
        esperando_cod_op     = 2'b10,   //  Esperando el codigo de operacion
        procesando_resultado = 2'b11;   //  Realizando operacion pedida
        
    //  Declaracion de las se;ales auxiliares
    reg [1:0]      state_reg, state_next;
    reg [DBIT-1:0] op1_reg,   op1_next;
    reg [DBIT-1:0] op2_reg,   op2_next;
    reg [DBIT-1:0] ope_reg,   ope_next;
    
    //  Bloque de reset
    always @(posedge clk, posedge reset)
        if (reset)
            begin
                state_reg <=  esperando_op1;
                op1_reg   <= 0;
                op2_reg   <= 0;
                ope_reg   <= 0;
            end
        else
            begin
                state_reg <= state_next;
                op1_reg   <= op1_next;
                op2_reg   <= op2_next;
                ope_reg   <= ope_next;
            end

    //Bloque de logica del estado siguiente
    always @*
    begin
        state_next = state_reg;
        tx_start   = 1'b0;
        op1_next   = op1_reg;
        op2_next   = op2_reg;
        ope_next   = ope_reg;

        case (state_reg)
            esperando_op1:
                begin
                    if(rx_done)
                        begin
                            state_next = esperando_op2;
                            op1_next   = i_data;
                        end
                end
            esperando_op2:
                begin
                    if(rx_done)
                        begin
                            state_next = esperando_cod_op;
                            op2_next   = i_data;
                        end
                end
            esperando_cod_op:
                begin
                    if(rx_done)
                        begin
                            state_next = procesando_resultado;
                            ope_next   = i_data;
                        end
                end
            procesando_resultado:
                begin
                    tx_start = 1'b1;
                    if(o_tx_done_tick)
                        begin
                            state_next = esperando_op1;
                            tx_start   = 1'b0;
                        end
                end
        endcase
    end
    
    ALU
    #(
        .NBITS  (DBIT),
        .COD_OP (6)
    )   
    ALU
    (
        .operando_A    (op1_reg),
        .operando_B    (op2_reg),
        .cod_operacion (ope_reg),
        .ALU_Result    (o_result)
    );
    
endmodule
