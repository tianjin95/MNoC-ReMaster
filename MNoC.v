module  MNoC #(
    parameter                       SimPresent = 0
)   (
    input   wire                    clk,
    input   wire                    rstn,

    output  wire    [7:0]           UartData_o,
    output  wire                    UartTrans_o,
    input   wire                    UartBusy_i,
    input   wire                    UartEmpty_i,

    output  wire    [4:0]           Addr0_o,
    input   wire    [23:0]          Data0_i,
    input   wire                    Mem0Flag_i,
    input   wire    [23:0]          Mem0Data_i,
    output  wire                    Mem0SendEn_o,

    output  wire    [4:0]           Addr1_o,
    input   wire    [23:0]          Data1_i,
    input   wire                    Mem1Flag_i,
    input   wire    [23:0]          Mem1Data_i,
    output  wire                    Mem1SendEn_o,

    output  wire    [4:0]           Addr2_o,
    input   wire    [23:0]          Data2_i,
    input   wire                    Mem2Flag_i,
    input   wire    [23:0]          Mem2Data_i,
    output  wire                    Mem2SendEn_o,

    output  wire    [4:0]           Addr3_o,
    input   wire    [23:0]          Data3_i,
    input   wire                    Mem3Flag_i,
    input   wire    [23:0]          Mem3Data_i,
    output  wire                    Mem3SendEn_o,

    output  wire    [4:0]           Addr4_o,
    input   wire    [23:0]          Data4_i,
    input   wire                    Mem4Flag_i,
    input   wire    [23:0]          Mem4Data_i,
    output  wire                    Mem4SendEn_o,

    output  wire    [4:0]           Addr5_o,
    input   wire    [23:0]          Data5_i,
    input   wire                    Mem5Flag_i,
    input   wire    [23:0]          Mem5Data_i,
    output  wire                    Mem5SendEn_o,

    output  wire    [4:0]           Addr6_o,
    input   wire    [23:0]          Data6_i,
    input   wire                    Mem6Flag_i,
    input   wire    [23:0]          Mem6Data_i,
    output  wire                    Mem6SendEn_o,

    output  wire    [4:0]           Addr7_o,
    input   wire    [23:0]          Data7_i,
    input   wire                    Mem7Flag_i,
    input   wire    [23:0]          Mem7Data_i,
    output  wire                    Mem7SendEn_o,

    output  wire    [4:0]           Addr8_o,
    input   wire    [23:0]          Data8_i,
    input   wire                    Mem8Flag_i,
    input   wire    [23:0]          Mem8Data_i,
    output  wire                    Mem8SendEn_o,

    output  wire    [4:0]           Addr9_o,
    input   wire    [23:0]          Data9_i,
    input   wire                    Mem9Flag_i,
    input   wire    [23:0]          Mem9Data_i,
    output  wire                    Mem9SendEn_o,

    output  wire    [4:0]           AddrA_o,
    input   wire    [23:0]          DataA_i,
    input   wire                    MemAFlag_i,
    input   wire    [23:0]          MemAData_i,
    output  wire                    MemASendEn_o,

    output  wire    [4:0]           AddrB_o,
    input   wire    [23:0]          DataB_i,
    input   wire                    MemBFlag_i,
    input   wire    [23:0]          MemBData_i,
    output  wire                    MemBSendEn_o,

    output  wire    [4:0]           AddrC_o,
    input   wire    [23:0]          DataC_i,
    input   wire                    MemCFlag_i,
    input   wire    [23:0]          MemCData_i,
    output  wire                    MemCSendEn_o,

    output  wire    [4:0]           AddrD_o,
    input   wire    [23:0]          DataD_i,
    input   wire                    MemDFlag_i,
    input   wire    [23:0]          MemDData_i,
    output  wire                    MemDSendEn_o,

    output  wire    [4:0]           AddrE_o,
    input   wire    [23:0]          DataE_i,
    input   wire                    MemEFlag_i,
    input   wire    [23:0]          MemEData_i,
    output  wire                    MemESendEn_o,

    output  wire    [4:0]           AddrF_o,
    input   wire    [23:0]          DataF_i,
    input   wire                    MemFFlag_i,
    input   wire    [23:0]          MemFData_i,
    output  wire                    MemFSendEn_o,

    input   wire    [23:0]          Temp_i,
    input   wire    [23:0]          Vccint_i
);

