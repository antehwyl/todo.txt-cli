#!/bin/bash
#

test_description='help functionality

This test covers the help output.
'
. ./test-lib.sh

unset TODO_ACTIONS_DIR

# Note: To avoid having to adapt the test whenever the help documentation
# slightly changes, only check for the section headers.
test_todo_session 'help output' <<EOF
>>> todo.sh help | sed '/^  \w/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Options:
  Built-in Actions:
EOF

test_todo_session 'verbose help output' <<EOF
>>> todo.sh -v help | sed '/^  \w/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Options:
  Built-in Actions:
EOF

test_todo_session 'very verbose help output' <<EOF
>>> todo.sh -vv help | sed '/^  \w/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Options:
  Environment variables:
  Built-in Actions:
EOF

mkdir .todo.actions.d
make_action()
{
	cat > ".todo.actions.d/$1" <<- EOF
	#!/bin/bash
	echo "custom action $1"
EOF
chmod +x ".todo.actions.d/$1"
}

make_action "foo"
test_todo_session 'help output with custom action' <<EOF
>>> todo.sh -v help | sed '/^  \w/!d'
  Usage: todo.sh [-fhpantvV] [-d todo_config] action [task_number] [task_description]
  Options:
  Built-in Actions:
  Add-on Actions:
EOF

test_done
