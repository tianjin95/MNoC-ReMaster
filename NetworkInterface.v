module  NetworkInterface #(
    parameter                       ID          =   4'h0,
    parameter                       NumOsc      =   25  ,
    parameter                       SimPresent  =   1'b0
)   (
    input   wire                    clk,
    input   wire                    rstn,

    output  wire    [4:0]           Addr_o,
    input   wire    [23:0]          Data_i,

    input   wire                    MemFlag_i,
    input   wire    [23:0]          MemData_i,
    output  wire                    MemSendEn_o,

    input   wire                    TokenValid_i,
    output  wire                    TokenValid_o,

    output  wire                    Valid_o,
    output  wire    [31:0]          Data_o,
    input   wire                    Ready_i
);

//  FifoA Regular
wire            FifoAFull;
wire    [31:0]  FifoAWrData;
wire            FifoAWr;

//  FifoB Priority
wire            FifoBFull;
wire    [31:0]  FifoBWrData;
wire            FifoBWr;

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

MemoryNI #(
    .ID                 (ID)
)   InstMNI (
    .clk                (clk),
    .rstn               (rstn),
    .MemFlag_i          (MemFlag_i),
    .MemData_i          (MemData_i),
    .MemSendEn_o        (MemSendEn_o),
    .FifoFull_i         (FifoBFull),
    .FifoWr_o           (FifoBWr),
    .FifoWrData_o       (FifoBWrData)
);

LogicNI #(
    .ID                 (ID),
    .NumOsc             (NumOsc),
    .SimPresent         (SimPresent)
)   InstLNI (
    .clk                (clk),
    .rstn               (rstn),
    .Addr_o             (Addr_o),
    .Data_i             (Data_i),
    .TokenValid_i       (TokenValid_i),
    .TokenValid_o       (TokenValid_o),
    .FifoFull_i         (FifoAFull),
    .FifoWr_o           (FifoAWr),
    .FifoWrData_o       (FifoAWrData)
);

endmodule