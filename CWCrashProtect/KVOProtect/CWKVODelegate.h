//
//  CWKVODelegate.h
//  Pods
//
//  Created by Chengwen.Y on 2020/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CWKVODelegate : NSObject

- (BOOL)addKvoInfoWithObserver:(NSObject *)observer
                    forKeyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                       context:(void *)context;

- (BOOL)removeKvoInfoWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

- (BOOL)removeKvoInfoObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context;

- (NSArray *)getAllKeyPaths;
@end

NS_ASSUME_NONNULL_END
