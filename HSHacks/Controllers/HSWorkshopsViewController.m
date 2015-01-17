//
//  HSWorkshopsViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 1/10/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import "HSWorkshopsViewController.h"
#import "HSHackathonManager.h"

#define PARSE_SCHEDULE_CLASS_NAME @"Workshops"

@implementation HSWorkshopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.userInteractionEnabled = YES;
    self.tableView.bounces = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //Very hacky way to fix weird layout bug that set content inset to something like 64
    UIEdgeInsets inset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.contentInset = inset;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.userInteractionEnabled = YES;
    [self loadObjects];
}


- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:PARSE_SCHEDULE_CLASS_NAME];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query orderByAscending:@"time"];
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *bodyString = [[self.objects objectAtIndex:indexPath.row]objectForKey:@"description"];
    CGSize constraint = CGSizeMake(self.view.frame.size.width-110, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"OpenSans" size:14.0]  forKey:NSFontAttributeName];
    CGRect textsize = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    float textHeight = textsize.size.height;
    return textHeight + 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *simpleTableIdentifier = @"WorkshopCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    UIView *headerView = (UIView *)[cell viewWithTag:105];
    headerView.backgroundColor = [[HSHackathonManager sharedInstance] secondaryColor];
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:100];
    nameLabel.text = [object objectForKey:@"name"];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *detailsLabel = (UILabel*) [cell viewWithTag:104];
    NSString *detailsString = [object objectForKey:@"description"];
    
    CGSize constraint = CGSizeMake(self.view.frame.size.width-110, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"OpenSans" size:14.0] forKey:NSFontAttributeName];
    CGRect newFrame = [detailsString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    detailsLabel.frame = CGRectMake(8,38,self.view.frame.size.width-110, newFrame.size.height);
    detailsLabel.text = detailsString;
    [detailsLabel sizeToFit];
    
    UILabel *timeLabel = (UILabel*) [cell viewWithTag:101];
    timeLabel.center = CGPointMake(timeLabel.center.x, detailsLabel.center.y);
    
    NSDate *time = [object objectForKey:@"time"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"h:mm a"];
    timeLabel.text = [dateFormatter stringFromDate:time];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end