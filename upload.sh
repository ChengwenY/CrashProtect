#!/bin/bash

VersionNumber=`grep -E 'spec.version.*=' CWCrashProtect.podspec`

git add .
git commit -am updateVersion
git pull origin master --tags

echo "New Version ${VersionNumber}"

git commit -am ${VersionNumber}
git tag ${VersionNumber}
git push origin master --tags
pod trunk push ./CWCrashProtect.podspec --verbose --allow-warnings
