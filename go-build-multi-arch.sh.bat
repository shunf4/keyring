@rem @echo off
@goto :runbat_start

# mkdir -p bin


if [ "${0#/dev/}" == "$0" ] ; then
	CURR_SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
	CURR_SCRIPT_PATH="$CURR_SCRIPT_DIR"/"$(basename "$0")"
elif [ -n "$CURR_SCRIPT_PATH" ]; then
	CURR_SCRIPT_DIR="$(dirname "$CURR_SCRIPT_PATH")"
else
	echo "warn: unable to decide CURR_SCRIPT_DIR and CURR_SCRIPT_PATH." >&2 
fi

cd "$(dirname "$CURR_SCRIPT_PATH")"

for os in windows linux darwin ; do
	suffix=""
	if [ "$os" = "darwin" ]; then suffix="_macos"; fi
	if [ "$os" = "linux" ]; then suffix=""; fi
	if [ "$os" = "windows" ]; then suffix=".exe"; fi
	GOOS=$os go build -v -o ./keyring"$suffix" ./cmd/keyring
    if [ "$os" = "windows" ]; then
	    GOOS=$os go build -v -o ./keyring-gui"$suffix" -ldflags "-H windowsgui" ./cmd/keyring
    fi
done

GOOS=linux GOARCH=arm64 go build -v -o ./keyring_arm64 ./cmd/keyring



exit 0
:runbat_start
@rem @title Busybox Wrapper Program
@rem @cls
@busybox ash -c "EXIT_CODE=0; APP_NAME=KeyringGoWorkerBuild; cd \"$(dirname '%~dpnx0')\"; CURR_SCRIPT_PATH='%~dpnx0' ash <(cat '%~dpnx0' | tail -n +3) || { EXIT_CODE=$? ; } ; if [ $EXIT_CODE != 0 ]; then echo \"Error occurred, exit code ${EXIT_CODE}\" >&2 ; exit 1 ; fi ; exit 0"


