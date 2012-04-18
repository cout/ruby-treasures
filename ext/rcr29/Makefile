SHELL = /bin/sh

#### Start of system configuration section. ####

srcdir = .
topdir = $(rubylibdir)/$(arch)
hdrdir = $(rubylibdir)/$(arch)
VPATH = $(srcdir)

CC = gcc

CFLAGS   = -fPIC -g -O2 -fPIC 
CPPFLAGS = -I$(hdrdir) -I$(srcdir) -I$(prefix)/include   
CXXFLAGS = $(CFLAGS)
DLDFLAGS =  -L$(exec_prefix)/lib 
LDSHARED = gcc -shared 
LIBPATH = 

RUBY_INSTALL_NAME = ruby
RUBY_SO_NAME = 
arch = i686-linux
ruby_version = 1.6

prefix = $(DESTDIR)/usr/local
exec_prefix = $(prefix)
libdir = $(exec_prefix)/lib
rubylibdir = $(libdir)/ruby/$(ruby_version)
archdir = $(rubylibdir)/$(arch)
sitedir = $(prefix)/lib/ruby/site_ruby
sitelibdir = $(sitedir)/$(ruby_version)
sitearchdir = $(sitelibdir)/$(arch)
target_prefix = 

#### End of system configuration section. ####

LOCAL_LIBS =  
LIBS = -L. -l$(RUBY_INSTALL_NAME) -lc
OBJS = rcr29.o

TARGET = rcr29
DLLIB = $(TARGET).so

RUBY = ruby
RM = $(RUBY) -rftools -e "File::rm_f(*ARGV.map{|x|Dir[x]}.flatten.uniq)"

EXEEXT = 

all:		$(DLLIB)

clean:;		@$(RM) *.o *.so *.sl *.a $(DLLIB)
		@$(RM) $(TARGET).lib $(TARGET).exp $(TARGET).ilk *.pdb $(CLEANFILES)

distclean:	clean
		@$(RM) Makefile extconf.h conftest.* mkmf.log
		@$(RM) core ruby$(EXEEXT) *~ $(DISTCLEANFILES)

realclean:	distclean

install:	$(archdir)$(target_prefix)/$(DLLIB)

site-install:	$(sitearchdir)$(target_prefix)/$(DLLIB)

$(archdir)$(target_prefix)/$(DLLIB): $(DLLIB)
	@$(RUBY) -r ftools -e 'File::makedirs(*ARGV)' $(rubylibdir) $(archdir)$(target_prefix)
	@$(RUBY) -r ftools -e 'File::install(ARGV[0], ARGV[1], 0555, true)' $(DLLIB) $(archdir)$(target_prefix)/$(DLLIB)

$(sitearchdir)$(target_prefix)/$(DLLIB): $(DLLIB)
	@$(RUBY) -r ftools -e 'File::makedirs(*ARGV)' $(libdir) $(sitearchdir)$(target_prefix)
	@$(RUBY) -r ftools -e 'File::install(ARGV[0], ARGV[1], 0555, true)' $(DLLIB) $(sitearchdir)$(target_prefix)/$(DLLIB)


.c.o:
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

.cc.o:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<
.cpp.o:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<
.cxx.o:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<
.C.o:
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<
$(DLLIB): $(OBJS)
	$(LDSHARED) $(DLDFLAGS) -o $(DLLIB) $(OBJS) $(LIBS) $(LOCAL_LIBS)
CFLAGS := $(CFLAGS) -g -Wall -DRUBY_TREASURES
