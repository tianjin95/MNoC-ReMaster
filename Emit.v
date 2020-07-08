module  Emit    (
    input   wire                    clk,
    input   wire                    rstn,

    input   wire                    FifoAEmpty_i,
    input   wire    [31:0]          FifoAData_i,
    output  wire                    FifoARead_o,

    input   wire                    FifoBEmpty_i,
    input   wire    [31:0]          FifoBData_i,
    output  wire                    FifoBRead_o,

    output  wire                    Valid_o,
    output  wire    [31:0]          Data_o,
    input   wire                    Ready_i
);

wire            Fire;

assign  Fire    =   Valid_o &   Ready_i;

wire    [1:0]   FlitTpye;

assign  FlitTpye    =   Data_o[31:30];

wire            HeadFlit,TailFlit;

assign  HeadFlit    =   FlitTpye    ==  2'b00;
assign  TailFlit    =   FlitTpye    ==  2'b11;

wire    [1:0]   Grant;

assign  Grant   =   ~FifoAEmpty_i   ?   2'b01   :   (
                    ~FifoBEmpty_i   ?   2'b10   :   2'b00);

reg             Occupy = 1'b0;
reg     [1:0]   GrantReg = 2'b00;

always@(posedge clk or negedge rstn) begin
    if(~rstn) begin
        Occupy      <=  1'b0;
        GrantReg    <=  2'b00;
    end else begin 
        if(Occupy) begin
            if(Fire  &   TailFlit) begin
                Occupy      <=  1'b0;
            end
        end else begin
            if(Fire  &   HeadFlit) begin
                Occupy      <=  1'b1;
                GrantReg    <=  Grant;
            end
        end
    end
end

assign  Data_o  =   (FifoAData_i    &   {32{(Occupy &   GrantReg[0])    |   (~Occupy    &   Grant[0])}})    |
                    (FifoBData_i    &   {32{(Occupy &   GrantReg[1])    |   (~Occupy    &   Grant[1])}})    ;

assign  Valid_o =   (~FifoAEmpty_i  &   ((Occupy    &   GrantReg[0])    |   (~Occupy    &   Grant[0]))) |
                    (~FifoBEmpty_i  &   ((Occupy    &   GrantReg[1])    |   (~Occupy    &   Grant[1]))) ;

assign  FifoARead_o =   Ready_i &   ~FifoAEmpty_i   &   ((Occupy    &   GrantReg[0])    |   (~Occupy    &   Grant[0]));

assign  FifoBRead_o =   Ready_i &   ~FifoBEmpty_i   &   ((Occupy    &   GrantReg[1])    |   (~Occupy    &   Grant[1]));

endmodule
                    