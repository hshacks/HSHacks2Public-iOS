//
//  HSUser.h
//  HSHacks
//
//  Created by Spencer Yen on 1/9/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSUser : NSObject

+ (id)sharedManager;

@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSString *userPhoto;

@end
