#!/usr/bin/env bash

echo $@


file $(readlink -f $CDK)
file $(readlink -f $APP)
file $(readlink -f $NODE)

echo "(cd $PWD && \\"
echo "  env BAZEL_NODE_BINARY=$NODE \\"
echo "  $CDK --app $APP $@)"

BAZEL_NODE_BINARY=$NODE $CDK -a $APP $@ --debug
echo "BAZEL_NODE_BINARY=$NODE $CDK -a $APP $@ --debug"

exit $?
