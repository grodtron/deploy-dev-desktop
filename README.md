to update pip dependencies

```
bazel run //:requirements.update
```

to update NPM packages (WIP):

```
bazel run @nodejs_host//:npm -- update
```

to invoke the `cdk` tool:

```
bazel run @npm//aws-cdk/bin:cdk
```
