//
//  Person.h
//  TestForTffFont
//
//  Created by new on 16-4-29.
//  Copyright (c) 2016年 new. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *hobby;

+ (void)play;
+ (void)study;

@end
