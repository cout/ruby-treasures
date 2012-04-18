/*
 * Ruby Treasures 0.4
 * Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
 * 
 * You may distribute this software under the same terms as Ruby (see the file
 * COPYING that was distributed with this library).
 * 
 */
#include <ruby.h>

static VALUE safe_send_helper(VALUE args) {
  return rb_funcall3(
      RARRAY(args)->ptr[0],
      SYM2ID(RARRAY(args)->ptr[1]),
      RARRAY(args)->len - 2,
      &RARRAY(args)->ptr[2]);
}

static VALUE safe_send_yield(VALUE arg, VALUE dummy) {
  return rb_yield(arg);
}

VALUE ruby_safe_send(int argc, VALUE * argv, VALUE self) {
  if(argc < 2) {
    rb_raise(rb_eArgError, "Not enough arguments");
  }

  if(rb_block_given_p()) {
    VALUE args;
    rb_scan_args(argc, argv, "*", &args);
    return rb_iterate(safe_send_helper, args, safe_send_yield, Qnil);
  } else {
    return rb_funcall3(argv[0], SYM2ID(argv[1]), argc - 2, &argv[2]);
  }
}

void Init_safe_send(void) {
  rb_undef_method(rb_mKernel, "init_safe_send");
  rb_define_global_function("safe_send", ruby_safe_send, -1);
}

