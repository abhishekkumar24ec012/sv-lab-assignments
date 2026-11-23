// ==========================================
// 1. CUSTOM DATA TYPE DEFINITION
// ==========================================
typedef enum logic [7:0] {
    HOVER   = 8'h00,
    PATROL  = 8'h01,
    DEFEND  = 8'h02,
    RTL     = 8'h03
} drone_cmd_e;


module aegis_radio_firewall;

    // ==========================================
    // 2. THE VULNERABLE UPLINK
    // ==========================================
    task unsafe_uplink(logic [7:0] raw_rx);
        // Declare enum variable
        drone_cmd_e next_cmd;

        // Forced compile-time type cast (static cast)
        next_cmd = drone_cmd_e'(raw_rx);

        $display("[UNSAFE] Radio received: %0d | AI Command set to: '%0s'",
                 raw_rx, next_cmd.name());
    endtask

    // ==========================================
    // 3. THE SECURE UPLINK
    // ==========================================
    task secure_uplink(logic [7:0] raw_rx);
        // Declare enum variable
        drone_cmd_e next_cmd;

        // Runtime validation using $cast
        if ($cast(next_cmd, raw_rx)) begin
            $display("[SECURE] Radio received: %0d | Valid Command: '%0s'",
                     raw_rx, next_cmd.name());
        end
        else begin
            $display("[WARNING] HACKER DETECTED! Invalid command: %0d | Forcing RTL",
                     raw_rx);
            next_cmd = RTL;
        end

    endtask

    // ==========================================
    // TESTBENCH
    // ==========================================
    initial begin
        $display("--- AEGIS CORP: RADIO FIREWALL BOOTING ---");

        $display("\n--- RUNNING VULNERABLE UPLINK ---");
        unsafe_uplink(8'h01);
        unsafe_uplink(8'h02);
        unsafe_uplink(8'h99);

        $display("\n--- RUNNING SECURE UPLINK ---");
        secure_uplink(8'h01);
        secure_uplink(8'h02);
        secure_uplink(8'h99);

        $display("\n--- FIREWALL DIAGNOSTICS COMPLETE ---");
    end

endmodule
