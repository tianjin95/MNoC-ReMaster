module  RoutCalc (
    input   wire                clk,
    input   wire                rstn,

    input   wire    [31:0]      Data_i,
    input   wire                Valid_i,
    output  wire                Ready_o,

    output  wire    [31:0]      DataA_o,
    output  wire                ValidA_o,
    input   wire                ReadyA_i,

    output  wire    [31:0]      DataB_o,
    output  wire                ValidB_o,
    input   wire                ReadyB_i
);

wire    [1:0]   FlitType;

assign  FlitType    =   Data_i[31:30];

wire            SensorType;

assign  SensorType  =   Data_i[29];

wire            HeadFlit;

assign  HeadFlit    =   FlitType    ==  2'b00;

reg     [1:0]   Dir = 2'b00;

always@(posedge clk or negedge rstn) begin
    if(~rstn) 
        Dir <=  2'b00;
    else if(HeadFlit & Valid_i)
        Dir <=  {SensorType,~SensorType};
end

assign  ValidA_o    =   Valid_i &   (HeadFlit    ?   ~SensorType :   Dir[0]);
assign  ValidB_o    =   Valid_i &   (HeadFlit    ?   SensorType  :   Dir[1]);
assign  DataA_o     =   Data_i;
assign  DataB_o     =   Data_i;
assign  Ready_o     =   (ValidA_o   &   ReadyA_i)   |
                        (ValidB_o   &   ReadyB_i)   ;

endmodule