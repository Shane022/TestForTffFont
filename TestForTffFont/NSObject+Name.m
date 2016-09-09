//
//  NSObject+Name.m
//  TestForTffFont
//
//  Created by new on 16-5-4.
//  Copyright (c) 2016年 new. All rights reserved.
//

#import "NSObject+Name.h"
#import <objc/runtime.h>

@implementation NSObject (Name)

char nameKey;
char ageKey;

- (void)setName:(NSString *)name {
    // 将某个值跟某个对象关联起来，将某个值存储到某个对象中
    objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, &nameKey);
}

- (void)setAge:(NSNumber *)age {
    objc_setAssociatedObject(self, &ageKey, age, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSNumber *)age {
    return objc_getAssociatedObject(self, &ageKey);
}

+ (void)testForCategory {
    NSLog(@"test for category in target");
}

@end
