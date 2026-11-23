// ==========================================
// 1. DATA TYPE DEFINITIONS
// ==========================================

// Packed array of 24 bits
typedef logic [23:0] pixel_t;

// Packed array of 8 bits
typedef logic [7:0] byte_t;


module smart_glasses_bridge;

    // ==========================================
    // 2. THE TRANSMIT API (Camera to Bridge)
    // ==========================================
    function void pixel_to_byte(input pixel_t in_pixels [], output byte_t out_bytes []);

        int required_bytes;

        // Step 1: Calculate the required number of bytes
        required_bytes = in_pixels.size() * 3;

        // Step 2: Allocate memory for out_bytes
        out_bytes = new[required_bytes];

        // Step 3: Convert each 24-bit pixel into 3 bytes
        for (int i = 0; i < in_pixels.size(); i++) begin
            out_bytes[i * 3]     = in_pixels[i][23:16];
            out_bytes[i * 3 + 1] = in_pixels[i][15:8];
            out_bytes[i * 3 + 2] = in_pixels[i][7:0];
        end

    endfunction


    // ==========================================
    // 3. THE RECEIVE API (Bridge to Display)
    // ==========================================
    function void byte_to_pixel(input byte_t in_bytes [], output pixel_t out_pixels []);

        int required_pixels;

        // Step 1: Calculate the required number of pixels
        required_pixels = in_bytes.size() / 3;

        // Step 2: Allocate memory for out_pixels
        out_pixels = new[required_pixels];

        // Step 3: Reconstruct 24-bit pixels from 3 bytes
        for (int i = 0; i < out_pixels.size(); i++) begin
            out_pixels[i] = {
                in_bytes[i * 3],
                in_bytes[i * 3 + 1],
                in_bytes[i * 3 + 2]
            };
        }

    endfunction


    // ==========================================
    // TESTBENCH
    // ==========================================
    initial begin

        // Unpacked dynamic arrays
        pixel_t camera_frame [];
        byte_t  tx_stream [];
        pixel_t display_frame [];

        $display("--- META-VISION AI GLASSES BOOTING ---");

        // Simulate the camera capturing a tiny 2-pixel image
        camera_frame = new[2];

        camera_frame[0] = 24'hFF_AA_CC;
        camera_frame[1] = 24'h11_22_33;

        $display("\n[CAMERA] Captured Frame: %p", camera_frame);

        // 1. Serialize for transmission
        pixel_to_byte(camera_frame, tx_stream);
        $display("[BRIDGE] Transmitting Byte Stream: %p", tx_stream);

        // 2. Deserialize for display
        byte_to_pixel(tx_stream, display_frame);
        $display("[DISPLAY] Reconstructed Frame: %p", display_frame);

        // 3. Verification Check
        if (camera_frame == display_frame) begin
            $display("\n[RESULT] SUCCESS! Image transmitted perfectly.");
        end
        else begin
            $display("\n[RESULT] ERROR! Image corruption detected.");
        end

    end

endmodule
