/*
 * Ruby Treasures 0.4
 * Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
 * 
 * You may distribute this software under the same terms as Ruby (see the file
 * COPYING that was distributed with this library).
 * 
 */
#include <ruby.h>
#include <version.h>
#include <assert.h>

#ifdef WIN32
#   include <windows.h>
#else
#   include <unistd.h>
#   include <fcntl.h>
#endif

#ifdef WIN32
static VALUE RB_QUOTE;
static VALUE RB_QUOTED_QUOTE;
#endif

extern VALUE ruby_errinfo;

#ifdef WIN32
/* ----------------------------------------------------------------------
 * WIN32 implementation
 * TODO: I don't know if this works, but it looks like it should.
 * ----------------------------------------------------------------------
 */
static VALUE fork_and_proc_exec(int argc, VALUE *argv) {
    PROCESS_INFORMATION pi;
    STARTUPINFO si;
    BOOL retval;

    /* Generate a quoted command line */
    VALUE cmd = rb_str_new();
    VALUE arg;
    for(j = 0; j < argc; ++j) {
        rb_str_cat2(cmd, QUOTE_STR);
        arg = rb_funcall(cmd, "gsub", 2, RB_QUOTE, RB_QUOTED_QUOTE);
        rb_str_cat3(cmd, argv[j]);
        rb_str_cat2(cmd, QUOTE_STR);
    }

    ZeroMemory(&si, sizeof(si));
    ZeroMemory(&pi, sizeof(pi));

    /* TODO: I've read that CreateProcess doesn't allow the child process
     * to inherit all the file handles; some magic is required to get
     * this to happen (which apparently spawnv does). */
    retval = CreateProcess(
        NULL,                   /* lpApplicationName    */
        cmd,                    /* lpCommandLine        */
        NULL,                   /* lpProcessAttributes  */
        NULL,                   /* lpThreadAttributes   */
        TRUE,                   /* bInheritHandles      */
        0,                      /* dwCreationFlags      */
        NULL,                   /* lpEnvironment        */
        NULL,                   /* lpCurrentDirectory   */
        &si,                    /* lpStartupInfo        */
        &pi)                    /* lpProcessInformation */

    if(retval) {
        return INT2NUM(pi.hProcess);
    } else {
        rb_raise(rb_eRuntimeError, "CreateProcess failed");
    }
}

#else /* !defined(WIN32) */
/* ----------------------------------------------------------------------
 * Unix implementation
 * ----------------------------------------------------------------------
 */

struct Exec_Args {
    int argc;
    VALUE *argv;
};

#if RUBY_VERSION_CODE < 170
static VALUE rb_f_exec(int argc, VALUE * argv) {
    return rb_funcall2(rb_mKernel, rb_intern("exec"), argc, argv);
}
static VALUE rb_marshal_dump(VALUE obj, VALUE port) {
    int argc = 1;
    VALUE argv[2];

    argv[0] = obj;
    argv[1] = port;
    if (!NIL_P(port)) argc = 2;

    return rb_funcall2(rb_mKernel, rb_intern("dump"), argc, argv);
}
static VALUE rb_marshal_load(VALUE port) {
    return rb_funcall2(rb_mKernel, rb_intern("load"), 1, &port);
}
#endif

/* TODO: If rb_f_exec uses /bin/sh, then we won't get notified of errors */
static VALUE do_exec(VALUE args) {
    struct Exec_Args *exec_args = (struct Exec_Args *)args;
    return rb_f_exec(exec_args->argc, exec_args->argv);
}

static VALUE my_proc_exec_v(int argc, VALUE *argv) {
    struct Exec_Args args = { argc, argv };
    int state;
    rb_protect(do_exec, (VALUE)&args, &state);

    /* If we got here, then there was an error */
    if(state == 0) {
        return rb_exc_new2(rb_eRuntimeError, "exec returned success?");
    } else {
        return ruby_errinfo;
    }
}

/* Based on fork_and_exec from Wine */
static VALUE fork_and_proc_exec(int argc, VALUE *argv) {
    int fd[2];
    int pid;
    VALUE exc;
    VALUE marshal_data;
    size_t size;

    if(pipe(fd) == -1) {
        /* errno should already be set */
        return -1;
    }

    /* set close on exec */
    fcntl(fd[1], F_SETFD, 1);

    if(!(pid = fork())) {
        /* child */
        close(fd[0]);
        exc = my_proc_exec_v(argc, argv);

        marshal_data = rb_marshal_dump(exc, Qnil);
        assert(rb_obj_is_kind_of(marshal_data, rb_cString));
        size = RSTRING(marshal_data)->len;
        write(fd[1], &size, sizeof(size));
        write(fd[1], RSTRING(marshal_data)->ptr, size);
        _exit(1);
    } else {
        /* parent */
        close(fd[1]);
        if(pid == 0) {
            /* fork failed */
            close(fd[0]);
            rb_sys_fail("fork");
        }
        if((read(fd[0], &size, sizeof(size)) > 0)) {
            /* exec failed */
            char *data = ALLOC_N(char, size);
            if(read(fd[0], data, size) <= 0) {
                close(fd[0]);
                rb_raise(rb_eRuntimeError, "unable to read error info");
            }
            close(fd[0]);
            marshal_data = rb_str_new2(data);
            rb_exc_raise(rb_marshal_load(marshal_data));
        }
    }

    close(fd[0]);
    return INT2NUM(pid);
}

#endif /* ifdef WIN32 */

/* ----------------------------------------------------------------------
 * Common code
 * ----------------------------------------------------------------------
 */

static VALUE ruby_spawn(int argc, VALUE * argv, VALUE self) {
    if(argc < 0) {
       rb_raise(rb_eArgError, "Wrong # of arguments");
    } 

    return fork_and_proc_exec(argc, argv);
}

void Init_spawn(void) {
#   ifdef WIN32
    RB_QUOTE = rb_str_new2("\"");
    RB_QUOTED_QUOTE = rb_str_new2("\\\"");
#   endif
    rb_define_global_function("spawn", ruby_spawn, -1);
}

