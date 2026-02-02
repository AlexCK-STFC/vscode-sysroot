all: sysroot

# Build a docker image which contains the final sysroot, then copy the sysroot tarball into toolchain/.
# This avoids case-insensitivity problems on MacOS, as the kernel source is case-sensitive and crosstool-ng
# refuses to run on a case-insensitive filesystem.

sysroot:
	mkdir -p toolchain
	docker buildx create --name sysroot-builder --use --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=10000000 --driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=10000000 || true
	docker buildx build --builder sysroot-builder --progress=plain --load --platform=linux/amd64 -t vscode-sysroot:latest --target sysroot .
	docker run -it --rm -v $$PWD/toolchain:/out vscode-sysroot cp vscode-sysroot-x86_64-linux-gnu.tgz /out/
	ls -l toolchain

# You could also use `docker build --target crosstool` to build a more traditional image containing just
# crosstool-ng, and then run a container to build the sysroot into a mounted volume. In that case, your
# mounted volume must be case-sensitive.

clean:
	rm -rf toolchain

.PHONY: sysroot clean
