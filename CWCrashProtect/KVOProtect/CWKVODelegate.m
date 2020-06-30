//
//  CWKVODelegate.m
//  Pods
//
//  Created by Chengwen.Y on 2020/6/30.
//

#import "CWKVODelegate.h"

@interface CWKVOInfo : NSObject
@end

@implementation CWKVOInfo
{
    @package //
    __weak NSObject *observer;
    NSString *keyPath;
    NSKeyValueObservingOptions options;
    void *context;
}

- (instancetype)initWithObserver:(NSObject *)observer keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    self = [super init];
    if (self) {
        self->observer = observer;
        self->keyPath = keyPath;
        self->options = options;
        self->context = context;
    }
    return self;
}
@end


@interface CWKVODelegate ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableArray<CWKVOInfo *> *> *keyPathMap;

@end

@implementation CWKVODelegate

- (NSMutableDictionary *)keyPathMap {
    if (!_keyPathMap) {
        _keyPathMap = @{}.mutableCopy;
    }
    return _keyPathMap;
}

- (BOOL)addKvoInfoWithObserver:(NSObject *)observer
         forKeyPath:(NSString *)keyPath
            options:(NSKeyValueObservingOptions)options
            context:(void *)context {
    
    __block BOOL alreadExist = NO; //是否已经添加过监听
    NSMutableArray *array = [self kvoInfosOfKeyPath:keyPath];
    [array enumerateObjectsUsingBlock:^(CWKVOInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj->observer == observer) {
            alreadExist = YES;
            *stop = YES;
        }
    }];
    if (!alreadExist) {
        CWKVOInfo *kvoInfo = [[CWKVOInfo alloc] initWithObserver:observer keyPath:keyPath options:options context:context];
        [array addObject:kvoInfo];
        self.keyPathMap[keyPath] = array;
        return YES;
    } else {
        NSLog(@"重复添加观察者：%@ keyPath:%@", observer, keyPath);
        return NO;
    }
}

- (BOOL)removeKvoInfoWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    NSMutableArray *kvoInfos = [self kvoInfosOfKeyPath:keyPath];
    __block BOOL exist = NO;
    __block CWKVOInfo *info = nil;
    [kvoInfos enumerateObjectsUsingBlock:^(CWKVOInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj->observer == observer) {
            exist = YES;
            info = obj;
            *stop = YES;
        }
    }];
    if (exist) {
        [kvoInfos removeObject:info];
        self.keyPathMap[keyPath] = kvoInfos;
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)removeKvoInfoObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
    NSMutableArray *kvoInfos = [self kvoInfosOfKeyPath:keyPath];
    __block BOOL exist = NO;
    __block CWKVOInfo *info = nil;
    [kvoInfos enumerateObjectsUsingBlock:^(CWKVOInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj->observer == observer && obj->context == context) {
            exist = YES;
            info = obj;
            *stop = YES;
        }
    }];
    if (exist) {
        [kvoInfos removeObject:info];
        self.keyPathMap[keyPath] = kvoInfos;
        return YES;
    } else {
        return NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSMutableArray *infos = [self kvoInfosOfKeyPath:keyPath];
    [infos enumerateObjectsUsingBlock:^(CWKVOInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }];
}

- (NSArray *)getAllKeyPaths
{
    return self.keyPathMap.allKeys;
}
#pragma mark - private
- (NSMutableArray *)kvoInfosOfKeyPath:(NSString *)keyPath
{
    if ([self.keyPathMap.allKeys containsObject:keyPath]) {
        return self.keyPathMap[keyPath];
    } else {
        return [NSMutableArray array];
    }
}

@end
