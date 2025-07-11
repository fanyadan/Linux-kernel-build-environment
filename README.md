# Linux Kernel Build Environment for MacOS

This setup provides a Docker-based Linux environment for compiling the Linux kernel on macOS, with full **cross-compilation support** for multiple architectures. Build x86_64, ARM64, ARM, and RISC-V kernels from your ARM64 Mac!

## Quick Start

1. **Build the Docker environment:**
   ```bash
   ./build-kernel-env.sh
   ```
2. **Add commnd definition in shell rc file (.bashrc in example)**
   ```bash
   cat func_def.shell >> ~/.bashrc
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

### `kmake` - Run make commands in Docker
```bash
kmake menuconfig           # Configure kernel
kmake defconfig           # Use default configuration
kmake -j8                 # Build with 8 parallel jobs
kmake modules             # Build kernel modules
kmake clean               # Clean build artifacts
kmake mrproper            # Clean everything including config
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
- **Kernel-specific tools**: bc, bison, flex
- **Libraries**: libelf-dev, libssl-dev, libncurses-dev
- **Utilities**: git, rsync, cpio, python3
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

## Performance Tips

1. **Use parallel builds**: `kmake -j$(nproc)` or `kmake -j8`
2. **Incremental builds**: After initial build, subsequent builds are much faster
3. **Docker resource allocation**: Ensure Docker has sufficient CPU/memory allocated
4. **Clean selectively**: Use `kmake clean` instead of `kmake mrproper` when possible

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
