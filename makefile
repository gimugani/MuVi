CXX=g++ -D__MACOSX_CORE__
INCLUDES=
FLAGS=-c
LIBS=-framework CoreAudio -framework CoreMIDI -framework CoreFoundation \
	-framework IOKit -framework Carbon  -framework OpenGL \
	-framework GLUT -framework Foundation \
	-framework AppKit -lstdc++ -lm

OBJS=   RtAudio.o chuck_fft.o MuVi.o Thread.o Stk.o

MuVi: $(OBJS)
	$(CXX) -o MuVi $(OBJS) $(LIBS)

RtAudio.o: RtAudio.h RtAudio.cpp RtError.h
	$(CXX) $(FLAGS) RtAudio.cpp

chuck_fft.o: chuck_fft.h chuck_fft.c
	$(CXX) $(FLAGS) chuck_fft.c

Thread.o: Thread.h Thread.cpp
	$(CXX) $(FLAGS) Thread.cpp

Stk.o: Stk.h Stk.cpp
	$(CXX) $(FLAGS) Stk.cpp

clean:
	rm -f *~ *# *.o MuVi
