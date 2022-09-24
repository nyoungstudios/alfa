#!/bin/bash

# Usage: ./tools/test.sh entry_name function_name fn_arg1 fn_arg2 fn_argN

# tests a single function
name=$1
shift
/bin/bash -euc "source functions/$name/install.sh; $*"