//  UART

wire            Valid;
wire    [31:0]  Data;
wire            Ready;

UartNI InstUNI (
    .clk            (clk),
    .rstn           (rstn),
    .Data_i         (Data),
    .Valid_i        (Valid),
    .Ready_o        (Ready),
    .UartData_o     (UartData_o),
    .UartTrans_o    (UartTrans_o),
    .UartBusy_i     (UartBusy_i),
    .UartEmpty_i    (UartEmpty_i)
);

//  ROOT ROUTER
wire            RootPortAValid;
wire    [31:0]  RootPortAData;
wire            RootPortAReady;

wire            RootPortBValid;
wire    [31:0]  RootPortBData;
wire            RootPortBReady;

wire            RootPortCValid;
wire    [31:0]  RootPortCData;
wire            RootPortCReady;

Router3x1 InstRoot (
    .clk            (clk),
    .rstn           (rstn),
    .DataC_i        (RootPortAData),
    .ValidC_i       (RootPortAValid),
    .ReadyC_o       (RootPortAReady),
    .DataB_i        (RootPortBData),
    .ValidB_i       (RootPortBValid),
    .ReadyB_o       (RootPortBReady),
    .DataA_i        (RootPortCData),
    .ValidA_i       (RootPortCValid),
    .ReadyA_o       (RootPortCReady),
    .Data_o         (Data),
    .Valid_o        (Valid),
    .Ready_i        (Ready)
);

wire    TokenXValid;
wire    TokenXReady;
wire [3:0]  ID;

XadcNI #(
    .SimPresent     (SimPresent)
)   InstXNI (
    .clk            (clk),
    .rstn           (rstn),
    .Temp_i         (Temp_i),
    .Vccint_i       (Vccint_i),
    .ID_i           (ID),
    .TokenValid_i   (TokenXValid),
    .TokenValid_o   (TokenXReady),
    .Valid_o        (RootPortCValid),
    .Ready_i        (RootPortCReady),
    .Data_o         (RootPortCData)
);

//  L1 ROUTER
wire            L1APortAValid;
wire    [31:0]  L1APortAData;
wire            L1APortAReady;

wire            L1APortBValid;
wire    [31:0]  L1APortBData;
wire            L1APortBReady;

wire            L1BPortAValid;
wire    [31:0]  L1BPortAData;
wire            L1BPortAReady;

wire            L1BPortBValid;
wire    [31:0]  L1BPortBData;
wire            L1BPortBReady;

Router2x1 InstL1A (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L1APortAData),
    .ValidA_i       (L1APortAValid),
    .ReadyA_o       (L1APortAReady),
    .DataB_i        (L1APortBData),
    .ValidB_i       (L1APortBValid),
    .ReadyB_o       (L1APortBReady),
    .Data_o         (RootPortAData),
    .Valid_o        (RootPortAValid),
    .Ready_i        (RootPortAReady)
);

Router2x1 InstL1B (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L1BPortAData),
    .ValidA_i       (L1BPortAValid),
    .ReadyA_o       (L1BPortAReady),
    .DataB_i        (L1BPortBData),
    .ValidB_i       (L1BPortBValid),
    .ReadyB_o       (L1BPortBReady),
    .Data_o         (RootPortBData),
    .Valid_o        (RootPortBValid),
    .Ready_i        (RootPortBReady)
);

