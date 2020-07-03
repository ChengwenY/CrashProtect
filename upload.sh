#!/bin/bash

VersionNumber=`grep -E 'spec.version.*=' CWCrashProtect.podspec`

git add .
git commit -m 'updateVersion'
git push
echo "New Version ${VersionNumber}"

git tag ${VersionNumber}
git push origin master --tags
pod trunk push ./CWCrashProtect.podspec --verbose --allow-warnings
