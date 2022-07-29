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

nodejs_binary(
    name = "cdk",
    args = [
        # "--app $(location //lib:app)",
    ],
    data = [
        # "tsconfig.json",
        # "//lib",
        # "//lib:app",
        # "@com_github_kindlyops_pipeline_monitor//:lambda_deploy",
        "@npm//:node_modules",
    ],
    entry_point = "@npm//:node_modules/aws-cdk/bin/cdk",
    # https://github.com/bazelbuild/rules_nodejs/pull/2344
    templated_args = ["--bazel_patch_module_resolver"],
    visibility = ["//visibility:public"],
)

