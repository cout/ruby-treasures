/*
 * Ruby Treasures 0.4
 * Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
 * 
 * You may distribute this software under the same terms as Ruby (see the file
 * COPYING that was distributed with this library).
 * 
 */
#include <ruby.h>
#include <st.h>
#include <version.h> /* TODO: How do we make sure this is the Ruby version.h? */

static VALUE rb_kernelless_object = Qnil;

/* From the Ruby source (object.c) */
static VALUE boot_defclass(char *name, VALUE super) {
  extern st_table *rb_class_tbl;
  VALUE obj;
  ID id;

#if RUBY_VERSION_CODE >= 170
  obj = rb_class_boot(super);
#else
  obj = rb_class_new(super);
#endif

  id = rb_intern(name);
  
  rb_name_class(obj, id);
  st_add_direct(rb_class_tbl, id, obj);
  return obj;
}   

/* From the Ruby source (object.c) */
static VALUE rb_obj_dummy() {
  return Qnil;
}

void Init_kernelless_object(void) {
  VALUE metaclass;

  rb_undef_method(rb_mKernel, "init_kernelless_object");
  
  rb_kernelless_object = boot_defclass("KernellessObject", 0);
  metaclass = RBASIC(rb_kernelless_object)->klass =
    rb_singleton_class_new(rb_cClass);
  rb_singleton_class_attached(metaclass, rb_kernelless_object);

  rb_define_private_method(rb_kernelless_object, "initialize", rb_obj_dummy, 0);
  rb_define_method(rb_kernelless_object, "__instance_eval__",
      rb_obj_instance_eval, -1);
}

