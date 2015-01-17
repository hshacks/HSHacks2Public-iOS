//
//  HSHackathonManager.h
//  HSHacks
//
//  Created by Spencer Yen on 1/12/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HSHackathonManager : NSObject

+ (HSHackathonManager *)sharedInstance;

@property (nonatomic, strong) NSString *largeLogoFileName;
@property (nonatomic, strong) NSString *hackathonName;
@property (nonatomic, strong) NSString *firebaseChatURL;
@property (nonatomic, strong) NSString *parseAppID;
@property (nonatomic, strong) NSString *parseClientKey;
@property (nonatomic, strong) UIFont *titleFont;

- (UIColor *)primaryColor;

- (UIColor *)secondaryColor;

-(UIColor *)countdownColor;

- (UIColor *)hshacksRed;

- (UIColor *)hshacksYellow;

@end
