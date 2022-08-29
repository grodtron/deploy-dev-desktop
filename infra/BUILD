load("@rules_python//python:defs.bzl", "py_binary")
load("@pypi//:requirements.bzl", "requirement")

py_binary(
    name = "app",
    main = "app.py",
    srcs = ["app.py"],
    deps = ["//infra/infra:stack"],
    data = ["@node16_host//:node"],
    env = {
        "BAZEL_NODE_BINARY": "$(location @node16_host//:node)"
    }
)
