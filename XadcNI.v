module  XadcNI #(
    parameter                       SimPresent = 0
)   (
    input   wire                    clk,
    input   wire                    rstn,

    input   wire    [23:0]          Vccint_i,
    input   wire    [23:0]          Temp_i,

    output  wire                    Valid_o,
    output  reg     [31:0]          Data_o,
    input   wire                    Ready_i,

    input   wire    [3:0]           ID_i,

    input   wire                    TokenValid_i,
    output  wire                    TokenValid_o
);

parameter   IDLE    =   3'h0;
parameter   VHEAD   =   3'h1;
parameter   VBODY   =   3'h2;
parameter   VTAIL   =   3'h3;
parameter   THEAD   =   3'h4;
parameter   TBODY   =   3'h5;
parameter   TTAIL   =   3'h6;

reg     [2:0]   StateCr = IDLE;
reg     [2:0]   StateNxt;

always@(posedge clk or negedge rstn) begin
    if(~rstn) begin
        StateCr <=  IDLE;
    end else begin
        StateCr <=  StateNxt;
    end
end

always@(*) begin
    case(StateCr) 
        IDLE : begin
            if(TokenValid_i) begin
                StateNxt    =   VHEAD;
            end else begin
                StateNxt    =   StateCr;
            end
        end VHEAD : begin
            if(Ready_i) begin
                StateNxt    =   VBODY;
            end else begin
                StateNxt    =   StateCr;
            end
        end VBODY : begin
            if(Ready_i) begin
                StateNxt    =   VTAIL;
            end else begin
                StateNxt    =   StateCr;
            end
        end VTAIL : begin
            if(Ready_i) begin
                StateNxt    =   THEAD;
            end else begin
                StateNxt    =   StateCr;
            end
        end THEAD : begin
            if(Ready_i) begin
                StateNxt    =   TBODY;
            end else begin
                StateNxt    =   StateCr;
            end
        end TBODY : begin
            if(Ready_i) begin
                StateNxt    =   TTAIL;
            end else begin
                StateNxt    =   StateCr;
            end
        end TTAIL : begin
            if(Ready_i) begin
                StateNxt    =   IDLE;
            end else begin
                StateNxt    =   StateCr;
            end
        end default : begin
            StateNxt    =   IDLE;
        end
    endcase
end

assign  Valid_o =   |StateCr;

reg [23:0]  Treg = 24'b0;
reg [23:0]  Vreg = 24'b0;

always@(posedge clk or negedge rstn) begin
    if(~rstn) begin
        Treg    <=  24'b0;
        Vreg    <=  24'b0;
    end else begin
        if(TokenValid_i) begin
            Treg    <=  Temp_i;
            Vreg    <=  Vccint_i;
        end
    end
end

always@(*) begin
    case(StateCr)
        IDLE : begin
            Data_o  =   32'b0;
        end THEAD : begin
            Data_o  =   {2'b00,1'b1,19'b0,1'b0,ID_i,5'd26};
        end TBODY : begin
            Data_o  =   {2'b01,6'b0,Treg[23:0]};
        end TTAIL : begin
            Data_o  =   {2'b11,22'b0,Treg[7:0]};
        end VHEAD : begin
            Data_o  =   {2'b00,1'b1,19'b0,1'b0,ID_i,5'd27};
        end VBODY : begin
            Data_o  =   {2'b01,6'b0,Vreg[23:0]};
        end VTAIL : begin
            Data_o  =   {2'b11,22'b0,Vreg[7:0]};
        end default : begin
            Data_o  =   32'b0;
        end
    endcase
end

assign  TokenValid_o    =   (StateCr == TTAIL)  &   Ready_i;

endmodule


