# Linux Kernel Build Environment

This setup provides a Docker-based Linux environment for compiling the Linux kernel on **any platform with Docker support** (macOS, Linux, Windows with WSL2), with full **cross-compilation support** for multiple architectures. Build x86_64, ARM64, ARM, and RISC-V kernels from any host system!

## Platform Compatibility

This build environment works on any system with Docker support:

### ✅ Supported Platforms
- **macOS** (Intel and Apple Silicon)
- **Linux** (any distribution with Docker)
- **Windows** (with WSL2 and Docker Desktop)
- **Cloud environments** (AWS, Google Cloud, Azure, etc.)

### Prerequisites
- Docker installed and running
- Bash-compatible shell (bash, zsh, etc.)
- Git (for cloning kernel source)

### Shell Compatibility
- **macOS/Linux**: Works with bash, zsh, fish (with minor adaptations)
- **Windows**: Use WSL2 with bash or zsh

## Quick Start

1. **Build the Docker environment:**
   ```bash
   ./build-kernel-env.sh
   ```
2. **Add commnd definition in shell rc file (.bashrc in example)**
   ```bash
   cat func_def.shell >> ~/.bashrc
   source ~/.bashrc
   ```
3. **Start compiling the kernel:**
   ```bash
   # Native ARM64 compilation
   kmake defconfig
   kmake -j$(nproc)
   
   # Cross-compile for x86_64
   kmake ARCH=x86_64 defconfig
   kmake ARCH=x86_64 -j$(nproc)
   
   # Or use convenience functions
   kmake-x86 defconfig
   kmake-x86 -j$(nproc)
   ```

## Available Commands

### `kmake` - Run make commands in Docker (Optimized)
```bash
kmake menuconfig           # Configure kernel
kmake defconfig           # Use default configuration
kmake                      # Build with auto-detected parallel jobs (all CPU cores)
kmake -j8                 # Override with specific number of parallel jobs
kmake modules             # Build kernel modules
kmake clean               # Clean build artifacts
kmake mrproper            # Clean everything including config
```

### Fast Build Commands
```bash
kfast                      # Quick native ARM64 build (defconfig + compile)
kfast-x86                  # Quick x86_64 build
kfast-arm64                # Quick ARM64 build
kperf defconfig            # Build with performance monitoring and timing
```

### CCache Management
```bash
kccache-stats              # Show compilation cache statistics
kccache-clear              # Clear compilation cache
kccache-zero               # Reset cache statistics
```

### `kshell` - Interactive shell in build environment
```bash
kshell                    # Start interactive bash session
kshell -c "ls -la"        # Run single command
```

### `krun` - Run arbitrary commands in build environment
```bash
krun gcc --version        # Check compiler version
krun ls -la               # List files
krun scripts/checkpatch.pl --file drivers/example.c  # Run checkpatch
```

## What's Included

The Docker environment includes:
- **Build tools**: gcc, make, binutils
- **Kernel-specific tools**: bc, bison, flex, pahole (dwarves)
- **Libraries**: libelf-dev, libssl-dev, libncurses-dev
- **Utilities**: git, rsync, cpio, python3
- **Performance tools**: ccache (compiler cache), ninja-build
- **Cross-compilation support**: Ready for different architectures

## Cross-Compilation Support

The environment includes cross-compilation toolchains for multiple architectures:

### Available Architectures
- **x86_64**: Intel/AMD 64-bit processors
- **ARM64**: 64-bit ARM processors (AArch64)
- **ARM**: 32-bit ARM processors  
- **RISC-V**: 64-bit RISC-V processors

### Cross-Compilation Methods

#### Method 1: Direct ARCH specification
```bash
# Cross-compile for x86_64
kmake ARCH=x86_64 defconfig
kmake ARCH=x86_64 -j$(nproc)

# Cross-compile for ARM64
kmake ARCH=arm64 defconfig
kmake ARCH=arm64 -j$(nproc)

# Cross-compile for ARM (32-bit)
kmake ARCH=arm defconfig
kmake ARCH=arm -j$(nproc)

# Cross-compile for RISC-V
kmake ARCH=riscv defconfig
kmake ARCH=riscv -j$(nproc)
```

#### Method 2: Convenience Functions
```bash
# x86_64 cross-compilation
kmake-x86 defconfig
kmake-x86 -j$(nproc)

# ARM64 cross-compilation
kmake-arm64 defconfig
kmake-arm64 -j$(nproc)

# ARM 32-bit cross-compilation
kmake-arm defconfig
kmake-arm -j$(nproc)

# RISC-V cross-compilation
kmake-riscv defconfig
kmake-riscv -j$(nproc)
```

#### Method 3: Manual toolchain specification
```bash
# Custom cross-compiler
kmake ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- defconfig
```

### Check Available Toolchains
```bash
kshow-toolchains  # Display all available cross-compilation toolchains
```

### Cross-Compilation Examples

#### Build x86_64 kernel on ARM64 Mac
```bash
# Configure for x86_64
kmake-x86 defconfig

# Build kernel image
kmake-x86 bzImage -j$(nproc)

# Build modules
kmake-x86 modules -j$(nproc)
```

