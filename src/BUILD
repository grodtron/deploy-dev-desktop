load("@rules_python//python:defs.bzl", "py_binary", "py_library")
load("@pypi//:requirements.bzl", "requirement")
load("@rules_python_pytest//python_pytest:defs.bzl", "py_pytest_test")

package(default_visibility = ["//visibility:public"])

py_library(
    name = "deploy",
    srcs = ["deploy.py"],
    deps = [
        requirement("boto3"),
        requirement("more_itertools"),
        requirement("fabric"),
        requirement("paramiko")
    ]
)

py_pytest_test(
    name = "test",
    srcs = ["deploy_test.py"],
    deps = [":deploy", requirement("pytest")]
)

py_binary(
    name = "launch-instance",
    main = "main.py",
    srcs = ["main.py"],
    deps = [":deploy"]
)
