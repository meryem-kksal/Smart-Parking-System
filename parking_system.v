module parking_system (
    input clk,
    input reset,
    input X,
    input P,
    input T,
    output reg M
);

    // State Encoding (Durum Atamaları)
    parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011,
              S4 = 3'b100, S5 = 3'b101, S6 = 3'b111;
              
    reg [2:0] current_state, next_state;

    // 1. Sequential Logic: State Register (Flip-Flop Güncellemesi)
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // 2. Combinational Logic: Next State Logic (Durum Geçiş Mantığı)
    always @(*) begin
        case (current_state)
            S0: if (X) next_state = S1; else next_state = S0;
            S1: if (P) next_state = S6; else if (T) next_state = S2; else next_state = S1;
            S2: if (P) next_state = S6; else if (T) next_state = S3; else next_state = S2;
            S3: if (P) next_state = S6; else if (T) next_state = S4; else next_state = S3;
            S4: if (P) next_state = S6; else if (T) next_state = S5; else next_state = S4;
            S5: if (P) next_state = S6; else next_state = S5;
            S6: if (~X) next_state = S0; else next_state = S6; // X=0 olunca başa dön
            default: next_state = S0;
        endcase
    end

    // 3. Output Logic: Moore Machine (Çıktı sadece duruma bağlıdır)
    always @(*) begin
        if (current_state == S6)
            M = 1'b1; // Kapı motoru çalışır
        else
            M = 1'b0; // Kapı kapalı
    end

endmodule
