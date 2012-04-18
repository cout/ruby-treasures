/*
 * Ruby Treasures 0.4
 * Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
 * 
 * You may distribute this software under the same terms as Ruby (see the file
 * COPYING that was distributed with this library).
 * 
 */
#include <ruby.h>
#include <rubyio.h>

static VALUE ruby_setvbuf(VALUE self, VALUE mode, VALUE buf)
{
  char * c_buf = (buf == Qnil) ? NULL : STR2CSTR(buf);
  size_t size = (buf == Qnil) ? 0 : RSTRING(buf)->len;
  int c_mode = NUM2INT(mode);
  OpenFile * fptr;
  FILE * f1, * f2;

  GetOpenFile(self, fptr);
  f1 = GetReadFile(fptr);
  f2 = GetWriteFile(fptr);

  rb_ivar_set(self, rb_intern("setvbuf_buffer"), buf);

  setvbuf(f1, c_buf, c_mode, size);
  if(f1 != f2)
  {
    setvbuf(f2, c_buf, c_mode, size);
  }

  return Qnil;
}

void Init_setvbuf()
{
  rb_define_method(rb_cIO, "setvbuf", ruby_setvbuf, 2);
  rb_define_const(rb_cIO, "NBF", INT2NUM(_IONBF));
  rb_define_const(rb_cIO, "LBF", INT2NUM(_IOLBF));
  rb_define_const(rb_cIO, "FBF", INT2NUM(_IOFBF));
}

