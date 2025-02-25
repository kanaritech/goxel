CC := gcc
CXX := g++
# LD := /ucrt64/bin/ld
WIN_LIBS := -lglfw3 -lopengl32 -lz /mingw64/lib/libtre.a -lgdi32 -lcomdlg32 -lole32 -luuid -lshell32

# -DGLEW_STATIC
CFLAGS := -std=gnu99 -Wall -DGLEW_STATIC
CXXFLAGS := -std=gnu++17 -Wall -Wno-unknown-pragma -Wno-unknown-warning-option -DGLEW_STATIC
# LDFLAGS := -L/ucrt64/lib
LIBS := $(WIN_LIBS)

# Configuración del modo de compilación
MODE ?= debug
ifeq ($(MODE), debug)
    CFLAGS += -O0 -g
    CXXFLAGS += -O0 -g
else ifeq ($(MODE), release)
    CFLAGS += -O3 -DNDEBUG
    CXXFLAGS += -O3 -DNDEBUG
else ifeq ($(MODE), profile)
    CFLAGS += -g
    CXXFLAGS += -g
endif

# Configuración de bibliotecas y rutas de inclusión
INCLUDES := -Isrc -Iext_src -Iext_src/glew -Iext_src/uthash -Iext_src/stb -Iext_src/nfd -Iext_src/noc -Iext_src/xxhash -Iext_src/meshoptimizer -I/mingw64/include -I/mingw64/include/tre

# Detectar archivos fuente automáticamente
SOURCES := $(shell find src -type f \( -name "*.c" -o -name "*.cpp" \)) ext_src/nfd/nfd_win.cpp ext_src/glew/glew.c
OBJECTS := $(SOURCES:.c=.o)
OBJECTS := $(OBJECTS:.cpp=.o)

# Binario final
TARGET := goxel.exe

# Regla principal
all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(LDFLAGS) $^ -o $@ $(LIBS)

%.o: %.c
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Limpieza de archivos generados
clean:
	rm -f $(OBJECTS) $(TARGET)