//  L2 ROUTER
wire            L2AAPortAValid;
wire    [31:0]  L2AAPortAData;
wire            L2AAPortAReady;

wire            L2AAPortBValid;
wire    [31:0]  L2AAPortBData;
wire            L2AAPortBReady;

wire            L2ABPortAValid;
wire    [31:0]  L2ABPortAData;
wire            L2ABPortAReady;

wire            L2ABPortBValid;
wire    [31:0]  L2ABPortBData;
wire            L2ABPortBReady;

wire            L2BAPortAValid;
wire    [31:0]  L2BAPortAData;
wire            L2BAPortAReady;

wire            L2BAPortBValid;
wire    [31:0]  L2BAPortBData;
wire            L2BAPortBReady;

wire            L2BBPortAValid;
wire    [31:0]  L2BBPortAData;
wire            L2BBPortAReady;

wire            L2BBPortBValid;
wire    [31:0]  L2BBPortBData;
wire            L2BBPortBReady;

Router2x1 InstL2AA (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L2AAPortAData),
    .ValidA_i       (L2AAPortAValid),
    .ReadyA_o       (L2AAPortAReady),
    .DataB_i        (L2AAPortBData),
    .ValidB_i       (L2AAPortBValid),
    .ReadyB_o       (L2AAPortBReady),
    .Data_o         (L1APortAData),
    .Valid_o        (L1APortAValid),
    .Ready_i        (L1APortAReady)
);

Router2x1 InstL2AB (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L2ABPortAData),
    .ValidA_i       (L2ABPortAValid),
    .ReadyA_o       (L2ABPortAReady),
    .DataB_i        (L2ABPortBData),
    .ValidB_i       (L2ABPortBValid),
    .ReadyB_o       (L2ABPortBReady),
    .Data_o         (L1APortBData),
    .Valid_o        (L1APortBValid),
    .Ready_i        (L1APortBReady)
);

Router2x1 InstL2BA (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L2BAPortAData),
    .ValidA_i       (L2BAPortAValid),
    .ReadyA_o       (L2BAPortAReady),
    .DataB_i        (L2BAPortBData),
    .ValidB_i       (L2BAPortBValid),
    .ReadyB_o       (L2BAPortBReady),
    .Data_o         (L1BPortAData),
    .Valid_o        (L1BPortAValid),
    .Ready_i        (L1BPortAReady)
);

Router2x1 InstL2BB (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L2BBPortAData),
    .ValidA_i       (L2BBPortAValid),
    .ReadyA_o       (L2BBPortAReady),
    .DataB_i        (L2BBPortBData),
    .ValidB_i       (L2BBPortBValid),
    .ReadyB_o       (L2BBPortBReady),
    .Data_o         (L1BPortBData),
    .Valid_o        (L1BPortBValid),
    .Ready_i        (L1BPortBReady)
);

//  L3 ROUTER
wire            L3AAAPortAValid;
wire    [31:0]  L3AAAPortAData;
wire            L3AAAPortAReady;

wire            L3AAAPortBValid;
wire    [31:0]  L3AAAPortBData;
wire            L3AAAPortBReady;

wire            L3AABPortAValid;
wire    [31:0]  L3AABPortAData;
wire            L3AABPortAReady;

wire            L3AABPortBValid;
wire    [31:0]  L3AABPortBData;
wire            L3AABPortBReady;

wire            L3ABAPortAValid;
wire    [31:0]  L3ABAPortAData;
wire            L3ABAPortAReady;

wire            L3ABAPortBValid;
wire    [31:0]  L3ABAPortBData;
wire            L3ABAPortBReady;

wire            L3ABBPortAValid;
wire    [31:0]  L3ABBPortAData;
wire            L3ABBPortAReady;

wire            L3ABBPortBValid;
wire    [31:0]  L3ABBPortBData;
wire            L3ABBPortBReady;

wire            L3BAAPortAValid;
wire    [31:0]  L3BAAPortAData;
wire            L3BAAPortAReady;

