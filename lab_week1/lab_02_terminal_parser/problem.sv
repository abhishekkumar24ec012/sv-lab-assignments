module terminal_parser;

    task parse_and_execute(string raw_input);
        string clean_input;
        string base_cmd;
        string argument;
        string final_output;

        // Declare variables
        int space_idx;
        int end_idx;

        $display("\n[TERMINAL] Processing raw input: '%0s'", raw_input);

        // Initialize space_idx every time the task is called
        space_idx = -1;

        // TODO 1: Convert raw_input to lowercase
        clean_input = raw_input.tolower();

        // TODO 2: Calculate end_idx
        end_idx = clean_input.len() - 1;

        // TODO 3: Find the first space character
        for (int i = 0; i <= end_idx; i++) begin
            if (clean_input[i] == " ") begin
                space_idx = i;
                break;
            end
        end

        // TODO 4: Split string into command and argument
        if (space_idx != -1) begin
            base_cmd = clean_input.substr(0, space_idx - 1);
            argument = clean_input.substr(space_idx + 1, end_idx);
        end
        else begin
            base_cmd = clean_input;
            argument = "";
        end

        // TODO 5: Build final output using string concatenation
        final_output = {"Command: ", base_cmd, " | Argument: ", argument};

        // Print final output
        $display("%0s", final_output);

    endtask

    // ==========================================
    // TESTBENCH
    // ==========================================
    initial begin
        $display("--- CLI BOOT SEQUENCE INITIATED ---");

        parse_and_execute("SUDO UPDATE");
        parse_and_execute("read 0x4A");
        parse_and_execute("INJECT FAULT_01");

        $display("\n--- PARSER DIAGNOSTICS COMPLETE ---");
    end

endmodule
