module UartNI (
    input   wire                    clk,
    input   wire                    rstn,

    input   wire    [31:0]          Data_i,
    input   wire                    Valid_i,
    output  reg                     Ready_o,

    output  reg     [7:0]           UartData_o,
    output  reg                     UartTrans_o,
    input   wire                    UartBusy_i,
    input   wire                    UartEmpty_i
);

wire    [1:0]   FlitTpye;

assign  FlitTpye    =   Data_i[31:30];

wire            HeadFlit;
wire            BodyFlit;
wire            TailFlit;

assign  HeadFlit    =   FlitTpye    ==  2'b00;
assign  BodyFlit    =   FlitTpye    ==  2'b01;
assign  TailFlit    =   FlitTpye    ==  2'b11;

localparam  TID =   3'h0;
localparam  TAD =   3'h1;
localparam  THH =   3'h2;
localparam  THL =   3'h3;
localparam  TLH =   3'h4;
localparam  TLL =   3'h5;
localparam  TEH =   3'h6;
localparam  TEL =   3'h7;

reg     [2:0]   StateCr = TID;
reg     [2:0]   StateNxt;

always@(posedge clk or negedge rstn) begin
    if(~rstn) begin
        StateCr <=  TID;
    end else begin
        StateCr <=  StateNxt;
    end 
end

always@(*) begin
    case(StateCr)
        TID : begin
            if(Valid_i) begin
                if(HeadFlit & UartEmpty_i) begin
                    StateNxt    =   TAD;
                end else begin
                    StateNxt    =   StateCr;
                end
            end else begin
                StateNxt    =   StateCr;
            end
        end TAD : begin
            if(~UartBusy_i) begin
                StateNxt    =   THH;
            end else begin
                StateNxt    =   StateCr;
            end
        end THH : begin
            if(Valid_i) begin
                if(~BodyFlit) begin
                    StateNxt    =   TAD;
                end else if(~UartBusy_i) begin
                    StateNxt    =   THL;
                end else begin
                    StateNxt    =   StateCr;
                end
            end else begin
                StateNxt    =   StateCr;
            end
        end THL : begin
            if(~UartBusy_i) begin
                StateNxt    =   TLH;
            end else begin
                StateNxt    =   StateCr;
            end
        end TLH : begin
            if(~UartBusy_i) begin
                StateNxt    =   TLL;
            end else begin
                StateNxt    =   StateCr;
            end
        end TLL : begin
            if(~UartBusy_i) begin
                StateNxt    =   TEH;
            end else begin
                StateNxt    =   StateCr;
            end
        end TEH : begin
            if(Valid_i) begin
                if(TailFlit) begin
                    if(~UartBusy_i) begin
                        StateNxt    =   TEL;
                    end else begin
                        StateNxt    =   StateCr;
                    end
                end else begin
                    StateNxt    =   TID;
                end
            end else begin
                StateNxt    =   StateCr;
            end
        end TEL : begin
            if(~UartBusy_i) begin
                StateNxt    =   TID;
            end else begin
                StateNxt    =   StateCr;
            end
        end default : begin
            StateNxt    =   TID;
        end
    endcase
end

reg SensorType = 1'b0;

always@(posedge clk or negedge rstn) begin
    if(~rstn) begin
        SensorType  <=  1'b0;
    end else begin
        if(HeadFlit & Valid_i) begin
            SensorType  <=  Data_i[29];
        end
    end
end

reg [23:0]  MemData = 24'b0;

always@(posedge clk or negedge rstn) begin
    if(~rstn) begin
        MemData <=  24'b0;
    end else begin
        if(SensorType & Valid_i & BodyFlit) begin
            MemData <= Data_i[23:0];
        end
    end
end

always@(*) begin
    case(StateCr) 
        TID : begin
            UartData_o  =   {TID,Data_i[9:5]};
            if(Valid_i & HeadFlit & UartEmpty_i) begin
                UartTrans_o =   1'b1;
            end else begin
                UartTrans_o =   1'b0;
            end
            Ready_o =   1'b0;
        end TAD : begin
            UartData_o  =   {TAD,Data_i[4:0]};
            if(~UartBusy_i) begin
                UartTrans_o =   1'b1;
                Ready_o =   1'b1;
            end else begin
                UartTrans_o =   1'b0;
                Ready_o =   1'b0;
            end
        end THH : begin
            if(SensorType) begin
                UartData_o  =   {THH,1'b0,Data_i[23:20]};
            end else begin
                UartData_o  =   {THH,1'b0,Data_i[15:12]};
            end
            if(~UartBusy_i & Valid_i & BodyFlit) begin
                UartTrans_o =   1'b1;
            end else begin
                UartTrans_o =   1'b0;
            end
            Ready_o =   1'b0;
        end THL : begin
            if(SensorType) begin
                UartData_o  =   {THL,1'b0,Data_i[19:16]};
            end else begin
                UartData_o  =   {THL,1'b0,Data_i[11:8]};
            end
            if(~UartBusy_i) begin
                UartTrans_o =   1'b1;
            end else begin
                UartTrans_o =   1'b0;
            end
            Ready_o =   1'b0;
        end TLH : begin
            if(SensorType) begin
                UartData_o  =   {TLH,1'b0,Data_i[15:12]};
            end else begin
                UartData_o  =   {TLH,1'b0,Data_i[7:4]};
            end
            if(~UartBusy_i) begin
                UartTrans_o =   1'b1;
            end else begin
                UartTrans_o =   1'b0;
            end
            Ready_o =   1'b0;
        end TLL : begin
            if(SensorType) begin
                UartData_o  =   {TLL,1'b0,Data_i[11:8]};
            end else begin
                UartData_o  =   {TLL,1'b0,Data_i[3:0]};
            end
            if(~UartBusy_i) begin
                UartTrans_o =   1'b1;
                Ready_o =   1'b1;
            end else begin
                UartTrans_o =   1'b0;
                Ready_o =   1'b0;
            end
        end TEH : begin
            if(SensorType) begin
                UartData_o  =   {TEH,1'b0,MemData[7:4]};
            end else begin
                UartData_o  =   {TEH,1'b0,Data_i[7:4]};
            end
            if(~UartBusy_i & Valid_i & TailFlit) begin
                UartTrans_o =   1'b1;
            end else begin
                UartTrans_o =   1'b0;
            end
            Ready_o =   1'b0;
        end TEL : begin
            if(SensorType) begin
                UartData_o  =   {TEL,1'b0,MemData[3:0]};
            end else begin
                UartData_o  =   {TEL,1'b0,Data_i[3:0]};
            end
            if(~UartBusy_i) begin
                UartTrans_o =   1'b1;
                Ready_o =   1'b1;
            end else begin
                UartTrans_o =   1'b0;
                Ready_o =   1'b0;
            end
        end default : begin
            UartTrans_o =   1'b0;
            Ready_o =   1'b0;
        end
    endcase
end

endmodule