wire            L3BAAPortBValid;
wire    [31:0]  L3BAAPortBData;
wire            L3BAAPortBReady;

wire            L3BABPortAValid;
wire    [31:0]  L3BABPortAData;
wire            L3BABPortAReady;

wire            L3BABPortBValid;
wire    [31:0]  L3BABPortBData;
wire            L3BABPortBReady;

wire            L3BBAPortAValid;
wire    [31:0]  L3BBAPortAData;
wire            L3BBAPortAReady;

wire            L3BBAPortBValid;
wire    [31:0]  L3BBAPortBData;
wire            L3BBAPortBReady;

wire            L3BBBPortAValid;
wire    [31:0]  L3BBBPortAData;
wire            L3BBBPortAReady;

wire            L3BBBPortBValid;
wire    [31:0]  L3BBBPortBData;
wire            L3BBBPortBReady;

Router2x1 InstL3AAA (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L3AAAPortAData),
    .ValidA_i       (L3AAAPortAValid),
    .ReadyA_o       (L3AAAPortAReady),
    .DataB_i        (L3AAAPortBData),
    .ValidB_i       (L3AAAPortBValid),
    .ReadyB_o       (L3AAAPortBReady),
    .Data_o         (L2AAPortAData),
    .Valid_o        (L2AAPortAValid),
    .Ready_i        (L2AAPortAReady)
);

Router2x1 InstL3AAB (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L3AABPortAData),
    .ValidA_i       (L3AABPortAValid),
    .ReadyA_o       (L3AABPortAReady),
    .DataB_i        (L3AABPortBData),
    .ValidB_i       (L3AABPortBValid),
    .ReadyB_o       (L3AABPortBReady),
    .Data_o         (L2AAPortBData),
    .Valid_o        (L2AAPortBValid),
    .Ready_i        (L2AAPortBReady)
);

Router2x1 InstL3ABA (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L3ABAPortAData),
    .ValidA_i       (L3ABAPortAValid),
    .ReadyA_o       (L3ABAPortAReady),
    .DataB_i        (L3ABAPortBData),
    .ValidB_i       (L3ABAPortBValid),
    .ReadyB_o       (L3ABAPortBReady),
    .Data_o         (L2ABPortAData),
    .Valid_o        (L2ABPortAValid),
    .Ready_i        (L2ABPortAReady)
);

Router2x1 InstL3ABB (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L3ABBPortAData),
    .ValidA_i       (L3ABBPortAValid),
    .ReadyA_o       (L3ABBPortAReady),
    .DataB_i        (L3ABBPortBData),
    .ValidB_i       (L3ABBPortBValid),
    .ReadyB_o       (L3ABBPortBReady),
    .Data_o         (L2ABPortBData),
    .Valid_o        (L2ABPortBValid),
    .Ready_i        (L2ABPortBReady)
);

Router2x1 InstL3BAA (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L3BAAPortAData),
    .ValidA_i       (L3BAAPortAValid),
    .ReadyA_o       (L3BAAPortAReady),
    .DataB_i        (L3BAAPortBData),
    .ValidB_i       (L3BAAPortBValid),
    .ReadyB_o       (L3BAAPortBReady),
    .Data_o         (L2BAPortAData),
    .Valid_o        (L2BAPortAValid),
    .Ready_i        (L2BAPortAReady)
);

Router2x1 InstL3BAB (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L3BABPortAData),
    .ValidA_i       (L3BABPortAValid),
    .ReadyA_o       (L3BABPortAReady),
    .DataB_i        (L3BABPortBData),
    .ValidB_i       (L3BABPortBValid),
    .ReadyB_o       (L3BABPortBReady),
    .Data_o         (L2BAPortBData),
    .Valid_o        (L2BAPortBValid),
    .Ready_i        (L2BAPortBReady)
);

