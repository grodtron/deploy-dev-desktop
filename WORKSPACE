load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

### Python ###

http_archive(
    name = "rules_python",
    sha256 = "a3a6e99f497be089f81ec082882e40246bfd435f52f4e82f37e89449b04573f6",
    strip_prefix = "rules_python-0.10.2",
    url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.10.2.tar.gz",
)

load("@rules_python//python:repositories.bzl", "python_register_toolchains")

python_register_toolchains(
    name = "python3_10",
    # Available versions are listed in @rules_python//python:versions.bzl.
    # We recommend using the same version your team is already standardized on.
    python_version = "3.10",
)

load("@python3_10//:defs.bzl", "interpreter")

load("@rules_python//python:pip.bzl", "pip_parse")

pip_parse(
   name = "pypi",
   python_interpreter_target = interpreter,
   requirements_lock = "//:requirements_lock.txt",
)

load("@pypi//:requirements.bzl", "install_deps")

# Initialize repositories for all packages in requirements_lock.txt.
install_deps()


load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
http_archive(
    name = "rules_python_pytest",
    sha256 = "62c3b72e997743d1b3934348cadad7a0906efaa5139b24c39efa189fd3e2142d",
    strip_prefix = "rules_python_pytest-1.0.1",
    url = "https://github.com/caseyduquettesc/rules_python_pytest/archive/v1.0.1.tar.gz",
)

# Fetches the rules_python_pytest dependencies.
# If you want to have a different version of some dependency,
# you should fetch it *before* calling this.
# Alternatively, you can skip calling this function, so long as you've
# already fetched all the dependencies.
load("@rules_python_pytest//python_pytest:repositories.bzl", "rules_python_pytest_dependencies")
rules_python_pytest_dependencies()

### Node JS (for CDK) ###

http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "c78216f5be5d451a42275b0b7dc809fb9347e2b04a68f68bad620a2b01f5c774",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/5.5.2/rules_nodejs-5.5.2.tar.gz"],
)

load("@build_bazel_rules_nodejs//:repositories.bzl", "build_bazel_rules_nodejs_dependencies")

build_bazel_rules_nodejs_dependencies()

load("@rules_nodejs//nodejs:repositories.bzl", "nodejs_register_toolchains")
# The order matters because Bazel will provide the first registered toolchain when a rule asks Bazel to select it
# This applies to the resolved_toolchain
nodejs_register_toolchains(
    name = "node16",
    node_version = "16.5.0",
)

load("@build_bazel_rules_nodejs//:index.bzl", "npm_install")

npm_install(
    name = "npm",
    node_repository = "node16",
    package_json = "//:package.json",
    package_lock_json = "//:package-lock.json",
    # We need to patch the cdk binary, so that `cdk init` works correctly. As it
    # is, when run under `bazel run`, before running a node_modules/ folder is
    # created, but `cdk init` needs to run in a completely empty directory. This
    # patch considers a directory with only node_modules/ to be empty.
    post_install_patches = [
        "//patches:aws-cdk.patch"
    ],
)

