load("@rules_python//python:defs.bzl", "py_binary", "py_library", "py_test")
load("@pypi//:requirements.bzl", "requirement")

package(default_visibility = ["//visibility:public"])

py_library(
    name = "deploy",
    srcs = ["deploy.py"],
    deps = [requirement("boto3")]
)

py_test(
    name = "test",
    main = "deploy_test.py",
    srcs = ["deploy_test.py"],
    deps = [":deploy"]
)