Router2x1 InstL3BBA (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L3BBAPortAData),
    .ValidA_i       (L3BBAPortAValid),
    .ReadyA_o       (L3BBAPortAReady),
    .DataB_i        (L3BBAPortBData),
    .ValidB_i       (L3BBAPortBValid),
    .ReadyB_o       (L3BBAPortBReady),
    .Data_o         (L2BBPortAData),
    .Valid_o        (L2BBPortAValid),
    .Ready_i        (L2BBPortAReady)
);

Router2x1 InstL3BBB (
    .clk            (clk),
    .rstn           (rstn),
    .DataA_i        (L3BBBPortAData),
    .ValidA_i       (L3BBBPortAValid),
    .ReadyA_o       (L3BBBPortAReady),
    .DataB_i        (L3BBBPortBData),
    .ValidB_i       (L3BBBPortBValid),
    .ReadyB_o       (L3BBBPortBReady),
    .Data_o         (L2BBPortBData),
    .Valid_o        (L2BBPortBValid),
    .Ready_i        (L2BBPortBReady)
);

//  NI

wire    [15:0]  TokenValid;
wire    [15:0]  TokenReady;

NetworkInterface #(
    .ID             (4'h0),
    .NumOsc         (25),
    .SimPresent     (SimPresent)
)   InstNI0 (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (Addr0_o),
    .Data_i         (Data0_i),
    .MemFlag_i      (Mem0Flag_i),
    .MemData_i      (Mem0Data_i),
    .MemSendEn_o    (Mem0SendEn_o),
    .TokenValid_i   (TokenValid[0]),
    .TokenValid_o   (TokenReady[0]),
    .Valid_o        (L3AAAPortAValid),
    .Data_o         (L3AAAPortAData),
    .Ready_i        (L3AAAPortAReady)
);

NetworkInterface #(
    .ID             (4'h1),
    .NumOsc         (25),
    .SimPresent     (SimPresent)
)   InstNI1 (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (Addr1_o),
    .Data_i         (Data1_i),
    .MemFlag_i      (Mem1Flag_i),
    .MemData_i      (Mem1Data_i),
    .MemSendEn_o    (Mem1SendEn_o),
    .TokenValid_i   (TokenValid[1]),
    .TokenValid_o   (TokenReady[1]),
    .Valid_o        (L3AAAPortBValid),
    .Data_o         (L3AAAPortBData),
    .Ready_i        (L3AAAPortBReady)
);

NetworkInterface #(
    .ID             (4'h2),
    .NumOsc         (25),
    .SimPresent     (SimPresent)
)   InstNI2 (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (Addr2_o),
    .Data_i         (Data2_i),
    .MemFlag_i      (Mem2Flag_i),
    .MemData_i      (Mem2Data_i),
    .MemSendEn_o    (Mem2SendEn_o),
    .TokenValid_i   (TokenValid[2]),
    .TokenValid_o   (TokenReady[2]),
    .Valid_o        (L3AABPortAValid),
    .Data_o         (L3AABPortAData),
    .Ready_i        (L3AABPortAReady)
);

NetworkInterface #(
    .ID             (4'h3),
    .NumOsc         (25),
    .SimPresent     (SimPresent)
)   InstNI3 (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (Addr3_o),
    .Data_i         (Data3_i),
    .MemFlag_i      (Mem3Flag_i),
    .MemData_i      (Mem3Data_i),
    .MemSendEn_o    (Mem3SendEn_o),
    .TokenValid_i   (TokenValid[3]),
    .TokenValid_o   (TokenReady[3]),
    .Valid_o        (L3AABPortBValid),
    .Data_o         (L3AABPortBData),
    .Ready_i        (L3AABPortBReady)
);

