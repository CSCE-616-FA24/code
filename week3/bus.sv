/*
This program simulates a simple memory-mapped bus communication system using SystemVerilog.
*/

class Bus;
  rand bit [31:0] data;
  rand bit [7:0] address;
  bit [31:0] memory[256]; // An array of 256 32-bit element

  function new();
    data = 0;
    address = 0;
    memory = new[256];
    memory.randomize() with { item == $random; };
  endfunction

  task read(input bit [7:0] addr, output bit [31:0] data);
    address = addr;
    data = memory[addr];
    $display("Read from address 0x%h, Data: 0x%h", addr, data);
  endtask

  task write(input bit [7:0] addr, input bit [31:0] data);
    address = addr;
    memory[addr] = data;
    $display("Write to address 0x%h, Data: 0x%h", addr, data);
  endtask
endclass

module CPU #(Bus bus);
  initial begin
    bit [31:0] read_data;
    bit [31:0] write_data;

    // Read from memory
    bus.read(0x10, read_data);

    // Modify and write to memory
    write_data = read_data + 1;
    bus.write(0x10, write_data);
  end
endmodule

module GPU #(Bus bus);
  initial begin
    bit [31:0] read_data;

    // Read from a different memory location
    bus.read(0x20, read_data);
  end
endmodule

module TestBus;
  Bus bus = new();
  CPU #(bus) cpu(); // Same bus instance is passed as an argument to the CPU
  GPU #(bus) gpu(); // Same bus instance is passed as an argument to the GPU
  
  initial begin
    // Simulate CPU and GPU operations
    $finish;
  end
endmodule
