//
//  HSScheduleViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 1/10/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse-iOS/Parse.h>

@interface HSScheduleViewController : PFQueryTableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
