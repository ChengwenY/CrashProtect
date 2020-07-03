## CrashProtect

处理常见的线上崩溃，通过hook相关方法捕获错误。

## Usage

```
pod CWCrashProtect
```

```
[CWCrashProtect openCrashProtect:ECWCrashProtectAll];
	[CWCrashProtect setErrorHandlerBlock:^(CWCrashCatchError * error) {
//        NSLog(@"%@", error);
//处理错误，如保存成文件上传服务器
		NSAssert(NO, error.errorDesc);
	}];
```