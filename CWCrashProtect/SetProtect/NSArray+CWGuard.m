//
//  NSArray+CWGuard.m
//  Pods-CrashProtect
//
//  Created by Chengwen.Y on 2020/6/24.
//

#import "NSArray+CWGuard.h"
#import "NSObject+CWMethodHook.h"

@implementation NSArray (CWGuard)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //objectAtIndex
        SEL origAtIndex = @selector(objectAtIndex:);
        [[self class] swizzleInstanceMethod:NSClassFromString(@"__NSArray0") originSEL:origAtIndex newSEL:@selector(cw_zeroObjectAtIndex:)];
        [[self class] swizzleInstanceMethod:NSClassFromString(@"__NSSingleObjectArrayI") originSEL:origAtIndex newSEL:@selector(cw_singleObjectAtIndex:)];
        [[self class] swizzleInstanceMethod:NSClassFromString(@"__NSArrayI") originSEL:origAtIndex newSEL:@selector(cw_objectAtIndex:)];
        [[self class] swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSEL:origAtIndex newSEL:@selector(cw_mObjectAtIndex:)];
        
        //objectAtIndexedSubscript
        SEL origSubScript = @selector(objectAtIndexedSubscript:);
        [[self class] swizzleInstanceMethod:NSClassFromString(@"__NSArray0") originSEL:origSubScript newSEL:@selector(cw_zeroObjectAtIndexedSubscript:)];
        [[self class] swizzleInstanceMethod:NSClassFromString(@"__NSSingleObjectArrayI") originSEL:origSubScript newSEL:@selector(cw_singleObjectAtIndexedSubscript:)];
        [[self class] swizzleInstanceMethod:NSClassFromString(@"__NSArrayI") originSEL:origSubScript newSEL:@selector(cw_objectAtIndexedSubscript:)];
        [[self class] swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSEL:origSubScript newSEL:@selector(cw_mObjectAtIndexedSubscript:)];
    });
}

#pragma mark - objectAtIndex:
- (id)cw_zeroObjectAtIndex:(NSUInteger)index {
    return nil;
}

- (id)cw_singleObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self cw_singleObjectAtIndex:index];
    }
    return nil;
}

- (id)cw_objectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self cw_objectAtIndex:index];
    }
    return nil;
}

- (id)cw_mObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        return [self cw_mObjectAtIndex:index];
    }
    return nil;
}

#pragma mark - objectAtIndexedSubscript:

- (id)cw_zeroObjectAtIndexedSubscript:(NSUInteger)index {
    return nil;
}

- (id)cw_singleObjectAtIndexedSubscript:(NSUInteger)index {
    if (index < self.count) {
        return [self cw_singleObjectAtIndex:index];
    }
    return nil;
}

- (id)cw_objectAtIndexedSubscript:(NSUInteger)index {
    if (index < self.count) {
        return [self cw_objectAtIndex:index];
    }
    return nil;
}

- (id)cw_mObjectAtIndexedSubscript:(NSUInteger)index {
    if (index < self.count) {
        return [self cw_mObjectAtIndex:index];
    }
    return nil;
}

@end
