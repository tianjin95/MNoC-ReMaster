module  MemoryNI #(
    parameter                       ID = 4'h0
)   (
    input   wire                    clk,
    input   wire                    rstn,

    input   wire                    MemFlag_i,
    input   wire    [23:0]          MemData_i,
    output  wire                    MemSendEn_o,

    input   wire                    FifoFull_i,
    output  wire                    FifoWr_o,
    output  reg     [31:0]          FifoWrData_o
);

localparam  IDLE    =   2'b00;
localparam  HEAD    =   2'b01;
localparam  BODY    =   2'b10;
localparam  TAIL    =   2'b11;

reg     [1:0]   StateCr = IDLE;
reg     [1:0]   StateNxt;

always@(posedge clk or negedge rstn) begin
    if(~rstn)
        StateCr <=  IDLE;
    else
        StateCr <=  StateNxt;
end

always@(*) begin
    case(StateCr)
        IDLE : begin
            if(MemFlag_i)
                StateNxt    =   HEAD;
            else
                StateNxt    =   StateCr;
        end HEAD : begin
            if(~FifoFull_i)
                StateNxt    =   BODY;
            else
                StateNxt    =   StateCr;
        end BODY : begin
            if(~FifoFull_i)
                StateNxt    =   TAIL;
            else
                StateNxt    =   StateCr;
        end TAIL : begin
            if(~FifoFull_i)
                StateNxt    =   IDLE;
            else
                StateNxt    =   StateCr;
        end default : begin
            StateNxt    =   IDLE;
        end
    endcase
end

assign  FifoWr_o    =   ~FifoFull_i &   |StateCr;

wire    [9:0]   Check;

assign  Check[0]    =   ~^MemData_i[3:0];
assign  Check[1]    =   ~^MemData_i[7:4];
assign  Check[2]    =   ~^MemData_i[11:8];
assign  Check[3]    =   ~^MemData_i[15:12];
assign  Check[4]    =   ~^MemData_i[19:16];
assign  Check[5]    =   ~^MemData_i[23:20];
assign  Check[6]    =   ~(MemData_i[0] ^ MemData_i[4] ^ MemData_i[8] ^ MemData_i[12] ^ MemData_i[16] ^ MemData_i[20]);
assign  Check[7]    =   ~(MemData_i[1] ^ MemData_i[5] ^ MemData_i[9] ^ MemData_i[13] ^ MemData_i[17] ^ MemData_i[21]);
assign  Check[8]    =   ~(MemData_i[2] ^ MemData_i[6] ^ MemData_i[10] ^ MemData_i[14] ^ MemData_i[18] ^ MemData_i[22]);
assign  Check[9]    =   ~(MemData_i[3] ^ MemData_i[7] ^ MemData_i[11] ^ MemData_i[15] ^ MemData_i[19] ^ MemData_i[23]);

always@(*) begin
    case(StateCr)
        IDLE    :   
            FifoWrData_o    =   32'b0;
        HEAD    :
            FifoWrData_o    =   {2'b00,1'b1,19'b0,1'b0,ID,5'd25};
        BODY    :
            FifoWrData_o    =   {2'b01,6'b0,MemData_i};
        TAIL    :
            FifoWrData_o    =   {2'b11,20'b0,Check};
        default :
            FifoWrData_o    =   32'b0;
    endcase
end

assign  MemSendEn_o =   ~FifoFull_i &   &StateCr;

endmodule