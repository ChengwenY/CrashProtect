#!/bin/bash

VersionString=`grep -E 'spec.version.*=' CWCrashProtect.podspec`
VersionArr=(`echo $VersionString | tr '=' ' '`)
VersionNumberStr=${VersionArr[2]}
VersionNumber=${${VersionNumberStr}//'"'/''}
echo "New Version ${VersionNumber}"


#git add .
#git commit -m 'updateVersion'
#git push
#echo "New Version ${VersionNumber}"
#
#git tag ${VersionNumber}
#git push origin master --tags
#pod trunk push ./CWCrashProtect.podspec --verbose --allow-warnings
