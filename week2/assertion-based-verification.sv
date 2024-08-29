module memory_controller(
  input clk, reset,
  input [31:0] address, write_data,
  input read_write, valid,
  output reg [31:0] read_data,
  output reg ready
);

  // Controller implementation...

  // Assertions
  property valid_ready_relation;
    @(posedge clk) valid |-> ##[1:5] ready;
  endproperty

  assert property (valid_ready_relation)
    else $error("Ready not asserted within 5 cycles of Valid");

  property no_address_change;
    @(posedge clk) (valid && !ready) |=> $stable(address);
  endproperty

  assert property (no_address_change)
    else $error("Address changed while transaction in progress");

  property read_data_valid;
    @(posedge clk) (ready && !read_write) |-> !$isunknown(read_data);
  endproperty

  assert property (read_data_valid)
    else $error("Read data is unknown when ready asserted");

  // Assume statements for inputs
  assume property (@(posedge clk) !$isunknown(valid));
  assume property (@(posedge clk) valid |-> !$isunknown(address));

endmodule
