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

VALUE ruby_each_instance_variable(VALUE self) {
    int j;
    VALUE instance_vars = rb_obj_instance_variables(self);
    VALUE yield_value = rb_ary_new2(2);
    struct RArray * instance_vars_ary = RARRAY(instance_vars);
    struct RArray * yield_value_ary = RARRAY(yield_value);
    ID id;
    yield_value_ary->len = 2;
    
    for(j = 0; j < instance_vars_ary->len; ++j) {
        id = rb_intern(STR2CSTR(instance_vars_ary->ptr[j]));
        yield_value_ary->ptr[0] = ID2SYM(id);
        yield_value_ary->ptr[1] = rb_ivar_get(self, id);
        rb_yield(yield_value);
    }

    return Qnil;
}

void Init_each_instance_variable(void) {
    rb_define_private_method(rb_cObject, "each_instance_variable", ruby_each_instance_variable, 0);
}

