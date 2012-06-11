struct METHOD {
    VALUE klass, oklass;
    VALUE recv;
    ID id, oid;
    NODE *body;
};
static void
bm_mark(data)
    struct METHOD *data;
{
    rb_gc_mark(data->oklass);
    rb_gc_mark(data->klass);
    rb_gc_mark(data->recv);
    rb_gc_mark((VALUE)data->body);
}