#### Build ARM kernel
```bash
# Configure for ARM
kmake-arm defconfig

# Build kernel
kmake-arm zImage -j$(nproc)
```

#### Build RISC-V kernel
```bash
# Configure for RISC-V
kmake-riscv defconfig

# Build kernel
kmake-riscv Image -j$(nproc)
```

## Architecture-Specific Build Targets

### x86_64 Targets
```bash
kmake-x86 bzImage            # Compressed kernel image
kmake-x86 modules            # Kernel modules
kmake-x86 isoimage           # ISO image
kmake-x86 modules_install    # Install modules
```

### ARM64 Targets
```bash
kmake-arm64 Image            # Uncompressed kernel image
kmake-arm64 Image.gz         # Compressed kernel image
kmake-arm64 modules          # Kernel modules
kmake-arm64 dtbs             # Device tree blobs
```

### ARM Targets
```bash
kmake-arm zImage             # Compressed kernel image
kmake-arm modules            # Kernel modules
kmake-arm dtbs               # Device tree blobs
```

### RISC-V Targets
```bash
kmake-riscv Image            # Kernel image
kmake-riscv modules          # Kernel modules
kmake-riscv dtbs             # Device tree blobs
```

## Common Build Targets

```bash
# Configuration
kmake menuconfig          # Interactive configuration
kmake defconfig          # Default configuration
kmake oldconfig          # Update existing config
kmake savedefconfig      # Save minimal config

# Building
kmake -j$(nproc)         # Full build (parallel)
kmake bzImage            # Build kernel image only
kmake modules            # Build kernel modules
kmake modules_install    # Install modules (requires root)

# Cleaning
kmake clean              # Remove build artifacts
kmake mrproper           # Clean everything
kmake distclean          # Clean + remove editor backup files
```

## Troubleshooting

### Permission Issues
If you encounter permission issues, rebuild the Docker image:
```bash
./build-kernel-env.sh
```

### Out of Disk Space
Clean build artifacts:
```bash
kmake clean
# or for thorough cleanup
kmake mrproper
```

### Docker Image Issues
Remove and rebuild the image:
```bash
docker rmi kernel-build-env
./build-kernel-env.sh
```

## Performance Demonstration

### Real-World Build Performance

Here's how fast this optimized build environment compiles the Linux kernel
on my MacBook Pro M1 Max with 8 performance cores, 2 efficiency cores and 64GB
physical memory:

![Build Performance](https://res.cloudinary.com/dqogtdy4z/image/upload/v1752486079/build_tresvp.png)

**Key Performance Highlights:**
- ⚡ **Full kernel build**: Completed in minutes, not hours
- 🚀 **10 parallel jobs**: Utilizing all CPU cores automatically
- 💾 **56GB RAM**: Aggressive memory allocation for maximum speed
- 📦 **CCache optimization**: Subsequent builds are extremely fast
- 🔄 **Cross-compilation**: Fast builds for multiple architectures

The screenshot above shows a real kernel compilation session using `kperf` performance monitoring, demonstrating the optimized build times achieved with this Docker-based environment.

## Performance Optimizations

This build environment is automatically optimized for maximum compilation speed:

### Automatic Optimizations
- **Auto-parallel builds**: Automatically uses all available CPU cores (detected: my system has 10 cores)
- **CCache**: Compiler cache for faster recompilation (4GB cache, compressed) - **pre-installed and configured**
- **Memory optimization**: Docker container uses up to 56GB RAM with 64GB total memory (aggressive configuration)
- **Cross-compiler caching**: All cross-compilation toolchains use ccache automatically

### Performance Features
- **Fast build commands**: `kfast`, `kfast-x86`, `kfast-arm64` for quick builds
- **Performance monitoring**: `kperf` command shows build time and cache statistics
- **Cache management**: `kccache-stats`, `kccache-clear`, `kccache-zero` commands

### Manual Performance Tips

1. **Parallel builds**: The system automatically uses `-j10` (all CPU cores)
2. **Incremental builds**: CCache makes subsequent builds extremely fast
3. **Docker resource allocation**: Pre-configured for optimal resource usage
4. **Clean selectively**: Use `kmake clean` instead of `kmake mrproper` when possible
5. **Monitor cache**: Use `kccache-stats` to see compilation cache hit rate

## File Structure

```
    Dockerfile.kernel-build    # Docker environment definition
    build-kernel-env.sh        # Build script for Docker image
    func_def.shell             # Command for kernel build
    README.md                  # README file

```

## Environment Variables

The Docker environment sets:
- `ARCH=x86_64` (default architecture)
- `CROSS_COMPILE=""` (no cross-compilation prefix by default)
- `DEBIAN_FRONTEND=noninteractive` (prevents interactive prompts)

## Integration with Other Tools

- **git**: Full git functionality available in the container
- **Text editors**: vim is installed, or use external editors on the host

## Security Notes

- The Docker container runs as a non-root user matching your host user ID
- No privileged access is granted to the container
- File permissions are preserved between host and container
