"""
nodejs_binary_with_runfiles is a version of 
nodejs_binary that works when included as data in another rule.
"""

def _nodejs_binary_with_runfiles_impl(ctx):
    """
    Bubble up runfiles properly.
    Workaround https://github.com/bazelbuild/rules_nodejs/issues/3505.
    When running a nodejs_binary as data from another rule, encountered the following error:
    ERROR: cannot find build_bazel_rules_nodejs/third_party/github.com/bazelbuild/bazel/tools/bash/runfiles/runfiles.bash
    """
    bin = ctx.attr.bin.files_to_run.executable

    ctx.actions.write(
        content = """#!/bin/bash
if [ ! -z "$TEST_SRCDIR" ]; then
  # If running a test, make sure to run from the root of the test
  # workspace so that the relative paths below still work.
  cd "$TEST_SRCDIR/$TEST_WORKSPACE"
fi
# Point the runfiles directory to *this rule's* runfiles directory,
# which should now have all the runfiles that the nodejs_binary needs.
export RUNFILES_DIR=../
./%s
        """ % (bin.short_path),
        is_executable = True,
        output = ctx.outputs.executable,
    )

    # Add all the runfiles from the nodejs_binary to this rule's runfiles.
    inputs = depset(transitive = [ctx.attr.bin[DefaultInfo].default_runfiles.files])

    runfiles = ctx.runfiles(files = [bin] + inputs.to_list())
    return DefaultInfo(executable = ctx.outputs.executable, runfiles = runfiles)

nodejs_binary_with_runfiles = rule(
    implementation = _nodejs_binary_with_runfiles_impl,
    attrs = {
        "bin": attr.label(
            executable = True,
            cfg = "exec",
            allow_files = True,
        ),
    },
    executable = True,
)
