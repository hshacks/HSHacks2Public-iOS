//
//  HSAnnoucementsViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 1/9/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse-iOS/Parse.h>

@interface HSAnnoucementsViewController : PFQueryTableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
