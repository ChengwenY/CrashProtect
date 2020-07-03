#!/bin/bash

VersionNumber=`grep -E 'spec.version.*=' CWCrashProtect.podspec`

git add .
git commit -m 'updateVersion'
git pull origin master --tags

echo "New Version ${VersionNumber}"

git commit -m "${VersionNumber}"
git tag ${VersionNumber}
git push origin master --tags
pod trunk push ./CWCrashProtect.podspec --verbose --allow-warnings
