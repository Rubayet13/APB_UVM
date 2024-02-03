class apb_base_test extends uvm_test;
  `uvm_component_utils(apb_base_test)

  function new(input string name = "test", uvm_component c);
    super.new(name,c);
  endfunction

  //env e;


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //e=env::type_id::create("e", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

  endfunction

  virtual task run_phase(uvm_phase phase);

  endtask
endclass