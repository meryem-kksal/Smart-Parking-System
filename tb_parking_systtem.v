`timescale 1ns / 1ps

module tb_parking_system;

    // Girişler
    reg clk;
    reg reset;
    reg X;
    reg P;
    reg T;

    // Çıkışlar
    wire M;

    // Test edilen modülü çağırma
    parking_system uut (
        .clk(clk), 
        .reset(reset), 
        .X(X), 
        .P(P), 
        .T(T), 
        .M(M)
    );

    // Saat (Clock) sinyali üretimi
    always #5 clk = ~clk;

    initial begin
        // Başlangıç değerleri
        clk = 0;
        reset = 1;
        X = 0; P = 0; T = 0;

        // Sistemi Sıfırla
        #10;
        reset = 0;
        
        // Senaryo 1: Araba giriyor (S0 -> S1)
        #10 X = 1; 
        
        // Zaman tikleri geliyor (S1 -> S2 -> S3)
        #10 T = 1; #10 T = 0; // S2'ye geçti
        #10 T = 1; #10 T = 0; // S3'e geçti
        
        // S3'teyken adam ödeme yapıyor (S3 -> S6)
        #10 P = 1; #10 P = 0;
        
        // Motor çalıştı (M=1), Araba kapıdan çıkıyor (X=0) -> S0'a dön
        #10 X = 0;
        
        // Senaryo 2: Uzun süreli park (Max Tarifeye kadar bekleme)
        #20 X = 1; // Yeni araba geldi
        #10 T = 1; #10 T = 0; // S2
        #10 T = 1; #10 T = 0; // S3
        #10 T = 1; #10 T = 0; // S4
        #10 T = 1; #10 T = 0; // S5 (Max Tarife)
        #10 T = 1; #10 T = 0; // S5'te kalmalı (Don't care test)
        
        // Ödeme ve çıkış
        #10 P = 1; #10 P = 0; // S6'ya geçti, Motor=1
        #10 X = 0; // Araba çıktı, Sistem sıfırlandı
        
        // Simülasyonu bitir
        #20 $finish;
    end
    
    // Waveform (Dalga formu) çıktısı almak için
    initial begin
        $dumpfile("parking.vcd");
        $dumpvars(0, tb_parking_system);
    end

endmodule
