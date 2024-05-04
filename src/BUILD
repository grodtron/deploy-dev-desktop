load("@rules_python//python:defs.bzl", "py_binary", "py_library")
load("@pypi//:requirements.bzl", "requirement")
load("@rules_python_pytest//python_pytest:defs.bzl", "py_pytest_test")
load("//:build_rules/lambda_packaging/lambda.bzl", "contains", "endswith", "py_lambda_zip", "startswith")

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
    deps = [":deploy", requirement("pytest"), requirement("mock")]
)

py_binary(
    name = "launch-instance",
    main = "main.py",
    srcs = ["main.py"],
    deps = [":deploy"]
)

py_lambda_zip(
    name = "deployment_archive",
    ignore = [
        contains("/__pycache__/"),
        endswith(".pyc"),
        endswith(".pyo"),

        # Ignore boto since it's provided by Lambda.
        startswith("boto3/"),
        startswith("botocore/"),

        # With the move to hermetic toolchains, the zip gets a lib/ directory containing the
        # python runtime. We don't need that.
        startswith("lib/"),
    ],
    target = ":launch-instance"
)
