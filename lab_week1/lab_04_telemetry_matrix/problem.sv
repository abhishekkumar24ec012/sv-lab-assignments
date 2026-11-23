module gargantua_telemetry;

    // ==========================================
    // 1. DATA STRUCTURES
    // ==========================================
    typedef struct {
        int resonance;
        int corruption;
    } quantum_packet_s;

    // Associative array indexed by frequency
    quantum_packet_s telemetry_map[int];


    // ==========================================
    // 2. DATA INGESTION
    // ==========================================
    task receive_packet(int freq, int res, int cor);

        // Store data into the associative array
        telemetry_map[freq].resonance = res;
        telemetry_map[freq].corruption = cor;

        $display("[TARS] Packet received on Freq: %0h | Res: %0d | Cor: %0d",
                  freq, res, cor);
    endtask


    // ==========================================
    // 3. DATA PURGE (SAFE DELETION)
    // ==========================================
    task purge_corrupted_data();
        $display("\n[TARS] Initiating Radiation Purge...");

        // Iterate through the associative array
        foreach (telemetry_map[freq]) begin

            // Delete packets with corruption >= 9000
            if (telemetry_map[freq].corruption >= 9000) begin
                telemetry_map.delete(freq);
            end

        end

        $display("[TARS] Purge complete. Remaining valid packets: %0d",
                  telemetry_map.num());
    endtask


    // ==========================================
    // 4. THE GRAVITY EQUATION
    // ==========================================
    task solve_gravity_equation();

        int max_res;
        int best_freq;

        max_res = 0;
        best_freq = 0;

        $display("\n[TARS] Calculating Gravity Equation...");

        // Iterate through remaining telemetry
        foreach (telemetry_map[freq]) begin

            // Find the highest resonance
            if (telemetry_map[freq].resonance > max_res) begin
                max_res = telemetry_map[freq].resonance;
                best_freq = freq;
            end

        end

        $display("==================================================");
        $display("   GRAVITY EQUATION SOLVED! ");
        $display("   Optimal Frequency: %0h", best_freq);
        $display("   Maximum Resonance: %0d", max_res);
        $display("==================================================");

    endtask


    // ==========================================
    // TESTBENCH
    // ==========================================
    initial begin
        $display("--- ENDURANCE SPACECRAFT: TELEMETRY SYSTEM ONLINE ---\n");

        // Simulating sparse data arriving from the black hole
        receive_packet(32'h0000_00A1, 4500, 1200);
        receive_packet(32'h1234_5678, 8800, 9500); // CORRUPTED!
        receive_packet(32'hFFFF_FFFF, 9200, 400);   // The Solution
        receive_packet(32'h8000_0000, 7100, 9100);  // CORRUPTED!
        receive_packet(32'h00FF_00FF, 3300, 800);

        // Execute system tasks
        purge_corrupted_data();
        solve_gravity_equation();

        $display("\n--- SYSTEM SHUTDOWN ---");
    end

endmodule
