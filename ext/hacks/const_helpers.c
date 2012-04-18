/*
 * Ruby Treasures 0.4
 * Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
 * 
 * You may distribute this software under the same terms as Ruby (see the file
 * COPYING that was distributed with this library).
 * 
 */
#include <ruby.h>
#include <intern.h>
#include "safe_send.h"

#define OBJ_UNFREEZE(x) FL_UNSET((x), FL_FREEZE)

static VALUE send_array(VALUE args) {
  return ruby_safe_send(RARRAY(args)->len, RARRAY(args)->ptr, rb_mKernel);
}

static VALUE freeze_array(VALUE args) {
  int j;
  for(j = 0; j < RARRAY(args)->len; ++j) {
    OBJ_FREEZE(RARRAY(args)->ptr[j]);
  }
  return Qnil;
}

static VALUE unfreeze_array(VALUE args) {
  int j;
  for(j = 0; j < RARRAY(args)->len; ++j) {
    OBJ_UNFREEZE(RARRAY(args)->ptr[j]);
  }
  return Qnil;
}

static VALUE ruby_const_send(VALUE self, VALUE args) {
  if(OBJ_FROZEN(RARRAY(args)->ptr[0])) {
    send_array(args);
  } else {
    VALUE objects_to_unfreeze = rb_ary_new3(1, RARRAY(args)->ptr[0]);
    OBJ_FREEZE(RARRAY(args)->ptr[0]);
    return rb_ensure(send_array, args, unfreeze_array, objects_to_unfreeze);
  }
  return Qnil;
}

static VALUE ruby_mutable_send(VALUE self, VALUE args) {
  if(!OBJ_FROZEN(RARRAY(args)->ptr[0])) {
    send_array(args);
  } else {
    VALUE objects_to_freeze = rb_ary_new3(1, RARRAY(args)->ptr[0]);
    OBJ_UNFREEZE(RARRAY(args)->ptr[0]);
    return rb_ensure(send_array, args, freeze_array, objects_to_freeze);
  }
  return Qnil;
}

static VALUE ruby_const_var(VALUE self, VALUE args) {
  int j;
  VALUE objects_to_unfreeze = rb_ary_new();
  VALUE elem;

  for(j = 0; j < RARRAY(args)->len; ++j) {
    elem = RARRAY(args)->ptr[j];
    if(!OBJ_FROZEN(elem)) {
      OBJ_FREEZE(elem);
      rb_ary_push(objects_to_unfreeze, elem);
    }
  }

  return rb_ensure(rb_yield, args, unfreeze_array, objects_to_unfreeze);
}

void Init_const_helpers(void) {
  rb_require("safe_send.so");
  rb_define_global_function("const_send", ruby_const_send, -2);
  rb_define_global_function("mutable_send", ruby_mutable_send, -2);
  rb_define_global_function("const_var", ruby_const_var, -2);
}

