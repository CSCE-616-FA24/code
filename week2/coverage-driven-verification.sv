covergroup Memory_Coverage;
  address: coverpoint trans.address {
    bins low = {[32'h1000:32'h1FFF]};
    bins high = {[32'h8000:32'h8FFF]};
  }
  data: coverpoint trans.data {
    bins low = {[32'h0:32'hFF]};
    bins high = {[32'hFF00:32'hFFFF]};
  }
  read_write: coverpoint trans.read_write;
  
  address_data_cross: cross address, data, read_write;
endcovergroup

// In testbench
initial begin
  Memory_Transaction trans;
  Memory_Driver driver;
  Memory_Coverage cov;

  cov = new();

  repeat(10000) begin
    trans = new();
    assert(trans.randomize());
    driver.drive(trans);
    cov.sample();

    // Check coverage and adjust constraints if needed
    if (cov.get_coverage() >= 100) break;
  end

  $display("Final coverage: %f%%", cov.get_coverage());
end
