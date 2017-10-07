#!/usr/bin/env sh

function checkError {
        if [ $1 -ne 0 ]; then
                echo "ERROR"
                exit $1
        fi
        echo "OK"
}

CURRENT_FULL=$(monit -V)
checkError $?

exit 0