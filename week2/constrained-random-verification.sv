class Memory_Transaction;
  rand bit [31:0] address;
  rand bit [31:0] data;
  rand bit read_write;

  constraint valid_address { 
    address[1:0] == 2'b00; // Word-aligned
    address inside {[32'h1000:32'h1FFF], [32'h8000:32'h8FFF]}; // Valid ranges
  }
  constraint data_range { 
    data inside {[32'h0:32'hFF], [32'hFF00:32'hFFFF]}; // Specific data ranges
  }
  constraint read_heavy { read_write dist {0 := 70, 1 := 30}; } // 70% reads, 30% writes
endclass

// In testbench
initial begin
  Memory_Transaction trans;
  Memory_Driver driver;

  repeat(1000) begin
    trans = new();
    assert(trans.randomize());
    driver.drive(trans);
    
    // Check for specific conditions
    if (trans.address inside {[32'h1000:32'h1FFF]}) begin
      // Verify behavior for this address range
      assert(trans.data inside {[32'h0:32'hFF]}) else $error("Unexpected data value");
    end
  end
end
