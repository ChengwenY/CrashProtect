//
//  CWContainerProtect.m
//  CWCrashProtect
//
//  Created by Chengwen.Y on 2020/7/1.
//

#import "CWContainerProtect.h"
#import "CWCrashProtectUtils.h"

@implementation NSArray (CWGuard)

+ (void)exchangeMethodInNSArray
{
    //objectAtIndex
    SEL origAtIndex = @selector(objectAtIndex:);
    cw_swizzleInstanceMethod(NSClassFromString(@"__NSArray0"), origAtIndex, [self class], @selector(cw_NSArray0ObjectAtIndex:));
    cw_swizzleInstanceMethod(NSClassFromString(@"__NSSingleObjectArrayI"), origAtIndex, [self class], @selector(cw_NSSingleObjectArrayIObjectAtIndex:));
    cw_swizzleInstanceMethod(NSClassFromString(@"__NSArrayI"), origAtIndex, [self class], @selector(cw_NSArrayIObjectAtIndex:));
//    
//    //objectAtIndexedSubscript
    SEL origSubScript = @selector(objectAtIndexedSubscript:);
    cw_swizzleInstanceMethod(NSClassFromString(@"__NSArray0"), origSubScript, [self class], @selector(cw_NSArray0ObjectAtIndexedSubscript:));
    cw_swizzleInstanceMethod(NSClassFromString(@"__NSSingleObjectArrayI"), origSubScript, [self class], @selector(cw_NSSingleObjectArrayIObjectAtIndexedSubscript:));
    cw_swizzleInstanceMethod(NSClassFromString(@"__NSArrayI"), origSubScript, [self class], @selector(cw_NSArrayIObjectAtIndexedSubscript:));
}

#pragma mark - objectAtIndex:
- (id)cw_NSArray0ObjectAtIndex:(NSUInteger)index {
    CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSArray0 objectAtIndex:]: index %@ beyond bounds for empty NSArray", @(index));
    return nil;
}

- (id)cw_NSSingleObjectArrayIObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self cw_NSSingleObjectArrayIObjectAtIndex:index];
    }
    CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSSingleObjectArrayI objectAtIndex:]: index %@ beyond bounds [0 .. %@]", @(index), @(self.count));
    return nil;
}

- (id)cw_NSArrayIObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self cw_NSArrayIObjectAtIndex:index];
    }
    CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** __boundsFail: index %@ beyond bounds [0 .. %@]", @(index), @(self.count));
    return nil;
}


#pragma mark - objectAtIndexedSubscript:

- (id)cw_NSArray0ObjectAtIndexedSubscript:(NSUInteger)index {
    CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSArray0 objectAtIndexedSubscript:]: index %@ beyond bounds [0 .. %@]", @(index), @(self.count));
    return nil;
}

- (id)cw_NSSingleObjectArrayIObjectAtIndexedSubscript:(NSUInteger)index {
    if (index < self.count) {
        return [self cw_NSSingleObjectArrayIObjectAtIndex:index];
    }
    CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSSingleObjectArray objectAtIndexedSubscript:]: index %@ beyond bounds [0 .. %@]", @(index), @(self.count));
    return nil;
}

- (id)cw_NSArrayIObjectAtIndexedSubscript:(NSUInteger)index {
    if (index < self.count) {
        return [self cw_NSArrayIObjectAtIndex:index];
    }
    CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSArrayI objectAtIndexedSubscript:]: index %@ beyond bounds [0 .. %@]", @(index), @(self.count));
    return nil;
}


@end

#pragma mark - NSMutableArray
@interface NSMutableArray (CWGuard)

@end

@implementation NSMutableArray (CWGuard)

+ (void)exchangeMethodInNSMutableArray
{
    Class cls = NSClassFromString(@"__NSArrayM");
    cw_swizzleInstanceMethod(cls, @selector(objectAtIndex:), [self class], @selector(cw_NSArrayMObjectAtIndex:));
    cw_swizzleInstanceMethod(cls, @selector(objectAtIndexedSubscript:), [self class], @selector(cw_NSArrayMObjectAtIndexedSubscript:));

    cw_swizzleInstanceMethod(cls, @selector(insertObject:atIndex:), [self class], @selector(cw_NSArrayMInsertObject:atIndex:));
    cw_swizzleInstanceMethod(cls, @selector(removeObjectAtIndex:), [self class], @selector(cw_removeObjectAtIndex:));
    cw_swizzleInstanceMethod(cls, @selector(replaceObjectAtIndex:withObject:), [self class], @selector(cw_replaceObjectAtIndex:withObject:));
    cw_swizzleInstanceMethod(cls, @selector(replaceObjectsAtIndexes:withObjects:), [self class], @selector(cw_replaceObjectsAtIndexes:withObjects:));
    cw_swizzleInstanceMethod(cls, @selector(replaceObjectsInRange:withObjectsFromArray:), [self class], @selector(cw_replaceObjectsInRange:withObjectsFromArray:));
}

/**
 - (void)addObject:(ObjectType)anObject; // 调用insertObject:atIndex:
 - (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;
 - (void)removeObjectAtIndex:(NSUInteger)index;
 - (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;
 */

- (id)cw_NSArrayMObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self cw_NSArrayMObjectAtIndex:index];
    }
    CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSSingleM objectAtIndex:]: index %@ beyond bounds [0 .. %@]", @(index), @(self.count));
    return nil;
}

