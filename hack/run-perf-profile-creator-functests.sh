#!/bin/bash

GINKGO_SUITS=${GINKGO_SUITS:-"test/e2e/performanceprofile/functests-performance-profile-creator"}

which ginkgo
if [ $? -ne 0 ]; then
    echo "Downloading ginkgo tool"
	# drop -mod=vendor flags, otherwise the installation will fail
	# because of the package can not be installed under the vendor directory
    GOFLAGS='' go install github.com/onsi/ginkgo/ginkgo@v1.16.5
fi

NO_COLOR=""
if ! which tput &> /dev/null 2>&1 || [[ $(tput -T$TERM colors) -lt 8 ]]; then
  echo "Terminal does not seem to support colored output, disabling it"
  NO_COLOR="-noColor"
fi


echo "Running Functional Tests: ${GINKGO_SUITS}"
# -v: print out the text and location for each spec before running it and flush output to stdout in realtime
# -r: run suites recursively
# --failFast: ginkgo will stop the suite right after the first spec failure
# --flakeAttempts: rerun the test if it fails
# -requireSuite: fail if tests are not executed because of missing suite
GOFLAGS=-mod=vendor ginkgo $NO_COLOR --v -r --failFast --flakeAttempts=2 -requireSuite ${GINKGO_SUITS} -- -junitDir /tmp/artifacts
