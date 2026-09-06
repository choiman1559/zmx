alias {
  worker "zmx-deploy" {
    workers = ["group:all"]

    where {
      arch = ["x86_64", "arm", "aarch64", "mipsel"]
    }
  }

  app "zmx-build" {
    name    = "zmx"
    version = "shell:git describe --tags --abbrev=0"
  }
}

build "alias:zmx-build" {
  output_dir = "zig-out"
  executable = ["zmx"]

  envs        = ["ZIG_PATH=/home/$USER/.local/share/zig/0.16.0"]
  lib_version = "shell:echo zig $($(echo $ZIG_PATH)/zig version)"
  pre_build   = "git pull --no-edit"

  x86_64 {
    pre_build = "$ZIG_PATH/zig build -Doptimize=ReleaseSmall -Dtarget=x86_64-linux-musl --prefix ./zig-out/amd64"
    path      = "zig-out/amd64/bin"
  }

  arm {
    pre_build = "$ZIG_PATH/zig build -Doptimize=ReleaseSmall -Dtarget=arm-linux-musleabihf --prefix ./zig-out/arm"
    path      = "zig-out/arm/bin"
  }

  aarch64 {
    pre_build = "$ZIG_PATH/zig build -Doptimize=ReleaseSmall -Dtarget=aarch64-linux-musl --prefix ./zig-out/aarch64"
    path      = "zig-out/aarch64/bin"
  }

  mipsel {
    pre_build = "$ZIG_PATH/zig build -Doptimize=ReleaseSmall -Dtarget=mipsel-linux-musleabihf --prefix ./zig-out/mipsel"
    path      = "zig-out/mipsel/bin"
  }
}

configure {
  address      = "shell:echo $STAPLOY_HOST_ADDR"
  port         = "shell:echo $STAPLOY_HOST_PORT"
  enforce_uuid = false
}

manage "alias:zmx-build" {
  upload {}
}

target "upload_zmx" {
  workers = ["alias:zmx-deploy"]

  # First unlink current activated version
  unset "alias:zmx-build" {
    pre_deploy = "zmx k"
  }

  # Then push & set desire version
  deploy "alias:zmx-build" {
    post_deploy = "zmx v"
  }
}