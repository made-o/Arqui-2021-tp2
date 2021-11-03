`timescale 1ns / 1ps

// Definicion de Macros para manipular mejor las operaciones:
`define ADD  6'b100000  // Salida-> A + B
`define	SUB  6'b100010	// Salida-> A - B
`define	AND  6'b100100	// Salida-> A and B
`define	OR   6'b100101	// Salida-> A or B
`define	XOR  6'b100110	// Salida-> A nor B
`define	SRA  6'b000011	// Salida-> A,B >>> 
`define	SRL  6'b000010	// Salida-> A,B >>
`define	NOR  6'b100111 	// Salida-> A nor B


module ALU
#( // Parámetros:
     parameter   NBITS = 8,
     parameter   COD_OP = 6
)
 (
     // Entradas:
     input wire [NBITS-1:0]  operando_A,    // registro A
     input wire [NBITS-1:0]  operando_B,    // registro B
     input wire [COD_OP-1:0] cod_operacion, // la operación a realizar
    
     // Salidas:
     output reg [NBITS-1:0]  ALU_Result // ALU Output        
);
    
    always @(*)
	begin : operaciones
        case(cod_operacion)
            `ADD : ALU_Result = operando_A + operando_B;
	        `SUB : ALU_Result = operando_A - operando_B;
            `AND : ALU_Result = operando_A & operando_B;
            `OR  : ALU_Result = operando_A | operando_B;
            `XOR : ALU_Result = operando_A ^ operando_B;
            `SRA : ALU_Result = operando_A >>> operando_B;
			`SRL : ALU_Result = operando_A >> operando_B;
			`NOR : ALU_Result = ~(operando_A | operando_B);
            default  :   ALU_Result   =   {NBITS{1'b1}};
        endcase
	end

endmodule//alu_module
