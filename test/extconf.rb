# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'rbconfig'

f = File.open('Makefile', 'w')
f.puts <<END

TESTS= \\
	test_accessors \\
	test_alias_class_method \\
	test_automatic_object \\
	test_base_class_intercept \\
	test_call_stack \\
	test_const_method \\
	test_const_and_mutable_refs \\
	test_const_var \\
	test_dumpable_proc \\
	test_each_instance_variable \\
	test_evil_send \\
	test_exception_extensions \\
	test_finalize \\
	test_fix_trace_func \\
	test_holder \\
	test_interface \\
	test_kernelless_object \\
	test_lazy_evaluator \\
	test_method_missing_delegate \\
	test_not_copyable \\
	test_observable_method \\
	test_path_concat \\
	test_private_class_vars \\
	test_private_instance_vars \\
	test_refcount \\
	test_rollback \\
	test_safe_method \\
	test_safe_mixin \\
	test_super_method \\
	test_time_block \\
	test_to_proc \\
	test_with

RUBY = #{Config::CONFIG['ruby_install_name']} -w

test: $(TESTS)

all:

install:

clean:

distclean:

realclean:

$(TESTS):
	$(RUBY) $@.rb

.PHONY : test $(TESTS)

END

