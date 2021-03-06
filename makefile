CFLAGS=-std=gnu11 -Wall -g -O0
all: CPPFLAGS=-std=c++11 -Wall -g -O0
optimize: CPPFLAGS=-std=c++11 -Wall -g -O1

SOURCES_CPP=$(wildcard src/*.cpp) 
SOURCES_C=$(wildcard src/*.c)

OBJDIR=obj
OBJECTS=$(addprefix $(OBJDIR)/,$(notdir $(SOURCES_CPP:.cpp=.o))) $(addprefix $(OBJDIR)/,$(notdir $(SOURCES_C:.c=.o)))

EXECUTABLE=comp

all: $(OBJDIR) $(SOURCES_CPP) $(SOURCES_C) $(EXECUTABLE) 
    
# Compiles all files with first level of optimization, instead
# of none.
optimize: $(OBJDIR) $(SOURCES_CPP) $(SOURCES_C) $(EXECUTABLE) 

$(EXECUTABLE): $(OBJECTS) 
	g++ -o $@ $^

# Including all .d files, that contain the make statements
# describing depencencies of a files based on #include
# statements. This is needed, so that changes to header files
# get noticed, and apropriate files that depend on them get
# recompiled. The dependencies get generated with compilers -MM
# option. 
-include $(OBJDIR)/*.d

$(OBJDIR)/%.o: src/%.cpp
	g++ -c $(CPPFLAGS) -o $@ $< 
	g++ -MM $(CPPFLAGS) -MT '$@' src/$*.cpp > $(OBJDIR)/$*.d

$(OBJDIR)/%.o: src/%.c
	gcc -c $(CFLAGS) -o $@ $<
	gcc -MM $(CFLAGS) -MT '$@' src/$*.c > $(OBJDIR)/$*.d

# Creates 'obj' directory if it doesent exist
$(OBJDIR):
	mkdir -p $(OBJDIR)

clean:
	rm -f $(OBJDIR)/* $(EXECUTABLE)

# Convert a drawing textfile to a drawing.hpp, containing
# that textfile in a string constant.
src/drawing3D.hpp: src/resources/drawing3D
	./tools/parseDrawing drawing3D > /tmp/drawing.hpp
	mv -f /tmp/drawing.hpp src/drawing3D.hpp

# Convert a drawing textfile to a drawing.hpp, containing
# that textfile in a string constant.
src/drawing3Db.hpp: src/resources/drawing3Db
	./tools/parseDrawing drawing3Db > /tmp/drawing.hpp
	mv -f /tmp/drawing.hpp src/drawing3Db.hpp

# Convert a drawing textfile to a drawing.hpp, containing
# that textfile in a string constant.
src/drawing2D.hpp: src/resources/drawing2D
	./tools/parseDrawing drawing2D > /tmp/drawing.hpp
	mv -f /tmp/drawing.hpp src/drawing2D.hpp

# Convert environment.c to environment_const_string.hpp,
# containing that file in a string constant.
src/environment_const_string.hpp: src/environment.c
	./tools/parseEnvironment > /tmp/environment_const_string.hpp
	mv -f /tmp/environment_const_string.hpp src/environment_const_string.hpp
