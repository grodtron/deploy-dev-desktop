For some reason, CDK works when run as part of a genrule, but not when run as a sh_binary

Really not sure why not. It just prints usage and exits with a failure. No other info.

As `sh_binary`:

```
bazel run //infra:cdk
```

As genrule:

```
# remove the output file to force recreating it
rm -f bazel-bin/infra/list.txt
# -s to show command outputs, for debugging
bazel build -s //infra:foo
```
