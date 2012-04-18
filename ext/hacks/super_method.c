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
#include <node.h>
#include "safe_send.h"
#include "struct_method.h"

static VALUE rb_cMethod;
static ID id_instance_method;
static VALUE sym_call;

VALUE ruby_super_method(VALUE self, VALUE klass, VALUE method_name) {
  VALUE umethod;
  VALUE method;
  struct METHOD * data;
  struct METHOD * bound;

  if(!rb_obj_is_kind_of(self, klass)) {
    rb_raise(rb_eTypeError, "Given object is not a %s", rb_class2name(klass));
  } 

  umethod = rb_funcall(klass, id_instance_method, 1, method_name);

  Data_Get_Struct(umethod, struct METHOD, data);
  method = Data_Make_Struct(rb_cMethod,struct METHOD,bm_mark,free,bound);
  *bound = *data;
  bound->recv = self;

  return method;
}

/* TODO: This could be optimized better */
VALUE ruby_super_call(int argc, VALUE * argv, VALUE self) {
  VALUE klass;
  VALUE method_name;
  VALUE args;
  rb_scan_args(argc, argv, "2*", &klass, &method_name, &args);

  argv[0] = ruby_super_method(self, klass, method_name);
  argv[1] = sym_call;
  return ruby_safe_send(argc, argv, Qnil);
}

void Init_super_method(void) {
  rb_require("safe_send.so");

  rb_cMethod = rb_const_get(rb_cObject, rb_intern("Method"));
  id_instance_method = rb_intern("instance_method");
  sym_call = ID2SYM(rb_intern("call"));
  rb_global_variable(&sym_call);

  rb_define_private_method(rb_cObject, "super_method", ruby_super_method, 2);
  rb_define_private_method(rb_cObject, "super_call", ruby_super_call, -1);
}

