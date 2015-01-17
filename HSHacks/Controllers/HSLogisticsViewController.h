//
//  HSLogisticsViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 1/9/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSLogisticsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *scheduleContainer;
@property (strong, nonatomic) IBOutlet UIView *workshopsContainer;

@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;
@property (strong, nonatomic) IBOutlet UIView *progressView;

@end
