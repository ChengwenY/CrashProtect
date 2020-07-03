#!/bin/bash

VersionString=`grep -E 'spec.version.*=' CWCrashProtect.podspec`
VersionNumber=`tr -cd 0-9 <<<"$VersionString"`

git add .
git commit -m 'updateVersion'
git push
echo "New Version ${VersionNumber}"

git tag ${VersionNumber}
git push origin master --tags
pod trunk push ./CWCrashProtect.podspec --verbose --allow-warnings
