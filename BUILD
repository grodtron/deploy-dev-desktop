load("@rules_python//python:pip.bzl", "compile_pip_requirements")
load("@build_bazel_rules_nodejs//:index.bzl", "nodejs_binary")

# This rule adds a convenient way to update the requirements file.
#   bazel run //:requirements.update
compile_pip_requirements(
    name = "requirements",
    extra_args = ["--allow-unsafe"],
    requirements_in = "requirements.in",
    requirements_txt = "requirements_lock.txt",
)
