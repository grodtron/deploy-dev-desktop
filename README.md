to update pip dependencies

```
bazel run //:requirements.update
```

To build the lambda archive package:

```
bazel build //src:deployment_archive

```


To run terraform, we don't use bazel (yet?)

```
terraform init
terraform plan --out plan
terraform apply plan
```
