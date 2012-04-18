/*
 * Ruby Treasures 0.4
 * Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
 * 
 * You may distribute this software under the same terms as Ruby (see the file
 * COPYING that was distributed with this library).
 * 
 */
/* A Ruby extenstion that implements RCR#29:
 *
 *  More Reflection - Sat, Aug 25 @ 05:45 PM
 *  Matju suggests a list of extensions to class Binding to add more reflection.
 *
 *  Binding#selector
 *      returns symbol that was used in the method lookup that created this
 *      binding.
 *  Binding#method
 *      returns method called that created this binding (the result of the
 *      method lookup)
 *  Binding#caller
 *      returns binding from which the current binding was created.
 *  Binding#caller_line
 *      returns [line_num,filename] from which the current binding was created.
 *  binding==binding
 *      something that should be true.
 *  Binding#parent
 *      returns outer binding, such that (0..0).map { binding.parent }[0] ==
 *      binding (not sure this makes sense with current Ruby)
 *  Binding#[](key) and Binding#[]=(key,value)
 *      for accessing local variables. Key may be symbol or string, but
 *      strings are implicitly cast to symbols.
 */

#include <ruby.h>
#include <intern.h>
#include <env.h>
#include "block.h"
#include "block.i"

static VALUE rb_cBinding = Qnil;

static VALUE binding_selector(VALUE self) {
    /* TODO */
    return Qnil;
}

static VALUE binding_method(VALUE self) {
    struct BLOCK *block;
    Data_Get_Struct(self, struct BLOCK, block);
    return rb_ary_new3(2,
        INT2NUM(block->frame.line),
        rb_str_new2(block->frame.file));
}

static VALUE binding_caller(VALUE self) {
    struct BLOCK *block;
    Data_Get_Struct(self, struct BLOCK, block);
    return ID2SYM(block->frame.last_func);
}

static VALUE binding_caller_line(VALUE self) {
    struct BLOCK *block;
    Data_Get_Struct(self, struct BLOCK, block);
    return INT2NUM(block->frame.last_func);
}

static VALUE binding_eq(VALUE self, VALUE other) {
    /* TODO */
    return Qnil;
}

/* TODO: This returns the parent of the binding, but the parent is not
 * necessarily the calling function.
 */
static VALUE binding_parent(VALUE self) {
    VALUE bind;
    struct BLOCK *block, *data, *p;
    struct RVarmap *vars;

    /* First, get the previous block */
    Data_Get_Struct(self, struct BLOCK, block);
    if(block->prev == 0) {
        rb_raise(rb_eRuntimeError, "binding has no parent");
    }
    bind = Data_Make_Struct(rb_cBinding,struct BLOCK,blk_mark,blk_free,data);
    *data = *block->prev;

    /* From here on out we essentially emulate rb_f_binding, but applied to
     * the previous block instead of the current one.
     */

    /* 1) orig_thread is only necessary to determine if the binding is an
     * orphan.  It is not set by default, so we must set it to something.
     * Setting it to Qnil should ensure that orig_thread is never equal to
     * another thread, and should ensure that the binding will always be
     * recognized as an orphan.
     */
    data->orig_thread = Qnil;

    /* 2) wrapper and iter should both already be set. */

    /* 3) call frame_dup */
    frame_dup(&data->frame);

    /* 4) copy last_func and last_class */
    /* TODO: I'm not sure yet what to set these to? */

    /* 5) set BLOCK_DYNAMIC */
    data->flags |= BLOCK_DYNAMIC;
    data->tag->flags |= BLOCK_DYNAMIC;

    /* 6) set DVAR_DONT_RECYCLE */
    for (p = data; p; p = p->prev) {
        for (vars = p->dyna_vars; vars; vars = vars->next) {
            if (FL_TEST(vars, DVAR_DONT_RECYCLE)) break;
            FL_SET(vars, DVAR_DONT_RECYCLE);
        }
    }

    /* 7) duplicate the scope */
    scope_dup(data->scope);

    printf("parent binding: %d\n", bind);
    return bind;
}

static VALUE binding_bracket(VALUE self, VALUE key) {
    /* TODO */
    return Qnil;
}

static VALUE binding_bracket_equals(VALUE self, VALUE key, VALUE value) {
    /* TODO */
    return Qnil;
}

void Init_rcr29(void) {
    rb_cBinding = rb_const_get(rb_mKernel, rb_intern("Binding"));

    rb_define_method(rb_cBinding, "selector", binding_selector, 0);
    rb_define_method(rb_cBinding, "method", binding_method, 0);
    rb_define_method(rb_cBinding, "caller", binding_caller, 0);
    rb_define_method(rb_cBinding, "caller_line", binding_caller_line, 0);
    rb_define_method(rb_cBinding, "==", binding_eq, 1);
    rb_define_method(rb_cBinding, "parent", binding_parent, 0);
    rb_define_method(rb_cBinding, "[]", binding_bracket, 1);
    rb_define_method(rb_cBinding, "[]=", binding_bracket_equals, 2);
}

