class write_data extends uvm_sequence#(transaction);
  `uvm_object_utils(write_data)
  
  transaction tr;

  function new(string name = "write_data");
    super.new(name);
  endfunction
  
  virtual task body();
    repeat(15)
      begin
        tr = transaction::type_id::create("tr");
        tr.addr_c.constraint_mode(1);//enable 
        tr.addr_c_err.constraint_mode(0);//disable
        start_item(tr);
        assert(tr.randomize);
        tr.op = writed;
        finish_item(tr);
      end
  endtask
  

endclass