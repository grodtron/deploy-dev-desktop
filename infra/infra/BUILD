load("@rules_python//python:defs.bzl", "py_library")
load("@pypi//:requirements.bzl", "requirement")

py_library(
    name = "stack",
    srcs = ["infra_stack.py"],
    deps = [
        requirement("aws-cdk-lib")
    ],
    visibility = ["//infra:__subpackages__"]
)
