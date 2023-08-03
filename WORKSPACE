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
