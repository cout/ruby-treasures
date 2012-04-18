#include "block.h"
static void
scope_dup(scope)
    struct SCOPE *scope;
{
    ID *tbl;
    VALUE *vars;

    scope->flag |= SCOPE_DONT_RECYCLE;
    if (scope->flag & SCOPE_MALLOC) return;

    if (scope->local_tbl) {
	tbl = scope->local_tbl;
	vars = ALLOC_N(VALUE, tbl[0]+1);
	*vars++ = scope->local_vars[-1];
	MEMCPY(vars, scope->local_vars, VALUE, tbl[0]);
	scope->local_vars = vars;
	scope->flag |= SCOPE_MALLOC;
    }
}
static void
blk_mark(data)
    struct BLOCK *data;
{
    while (data) {
	rb_gc_mark_frame(&data->frame);
	rb_gc_mark(data->scope);
	rb_gc_mark(data->var);
	rb_gc_mark(data->body);
	rb_gc_mark(data->self);
	rb_gc_mark(data->dyna_vars);
	rb_gc_mark(data->klass);
	rb_gc_mark(data->tag);
	rb_gc_mark(data->wrapper);
	data = data->prev;
    }
}
static void
blk_free(data)
    struct BLOCK *data;
{
    struct FRAME *frame;
    void *tmp;

    frame = data->frame.prev;
    while (frame) {
	if (frame->argc > 0 && (frame->flags & FRAME_MALLOC))
	    free(frame->argv);
	tmp = frame;
	frame = frame->prev;
	free(tmp);
    }
    while (data) {
	if (data->frame.argc > 0)
	    free(data->frame.argv);
	tmp = data;
	data = data->prev;
	free(tmp);
    }
}
static void
frame_dup(frame)
    struct FRAME *frame;
{
    VALUE *argv;
    struct FRAME *tmp;

    for (;;) {
	if (frame->argc > 0) {
	    argv = ALLOC_N(VALUE, frame->argc);
	    MEMCPY(argv, frame->argv, VALUE, frame->argc);
	    frame->argv = argv;
	    frame->flags = FRAME_MALLOC;
	}
	frame->tmp = 0;		/* should not preserve tmp */
	if (!frame->prev) break;
	tmp = ALLOC(struct FRAME);
	*tmp = *frame->prev;
	frame->prev = tmp;
	frame = tmp;
    }
}
