import uvm_pkg::*;
`include "uvm_macros.svh"
typedef enum {RESET, IDLE, WRITE, READ} OPERATION; // defining a custom type to specify operations for use
typedef enum {NA, FAILED, PASSED} VALIDITY; // defining a custom type to specify test result
