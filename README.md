to update pip dependencies

```
bazel run //:requirements.update
```

to update NPM packages:

```
bazel run -- @pnpm//:pnpm i --dir $PWD --lockfile-only
```

to invoke the `cdk` tool:

Previously it was this:
```
bazel run @npm//aws-cdk/bin:cdk
```

Now I'm not sure, with pnpm, I think something like this:

```
bazel run //:node_modules/aws-cdk/bin/cdk
```
However I'm not sure. This comes from these docs [here](https://docs-legacy.aspect.build/aspect-build/rules_js/v1.13.0/docs/npm_import-docgen.html#npm_import)
