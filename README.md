to update pip dependencies

```
bazel run //:requirements.update
```

to update NPM packages:

```
bazel run -- @pnpm//:pnpm i --dir $PWD --lockfile-only
```

to invoke the `cdk` tool:

```
bazel run @npm//aws-cdk/bin:cdk
```
