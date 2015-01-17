//
//  HSAnnoucementsViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 1/9/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import "HSAnnoucementsViewController.h"
#import "HSLoginViewController.h"
#import "HSUser.h"
#import "HSHackathonManager.h"

#define LOGGED_IN_KEY @"loggedIn"
#define PARSE_ANNOUNCEMENTS_CLASS_NAME @"Announcements"

@interface HSAnnoucementsViewController () 

@end

@implementation HSAnnoucementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.navigationController.navigationBar.topItem.title = @"Announcements";
    
    if(![self isLoggedIn]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HSLoginViewController *loginVC = (HSLoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"HSLoginViewController"];
        [self presentViewController:loginVC animated:NO completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadObjects];
}

- (void)viewDidAppear:(BOOL)animated{

}

- (BOOL)isLoggedIn {
    //Not the prettiest thing, but load user data from defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    HSUser *user = [HSUser sharedManager];
    user.userName = [defaults objectForKey:@"name"];
    user.userPhoto = [defaults objectForKey:@"photo"];
    
    if([[defaults objectForKey:LOGGED_IN_KEY] isEqualToString:@"YES"]){
        return YES;
    } else {
        return NO;
    }
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"createdAt";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:PARSE_ANNOUNCEMENTS_CLASS_NAME];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query orderByDescending:@"createdAt"];
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *bodyString = [[self.objects objectAtIndex:indexPath.row]objectForKey:@"body"];
    
    //set the desired size of your textbox
    CGSize constraint = CGSizeMake(self.view.frame.size.width-16, MAXFLOAT);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"OpenSans" size:14.0] forKey:NSFontAttributeName];
    CGRect textsize = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    float textHeight = textsize.size.height + 65;
    
    return textHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *cellID = @"AnnouncementCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *category = [object objectForKey:@"category"];
    UIView *colorView = (UILabel*) [cell viewWithTag:99];
    colorView.frame = CGRectMake(0, 0, self.view.frame.size.width, colorView.frame.size.height);

    if([category isEqualToString:@"general"]) {
        colorView.backgroundColor = [[HSHackathonManager sharedInstance] primaryColor];
    } else if ([category isEqualToString:@"important"]) {
        colorView.backgroundColor = [[HSHackathonManager sharedInstance] hshacksRed];
    } else if ([category isEqualToString:@"food"]) {
        colorView.backgroundColor = [[HSHackathonManager sharedInstance] hshacksYellow]; 
    } else if([category isEqualToString:@"workshop"]) {
        colorView.backgroundColor = [UIColor lightGrayColor];
    }
    
    UILabel *senderLabel = (UILabel*) [cell viewWithTag:100];
    senderLabel.text = [object objectForKey:@"sender"];
    
    UILabel *titleLabel = (UILabel*) [cell viewWithTag:101];
    titleLabel.text = [object objectForKey:@"title"];
    
    //Set bodytext, adjust size of label
    UILabel *bodyText = (UILabel*) [cell viewWithTag:104];
    NSString *bodyString = [object objectForKey:@"body"];
    bodyText.text = bodyString;

    CGSize constraint = CGSizeMake(self.view.frame.size.width-16, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"OpenSans" size:14.0] forKey:NSFontAttributeName];
    CGRect newFrame = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    bodyText.frame = CGRectMake(bodyText.frame.origin.x,bodyText.frame.origin.y,self.view.frame.size.width-16, newFrame.size.height);
    [bodyText sizeToFit];
    
    //Set date label
    UILabel *timeLabel = (UILabel*) [cell viewWithTag:103];
    NSDate *time = object.createdAt;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/dd h:mm a"];
    timeLabel.text = [dateFormatter stringFromDate:time];
    
    return cell;
}


@end
