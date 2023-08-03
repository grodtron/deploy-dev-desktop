to update pip dependencies

```
bazel run //:requirements.update
```


To run terraform, we don't use bazel (yet?)

```
terraform plan
terraform apply
```
