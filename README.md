to update pip dependencies

```
bazel run //:requirements.update
```

to update NPM packages (WIP):

```
bazel run @nodejs_host//:npm -- update
```
