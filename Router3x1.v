module  Router3x1   (
    input   wire                    clk,
    input   wire                    rstn,

    input   wire    [31:0]          DataA_i,
    input   wire                    ValidA_i,
    output  wire                    ReadyA_o,

    input   wire    [31:0]          DataB_i,
    input   wire                    ValidB_i,
    output  wire                    ReadyB_o,

    input   wire    [31:0]          DataC_i,
    input   wire                    ValidC_i,
    output  wire                    ReadyC_o,

    output  wire    [31:0]          Data_o,
    output  wire                    Valid_o,
    input   wire                    Ready_i
);

wire    [31:0]  DataAA;
wire            ValidAA;
wire            ReadyAA;

wire    [31:0]  DataAB;
wire            ValidAB;
wire            ReadyAB;

wire    [31:0]  DataBA;
wire            ValidBA;
wire            ReadyBA;

wire    [31:0]  DataBB;
wire            ValidBB;
wire            ReadyBB;

wire    [31:0]  DataCA;
wire            ValidCA;
wire            ReadyCA;

wire    [31:0]  DataCB;
wire            ValidCB;
wire            ReadyCB;


//  PortA Regular
//  PortB Priority

RoutCalc    InstRCA(
    .clk                (clk),
    .rstn               (rstn),
    .Data_i             (DataA_i),
    .Valid_i            (ValidA_i),
    .Ready_o            (ReadyA_o),
    .DataA_o            (DataAA),
    .ValidA_o           (ValidAA),
    .ReadyA_i           (ReadyAA),
    .DataB_o            (DataAB),
    .ValidB_o           (ValidAB),
    .ReadyB_i           (ReadyAB)
);

RoutCalc    InstRCB(
    .clk                (clk),
    .rstn               (rstn),
    .Data_i             (DataB_i),
    .Valid_i            (ValidB_i),
    .Ready_o            (ReadyB_o),
    .DataA_o            (DataBA),
    .ValidA_o           (ValidBA),
    .ReadyA_i           (ReadyBA),
    .DataB_o            (DataBB),
    .ValidB_o           (ValidBB),
    .ReadyB_i           (ReadyBB)
);

RoutCalc    InstRCC(
    .clk                (clk),
    .rstn               (rstn),
    .Data_i             (DataC_i),
    .Valid_i            (ValidC_i),
    .Ready_o            (ReadyC_o),
    .DataA_o            (DataCA),
    .ValidA_o           (ValidCA),
    .ReadyA_i           (ReadyCA),
    .DataB_o            (DataCB),
    .ValidB_o           (ValidCB),
    .ReadyB_i           (ReadyCB)
);    

//  FifoA Regular
wire            FifoAFull;
wire    [31:0]  FifoAWrData;
wire            FifoAWr;

//  FifoB Priority
wire            FifoBFull;
wire    [31:0]  FifoBWrData;
wire            FifoBWr;

SwAlloc3x1 InstSAA(
    .clk                (clk),
    .rstn               (rstn),
    .ValidA_i           (ValidAA),
    .DataA_i            (DataAA),
    .ReadyA_o           (ReadyAA),
    .ValidB_i           (ValidBA),
    .DataB_i            (DataBA),
    .ReadyB_o           (ReadyBA),
    .ValidC_i           (ValidCA),
    .DataC_i            (DataCA),
    .ReadyC_o           (ReadyCA),
    .FifoFull_i         (FifoAFull),
    .FifoWrData_o       (FifoAWrData),
    .FifoWr_o           (FifoAWr)
);

SwAlloc3x1 InstSAB(
    .clk                (clk),
    .rstn               (rstn),
    .ValidA_i           (ValidAB),
    .DataA_i            (DataAB),
    .ReadyA_o           (ReadyAB),
    .ValidB_i           (ValidBB),
    .DataB_i            (DataBB),
    .ReadyB_o           (ReadyBB),
    .ValidC_i           (ValidCB),
    .DataC_i            (DataCB),
    .ReadyC_o           (ReadyCB),
    .FifoFull_i         (FifoBFull),
    .FifoWrData_o       (FifoBWrData),
    .FifoWr_o           (FifoBWr)
);

//  FIFO A : REGULAR
wire            FifoAEmpty;
wire    [31:0]  FifoAData;
wire            FifoARead;

//  FIFO B : PRIORITY
wire            FifoBEmpty;
wire    [31:0]  FifoBData;
wire            FifoBRead;

FIFO    #(
    .DataWidth          (32),
    .AddrWidth          (2)
)   FifoA   (
    .clk                (clk),
    .rstn               (rstn),
    .rdreq_i            (FifoARead),
    .wrreq_i            (FifoAWr),
    .full_o             (FifoAFull),
    .empty_o            (FifoAEmpty),
    .data_i             (FifoAWrData),
    .q_o                (FifoAData)
);

FIFO    #(
    .DataWidth          (32),
    .AddrWidth          (2)
)   FifoB   (
    .clk                (clk),
    .rstn               (rstn),
    .rdreq_i            (FifoBRead),
    .wrreq_i            (FifoBWr),
    .full_o             (FifoBFull),
    .empty_o            (FifoBEmpty),
    .data_i             (FifoBWrData),
    .q_o                (FifoBData)
);

//  Emit: Port A with higher priority

Emit    InstE(
    .clk                (clk),
    .rstn               (rstn),
    .FifoAEmpty_i       (FifoBEmpty),
    .FifoAData_i        (FifoBData),
    .FifoARead_o        (FifoBRead),
    .FifoBEmpty_i       (FifoAEmpty),
    .FifoBData_i        (FifoAData),
    .FifoBRead_o        (FifoARead),
    .Valid_o            (Valid_o),
    .Data_o             (Data_o),
    .Ready_i            (Ready_i)
);

endmodule