NetworkInterface #(
    .ID             (4'h4),
    .NumOsc         (20),
    .SimPresent     (SimPresent)
)   InstNI4 (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (Addr4_o),
    .Data_i         (Data4_i),
    .MemFlag_i      (Mem4Flag_i),
    .MemData_i      (Mem4Data_i),
    .MemSendEn_o    (Mem4SendEn_o),
    .TokenValid_i   (TokenValid[4]),
    .TokenValid_o   (TokenReady[4]),
    .Valid_o        (L3ABAPortAValid),
    .Data_o         (L3ABAPortAData),
    .Ready_i        (L3ABAPortAReady)
);

NetworkInterface #(
    .ID             (4'h5),
    .NumOsc         (20),
    .SimPresent     (SimPresent)
)   InstNI5 (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (Addr5_o),
    .Data_i         (Data5_i),
    .MemFlag_i      (Mem5Flag_i),
    .MemData_i      (Mem5Data_i),
    .MemSendEn_o    (Mem5SendEn_o),
    .TokenValid_i   (TokenValid[5]),
    .TokenValid_o   (TokenReady[5]),
    .Valid_o        (L3ABAPortBValid),
    .Data_o         (L3ABAPortBData),
    .Ready_i        (L3ABAPortBReady)
);

NetworkInterface #(
    .ID             (4'h6),
    .NumOsc         (20),
    .SimPresent     (SimPresent)
)   InstNI6 (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (Addr6_o),
    .Data_i         (Data6_i),
    .MemFlag_i      (Mem6Flag_i),
    .MemData_i      (Mem6Data_i),
    .MemSendEn_o    (Mem6SendEn_o),
    .TokenValid_i   (TokenValid[6]),
    .TokenValid_o   (TokenReady[6]),
    .Valid_o        (L3ABBPortAValid),
    .Data_o         (L3ABBPortAData),
    .Ready_i        (L3ABBPortAReady)
);

NetworkInterface #(
    .ID             (4'h7),
    .NumOsc         (20),
    .SimPresent     (SimPresent)
)   InstNI7 (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (Addr7_o),
    .Data_i         (Data7_i),
    .MemFlag_i      (Mem7Flag_i),
    .MemData_i      (Mem7Data_i),
    .MemSendEn_o    (Mem7SendEn_o),
    .TokenValid_i   (TokenValid[7]),
    .TokenValid_o   (TokenReady[7]),
    .Valid_o        (L3ABBPortBValid),
    .Data_o         (L3ABBPortBData),
    .Ready_i        (L3ABBPortBReady)
);

NetworkInterface #(
    .ID             (4'h8),
    .NumOsc         (10),
    .SimPresent     (SimPresent)
)   InstNI8 (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (Addr8_o),
    .Data_i         (Data8_i),
    .MemFlag_i      (Mem8Flag_i),
    .MemData_i      (Mem8Data_i),
    .MemSendEn_o    (Mem8SendEn_o),
    .TokenValid_i   (TokenValid[8]),
    .TokenValid_o   (TokenReady[8]),
    .Valid_o        (L3BAAPortAValid),
    .Data_o         (L3BAAPortAData),
    .Ready_i        (L3BAAPortAReady)
);

NetworkInterface #(
    .ID             (4'h9),
    .NumOsc         (10),
    .SimPresent     (SimPresent)
)   InstNI9 (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (Addr9_o),
    .Data_i         (Data9_i),
    .MemFlag_i      (Mem9Flag_i),
    .MemData_i      (Mem9Data_i),
    .MemSendEn_o    (Mem9SendEn_o),
    .TokenValid_i   (TokenValid[9]),
    .TokenValid_o   (TokenReady[9]),
    .Valid_o        (L3BAAPortBValid),
    .Data_o         (L3BAAPortBData),
    .Ready_i        (L3BAAPortBReady)
);