- (id)cw_NSArrayMObjectAtIndexedSubscript:(NSUInteger)index {
    if (index < self.count) {
        return [self cw_NSArrayMObjectAtIndex:index];
    }
    CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSArrayM objectAtIndexedSubscript:]: index %@ beyond bounds [0 .. %@]", @(index), @(self.count));
    return nil;
}

- (void)cw_NSArrayMInsertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject == nil) {
        CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSArrayM insertObject:atIndex:]: attempt  insert nil", nil);
        return;
    }
    if (index > self.count) {
        CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSArrayM insertObject:atIndex:]: index %@ beyond bounds [0 .. %@]", @(index), @(self.count));
        return;
    }
    [self cw_NSArrayMInsertObject:anObject atIndex:index];
}

- (void)cw_NSArrayMRemoveObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSArrayM removeObjectsInRange:]: range {%@, 1} extends beyond bounds [0 .. %@]", @(index), @(self.count));
        return;
    }
    [self cw_NSArrayMRemoveObjectAtIndex:index];
}

- (void)cw_NSArrayMReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (anObject == nil) {
        CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSArrayM replaceObjectAtIndex:withObject:]: attempt  insert nil", nil);
        return;
    }
    if (index >= self.count) {
        CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSArrayM replaceObjectAtIndex:withObject:]: index %@ beyond bounds [0 .. %@]", @(index), @(self.count));
        return;
    }
    [self cw_NSArrayMReplaceObjectAtIndex:index withObject:anObject];
}

- (void)cw_NSArrayMReplaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray *)objects{
    if (indexes.lastIndex >= self.count||indexes.firstIndex >= self.count) {
        CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSArrayM replaceObjectsAtIndexes:withObjects:]: lastIndex %@ or firstIndex %@ beyond bounds [0 .. %@]", @(indexes.lastIndex), @(indexes.firstIndex), @(self.count));
    }else{
        [self cw_NSArrayMReplaceObjectsAtIndexes:indexes withObjects:objects];
    }
}

-(void)cw_NSArrayMReplaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray{
    if (range.location+range.length > self.count) {
        CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSArrayM removeObjectsInRange:]: range {%@, %@} extends beyond bounds [0 .. %@]", @(range.length), @(range.location), @(self.count));
    }else{
        [self cw_NSArrayMReplaceObjectsInRange:range withObjectsFromArray:otherArray];
    }
}

@end

#pragma mark - NSDictionary
@interface NSDictionary (CWGuard)

@end

@implementation NSDictionary (CWGuard)

+ (void)exchangeMethodInNSDictionary
{
    cw_swizzleInstanceMethod(NSClassFromString(@"__NSPlaceholderDictionary"), @selector(initWithObjects:forKeys:count:), [self class], @selector(cw_initWithObjects:forKeys:count:));
}

+ (instancetype)cw_dictionaryWithObjects:(NSArray *)objects forKeys:(NSArray <id<NSCopying>> *)keys
{
    if (objects.count != keys.count) {
        CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"NSDictionary Objects count NOT Equal keys count", nil);
        return nil;
    }
    //判断objects是否有nil
    id objectsNew[objects.count];
    id <NSCopying> keysNew[keys.count];
    NSUInteger index = 0;
    for (int i = 0; i < keys.count; i++) {
        if (objects[i] && keys[i]) {
            objectsNew[index] = objects[i];
            keysNew[index] = keys[i];
            index ++;
        } else {
            //index is nil;
            CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[%d]", i);
        }
    }
    return [self cw_dictionaryWithObjects:[NSArray arrayWithObjects:objectsNew count:index] forKeys:[NSArray arrayWithObjects:keysNew count:index]];
}

- (instancetype)cw_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    NSUInteger index = 0;
    id _Nonnull objectsNew[cnt];
    id <NSCopying> _Nonnull keysNew[cnt];
    //'*** -[NSDictionary initWithObjects:forKeys:]: count of objects (1) differs from count of keys (0)'
    for (int i = 0; i<cnt; i++) {
        if (objects[i] && keys[i]) {//可能存在nil的情况
            objectsNew[index] = objects[i];
            keysNew[index] = keys[i];
            index ++;
        }else{
            CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[%@]", @(index));
        }
    }
    return [self cw_initWithObjects:objectsNew forKeys:keysNew count:index];
}

@end

#pragma mark - NSMutableDictionary
@interface NSMutableDictionary (CWGuard)

@end

@implementation NSMutableDictionary (CWGuard)

+ (void)exchangeMethodInNSMutableDictionary
{
    cw_swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKey:), [self class], @selector(cw_dictionaryMSetObject:forKey:));
    cw_swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(removeObjectForKey:), [self class], @selector(cw_dictionaryMRemoveObjectForKey:));
}

- (void)cw_dictionaryMSetObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject == nil || aKey == nil) {
        CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** setObjectForKey: object or key cannot be nil", nil);
    } else {
        [self cw_dictionaryMSetObject:anObject forKey:aKey];
    }
}

- (void)cw_dictionaryMRemoveObjectForKey:(id)key
{
    if (key == nil) {
        CW_CrashErrorHandler(ECWCrashTypeContainers, @{}, @"*** -[__NSDictionaryM removeObjectForKey:]: key cannot be nil", nil);
    } else {
        [self cw_dictionaryMRemoveObjectForKey:key];
    }
}

@end

@implementation CWContainerProtect

+ (void)beginProtectContainers
{
    [NSArray exchangeMethodInNSArray];
    [NSMutableArray exchangeMethodInNSMutableArray];
    [NSDictionary exchangeMethodInNSDictionary];
    [NSMutableDictionary exchangeMethodInNSMutableDictionary];
}

@end
