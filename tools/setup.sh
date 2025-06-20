#!/bin/bash
set -e

# Cross-platform initialization
detect_platform() {
    case "$(uname -s)" in
        Linux*) PLATFORM=Linux;;
        Darwin*) PLATFORM=Mac;;
        CYGWIN*|MINGW*|MSYS*) PLATFORM=Windows;;
        *) echo "Unsupported platform"; exit 1;;
    esac
}

setup_dependencies() {
    echo "Installing RIFT-Bridge dependencies..."
    
    # Install Emscripten
    if ! command -v emcc &> /dev/null; then
        git clone https://github.com/emscripten-core/emsdk.git
        cd emsdk
        ./emsdk install latest
        ./emsdk activate latest
        source ./emsdk_env.sh
        cd ..
    fi
    
    # Install WABT
    if ! command -v wat2wasm &> /dev/null; then
        git clone --recursive https://github.com/WebAssembly/wabt
        cd wabt
        mkdir build && cd build
        cmake ..
        cmake --build .
        sudo cmake --build . --target install
        cd ../..
    fi
    
    # Create project structure
    mkdir -p build/{debug,release}
    mkdir -p obj/{core,modules,drivers,final}
    mkdir -p test/{unit,integration,fixtures}
}

detect_platform
setup_dependencies

echo "RIFT-Bridge development 
environment ready!"
