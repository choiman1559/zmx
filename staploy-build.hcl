build "zmx" {
  output_dir  = "zig-out"
  version     = "shell:git describe --tags --abbrev=0"
  executable = ["zmx"]
  envs = ["ZIG_PATH=/home/cuj1559/.local/share/zig/0.16.0"]
  lib_version = "shell:echo zig $($(echo $ZIG_PATH)/zig version)"

  x86_64 {
    pre_build = "$ZIG_PATH/zig build -Doptimize=ReleaseSmall -Dtarget=x86_64-linux-musl --prefix ./zig-out/amd64"
    path = "zig-out/amd64/bin"
  }

  arm {
    pre_build = "$ZIG_PATH/zig build -Doptimize=ReleaseSmall -Dtarget=arm-linux-musleabihf --prefix ./zig-out/arm"
    path = "zig-out/arm/bin"
  }

  aarch64 {
    pre_build = "$ZIG_PATH/zig build -Doptimize=ReleaseSmall -Dtarget=aarch64-linux-musl --prefix ./zig-out/aarch64"
    path = "zig-out/aarch64/bin"
  }

  mipsel {
    pre_build = "$ZIG_PATH/zig build -Doptimize=ReleaseSmall -Dtarget=mipsel-linux-musleabihf --prefix ./zig-out/mipsel"
    path = "zig-out/mipsel/bin"
  }
}