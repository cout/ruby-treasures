/*
 * Ruby Treasures 0.4
 * Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
 * 
 * You may distribute this software under the same terms as Ruby (see the file
 * COPYING that was distributed with this library).
 * 
 */
#include <ruby.h>
#include <node.h>
#include <st.h>
#include <stdlib.h>

/* TODO: Figure out why this doesn't work in 1.7 */

/* TODO: This is not at all thread-safe, but it is optimized for speed
 * (the call stack is a singleton)
 */

/* TODO: For another optimization, this data could be stored somewhere other
 * than in a Ruby array on the heap
 */

typedef struct {
  VALUE stack;
} Ruby_Call_Stack;

Ruby_Call_Stack call_stack = { Qnil };

struct global_entry *current_call_entry;
VALUE current_call = Qnil;

static VALUE ruby_trace_func(VALUE self, VALUE args) {
  char const * event_str = RSTRING(RARRAY(args)->ptr[0])->ptr;

  /* if(event_str[0] == 'c' && event_str[1] == '-') event_str += 2; */
  switch(event_str[0]) {
    case 'c':
      /* call or c-call */
      if(!strcmp(event_str + 1, "all")) {
        rb_ary_push(call_stack.stack, current_call);
      }
      break;
    case 'r':
      /* return or c-return */
      if(!strcmp(event_str + 1, "eturn")) {
        rb_ary_pop(call_stack.stack);
      }
      break;
  }

  current_call = args;
  rb_gvar_set(current_call_entry, args);
  return Qnil;
}

static VALUE ruby_call_stack_bracket(VALUE self, VALUE elem) {
  return rb_ary_entry(
      call_stack.stack,
      RARRAY(call_stack.stack)->len - NUM2INT(elem) - 1);
}

static VALUE ruby_call_stack_to_a(VALUE self) {
  return rb_ary_reverse(rb_obj_dup(call_stack.stack));
}

static void ruby_call_stack_mark(void * call_stack_ptr) {
  rb_gc_mark(call_stack.stack);
}

void Init_call_stack(void) {
  VALUE method = Qnil, proc = Qnil;
  VALUE rb_cCallStack = Qnil;
  VALUE rb_call_stack = Qnil;

  rb_cCallStack = rb_define_class("CallStack", rb_cObject);
  rb_define_method(rb_cCallStack, "[]", ruby_call_stack_bracket, 1);
  rb_define_method(rb_cCallStack, "to_a", ruby_call_stack_to_a, 0);

  call_stack.stack = rb_ary_new();
  rb_call_stack = Data_Wrap_Struct(
      rb_cCallStack,
      ruby_call_stack_mark,
      NULL,
      &call_stack);
  rb_gv_set("$call_stack", rb_call_stack);

  current_call_entry = rb_global_entry(rb_intern("$current_call"));

  rb_define_global_function("trace_func", ruby_trace_func, -2);
  method = rb_funcall(
      rb_mKernel, rb_intern("method"), 1, ID2SYM(rb_intern("trace_func")));
  proc = rb_funcall3(method, rb_intern("to_proc"), 0, 0);
  rb_funcall(rb_cObject, rb_intern("set_trace_func"), 1, proc);
}

