module  SwAlloc3x1 (
    input   wire                clk,
    input   wire                rstn,

    input   wire                ValidA_i,
    input   wire    [31:0]      DataA_i,
    output  wire                ReadyA_o,

    input   wire                ValidB_i,
    input   wire    [31:0]      DataB_i,
    output  wire                ReadyB_o,

    input   wire                ValidC_i,
    input   wire    [31:0]      DataC_i,
    output  wire                ReadyC_o,

    input   wire                FifoFull_i,
    output  wire    [31:0]      FifoWrData_o,
    output  wire                FifoWr_o
);

wire    [1:0]   FlitTpye;

assign  FlitTpye    =   FifoWrData_o[31:30];

wire            HeadFlit,TailFlit;

assign  HeadFlit    =   FlitTpye    ==  2'b00;
assign  TailFlit    =   FlitTpye    ==  2'b11;

wire    [2:0]   Grant;

assign  Grant   =   ValidA_i    ?   3'b001  :   (
                    ValidB_i    ?   3'b010  :   (
                    ValidC_i    ?   3'b100  :   3'b000));

reg             Occupy = 1'b0;
reg     [2:0]   GrantReg = 3'b000;

always@(posedge clk or negedge rstn) begin
    if(~rstn) begin
        Occupy      <=  1'b0;
        GrantReg    <=  3'b000;
    end else begin 
        if(Occupy) begin
            if(FifoWr_o  &   TailFlit) begin
                Occupy      <=  1'b0;
            end
        end else begin
            if(FifoWr_o  &   HeadFlit) begin
                Occupy      <=  1'b1;
                GrantReg    <=  Grant;
            end
        end
    end
end
        
assign  FifoWr_o    =   ~FifoFull_i &   (
                        (ValidA_i   &   ((Occupy    &   GrantReg[0])    |   (~Occupy    &   Grant[0]))) |
                        (ValidB_i   &   ((Occupy    &   GrantReg[1])    |   (~Occupy    &   Grant[1]))) |
                        (ValidC_i   &   ((Occupy    &   GrantReg[2])    |   (~Occupy    &   Grant[2]))) );

assign  FifoWrData_o    =   (DataA_i    &   {32{(Occupy &   GrantReg[0])    |   (~Occupy    &   Grant[0])}})    |
                            (DataB_i    &   {32{(Occupy &   GrantReg[1])    |   (~Occupy    &   Grant[1])}})    |
                            (DataC_i    &   {32{(Occupy &   GrantReg[2])    |   (~Occupy    &   Grant[2])}})    ;


assign  ReadyA_o    =   ~FifoFull_i &   ((Occupy    &   GrantReg[0])    |   (~Occupy    &   Grant[0]));

assign  ReadyB_o    =   ~FifoFull_i &   ((Occupy    &   GrantReg[1])    |   (~Occupy    &   Grant[1]));

assign  ReadyC_o    =   ~FifoFull_i &   ((Occupy    &   GrantReg[2])    |   (~Occupy    &   Grant[2]));

endmodule
