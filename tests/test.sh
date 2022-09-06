#!/bin/bash

# Usage: ./tests/test.sh function_name fn_arg1 fn_arg2 fn_argN

# tests a single function
/bin/bash -euc "source functions.sh; $*"
