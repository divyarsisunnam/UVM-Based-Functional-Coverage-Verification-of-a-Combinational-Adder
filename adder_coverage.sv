class adder_coverage extends uvm_subscriber #(adder_sequence_item);

  `uvm_component_utils(adder_coverage)

  adder_sequence_item txn;
  real cov;

  // 1. Define the Covergroup
  covergroup adder_cg;
    option.per_instance = 1;
    option.comment = "Functional Coverage for Adder Inputs";

    // Cover input 1 values
    IN1: coverpoint txn.in1 { 
      bins low    = {[0:3]};   // range 0 to 3
      bins mid_lo = {[4:7]};
      bins mid_hi = {[8:11]};
      bins high   = {[12:15]}; // Fixed range (was 11:15 which overlaps)
    }

    // Cover input 2 values
    IN2: coverpoint txn.in2 { 
      bins low    = {[0:3]};
      bins mid_lo = {[4:7]};
      bins mid_hi = {[8:11]};
      bins high   = {[12:15]}; 
    }
    
    // Cross Coverage (Optional but recommended)
    // Checks if we tested all combinations (e.g., Low IN1 with High IN2)
    CROSS_IN1_IN2: cross IN1, IN2; 

  endgroup: adder_cg

  // 2. Constructor
  function new(string name="adder_coverage", uvm_component parent);
    super.new(name, parent);
    adder_cg = new(); // Create the covergroup
  endfunction

  // 3. Write Function (Samples the data)
  function void write(adder_sequence_item t);
    // Copy the transaction handle so the covergroup can see 'txn.in1'
    txn = t; 
    adder_cg.sample();
  endfunction

  // 4. Extract Phase (Get final score)
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov = adder_cg.get_coverage();
  endfunction

  // 5. Report Phase (Print score)
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV", $sformatf("Functional Coverage achieved: %0.2f%%", cov), UVM_MEDIUM)
  endfunction

endclass: adder_coverage
