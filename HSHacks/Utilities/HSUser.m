//
//  HSUser.m
//  HSHacks
//
//  Created by Spencer Yen on 1/9/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import "HSUser.h"

@implementation HSUser

@synthesize userName;
@synthesize userPhoto;

+ (id)sharedManager {
    static HSUser *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[self alloc] init];
    });
    return user;
}

@end
