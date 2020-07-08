module  LogicNI #(
    parameter                       ID          =   4'b00,
    parameter                       NumOsc      =   25,
    parameter                       SimPresent  =   0 
)   (
    input   wire                    clk,
    input   wire                    rstn,

    output  wire    [4:0]           Addr_o,
    input   wire    [23:0]          Data_i,

    input   wire                    TokenValid_i,
    output  wire                    TokenValid_o,

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

reg     [26:0]  Slack = 27'b0;
reg     [4:0]   Osc = 5'b0;

wire    OscDone;
wire    SlackDone;


assign  OscDone     =   Osc == NumOsc - 1;

generate
    if(SimPresent) begin : SlackSim
        assign  SlackDone   =   Slack   ==  27'd10;
    end else begin : SlackSyn
        assign  SlackDone   =   Slack   ==  27'd100_000;
    end
endgenerate

reg     State   =   0;


always@(posedge clk or negedge rstn) begin
    if(~rstn)
        State   <=  1'b0;
    else if(~State)
        State   <=  TokenValid_i;
    else
        State   <=  ~(OscDone & (StateCr == TAIL) & ~FifoFull_i);
end

always@(*) begin
    case(StateCr)
        IDLE : begin
            if(State & SlackDone)
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

always@(posedge clk or negedge rstn) begin
    if(~rstn) begin
        Slack   <=  25'b0;
    end else if(State & (StateCr == IDLE)) begin
        if(SlackDone) begin
            Slack   <=  25'b0;
        end else begin
            Slack   <=  Slack + 1'b1;
        end
    end else begin
        Slack   <=  25'b0;
    end
end

always@(posedge clk or negedge rstn) begin
    if(~rstn) begin
        Osc     <=  5'b0;
    end else if(State) begin
        if((StateCr == TAIL) & ~FifoFull_i) begin
            if(OscDone) begin
                Osc <=  5'b0;
            end else begin
                Osc <=  Osc + 1'b1;
            end
        end
    end else begin
        Osc <= 5'b0;
    end
end

assign  FifoWr_o    =   ~FifoFull_i &   |StateCr;

always@(*) begin
    case(StateCr)
        IDLE    :   
            FifoWrData_o    =   32'b0;
        HEAD    :
            FifoWrData_o    =   {2'b00,1'b0,19'b0,1'b0,ID,Osc};
        BODY    :
            FifoWrData_o    =   {2'b01,14'b0,Data_i[23:8]};
        TAIL    :
            FifoWrData_o    =   {2'b11,22'b0,Data_i[7:0]};
        default :
            FifoWrData_o    =   32'b0;
    endcase
end

assign  TokenValid_o    =   State & OscDone & (StateCr == TAIL) & ~FifoFull_i;

assign  Addr_o  =   Osc;

endmodule