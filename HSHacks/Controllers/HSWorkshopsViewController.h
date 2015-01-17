//
//  HSWorkshopsViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 1/10/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse-iOS/Parse.h>

@interface HSWorkshopsViewController : PFQueryTableViewController

@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *sectionToDayMap;
@property (nonatomic, retain) NSMutableArray *bodyArray;
@property (nonatomic, retain) NSMutableDictionary *days;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
