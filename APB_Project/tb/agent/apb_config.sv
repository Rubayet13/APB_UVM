class abp_config extends uvm_object; /////configuration of env
  `uvm_object_utils(abp_config)
  
  function new(string name = "abp_config");
    super.new(name);
  endfunction
  
  uvm_active_passive_enum is_active = UVM_ACTIVE; 
endclass