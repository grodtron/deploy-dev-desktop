load("@rules_python//python:defs.bzl", "py_binary")
load("@pypi//:requirements.bzl", "requirement")
load("//rules:nodejs_binary_with_runfiles.bzl", "nodejs_binary_with_runfiles")


nodejs_binary_with_runfiles(
    name = "cdk_binary",
    bin = "@npm//aws-cdk/bin:cdk"
)


sh_binary(
    name = "cdk",
    srcs = ["run_cdk.sh"],
    data = [
        "//infra:app",
        "//infra:cdk_binary",
        # "@npm//aws-cdk/bin:cdk",
        "@node16_host//:node"
    ],
    env = {
        "NODE": "$(rootpath @node16_host//:node)",
        "CDK":  "$(rootpath //infra:cdk_binary)",
        #"CDK": "$(rootpath @npm//aws-cdk/bin:cdk)",
        "APP":  "$(rootpath //infra:app)"
    }
)


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


genrule(
    name = "foo",
    tools = [
        "//infra:app",
        "@npm//aws-cdk/bin:cdk",
        "@node16_host//:node"
    ],
    outs = ["list.txt"],
    cmd = "BAZEL_NODE_BINARY=$(location @node16_host//:node) $(location @npm//aws-cdk/bin:cdk) --app /bin/false list | tee $(location :list.txt)"
    # cmd = "BAZEL_NODE_BINARY=$(location @node16_host//:node) $(location @npm//aws-cdk/bin:cdk) --app $(location //infra:app) list | tee $(location :list.txt)"
)