NetworkInterface #(
    .ID             (4'hA),
    .NumOsc         (10),
    .SimPresent     (SimPresent)
)   InstNIA (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (AddrA_o),
    .Data_i         (DataA_i),
    .MemFlag_i      (MemAFlag_i),
    .MemData_i      (MemAData_i),
    .MemSendEn_o    (MemASendEn_o),
    .TokenValid_i   (TokenValid[10]),
    .TokenValid_o   (TokenReady[10]),
    .Valid_o        (L3BABPortAValid),
    .Data_o         (L3BABPortAData),
    .Ready_i        (L3BABPortAReady)
);

NetworkInterface #(
    .ID             (4'hB),
    .NumOsc         (10),
    .SimPresent     (SimPresent)
)   InstNIB (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (AddrB_o),
    .Data_i         (DataB_i),
    .MemFlag_i      (MemBFlag_i),
    .MemData_i      (MemBData_i),
    .MemSendEn_o    (MemBSendEn_o),
    .TokenValid_i   (TokenValid[11]),
    .TokenValid_o   (TokenReady[11]),
    .Valid_o        (L3BABPortBValid),
    .Data_o         (L3BABPortBData),
    .Ready_i        (L3BABPortBReady)
);

NetworkInterface #(
    .ID             (4'hC),
    .NumOsc         (8),
    .SimPresent     (SimPresent)
)   InstNIC (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (AddrC_o),
    .Data_i         (DataC_i),
    .MemFlag_i      (MemCFlag_i),
    .MemData_i      (MemCData_i),
    .MemSendEn_o    (MemCSendEn_o),
    .TokenValid_i   (TokenValid[12]),
    .TokenValid_o   (TokenReady[12]),
    .Valid_o        (L3BBAPortAValid),
    .Data_o         (L3BBAPortAData),
    .Ready_i        (L3BBAPortAReady)
);

NetworkInterface #(
    .ID             (4'hD),
    .NumOsc         (8),
    .SimPresent     (SimPresent)
)   InstNID (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (AddrD_o),
    .Data_i         (DataD_i),
    .MemFlag_i      (MemDFlag_i),
    .MemData_i      (MemDData_i),
    .MemSendEn_o    (MemDSendEn_o),
    .TokenValid_i   (TokenValid[13]),
    .TokenValid_o   (TokenReady[13]),
    .Valid_o        (L3BBAPortBValid),
    .Data_o         (L3BBAPortBData),
    .Ready_i        (L3BBAPortBReady)
);

NetworkInterface #(
    .ID             (4'hE),
    .NumOsc         (8),
    .SimPresent     (SimPresent)
)   InstNIE (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (AddrE_o),
    .Data_i         (DataE_i),
    .MemFlag_i      (MemEFlag_i),
    .MemData_i      (MemEData_i),
    .MemSendEn_o    (MemESendEn_o),
    .TokenValid_i   (TokenValid[14]),
    .TokenValid_o   (TokenReady[14]),
    .Valid_o        (L3BBBPortAValid),
    .Data_o         (L3BBBPortAData),
    .Ready_i        (L3BBBPortAReady)
);

NetworkInterface #(
    .ID             (4'hF),
    .NumOsc         (8),
    .SimPresent     (SimPresent)
)   InstNIF (
    .clk            (clk),
    .rstn           (rstn),
    .Addr_o         (AddrF_o),
    .Data_i         (DataF_i),
    .MemFlag_i      (MemFFlag_i),
    .MemData_i      (MemFData_i),
    .MemSendEn_o    (MemFSendEn_o),
    .TokenValid_i   (TokenValid[15]),
    .TokenValid_o   (TokenReady[15]),
    .Valid_o        (L3BBBPortBValid),
    .Data_o         (L3BBBPortBData),
    .Ready_i        (L3BBBPortBReady)
);

AutoBoot InstAB(
    .clk            (clk),
    .rstn           (rstn),
    .TokenReady_i   (TokenReady),
    .TokenValid_o   (TokenValid),
    .TokenXReady_i  (TokenXReady),
    .TokenXValid_o  (TokenXValid),
    .ID_o           (ID)
);

endmodule