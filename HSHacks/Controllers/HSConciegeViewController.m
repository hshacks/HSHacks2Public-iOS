//
//  HSConciegeViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 1/9/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import "HSConciegeViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "HSHackathonManager.h"

#define PARSE_CONCIERGE_CLASS_NAME @"Mentors"

@interface HSConciegeViewController ()

@end

@implementation HSConciegeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.topItem.title = @"Concierge";
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    PFQuery *query = [PFQuery queryWithClassName:@"mentors"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for(int i = 0; i < objects.count; i++){
                [objects[i] objectForKey:@"name"];
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadObjects];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        self.textKey = @"name";
        
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = NO;
        self.objectsPerPage = 150;
        self.sections = [NSMutableDictionary dictionary];
        self.sectionToCompanyMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CONCIERGE_CLASS_NAME];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    // Order by company
    [query orderByAscending:@"companyID"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    return query;
}

- (NSString *)companyForSection:(NSInteger)section {
    return [self.sectionToCompanyMap objectForKey:[NSNumber numberWithInt:section]];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
    [self.sections removeAllObjects];
    [self.sectionToCompanyMap removeAllObjects];
    
    NSInteger section = 0;
    NSInteger rowIndex = 0;
    for (PFObject *object in self.objects) {
        NSString *company = [object objectForKey:@"company"];
        NSLog(@"company: %@", company);
        NSMutableArray *objectsInSection = [self.sections objectForKey:company];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
            
            // this is the first time we see this company - increment the section index
            [self.sectionToCompanyMap setObject:company forKey:[NSNumber numberWithInt:section++]];
        }
        
        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
        [self.sections setObject:objectsInSection forKey:company];
    }
    [self.tableView reloadData];
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSString *company = [self companyForSection:indexPath.section];
    
    NSArray *rowIndecesInSection = [self.sections objectForKey:company];
    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
    return [self.objects objectAtIndex:[rowIndex intValue]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *company = [self companyForSection:section];
    NSArray *rowIndecesInSection = [self.sections objectForKey:company];
    return rowIndecesInSection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *company = [self companyForSection:section];
    return company;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [view setBackgroundColor:[[HSHackathonManager sharedInstance] primaryColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:@"OpenSans-Bold" size:16]];
    [label setTextColor:[UIColor whiteColor]];
    NSString *company = [self companyForSection:section];
    [label setText:company];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    PFObject *selectedObject = [self objectAtIndexPath:indexPath];
    if([[selectedObject objectForKey:@"contactType"]isEqualToString: @"email"]){
        NSString *messageBody = [NSString stringWithFormat:@"Hey %@,", [selectedObject objectForKey:@"name"]];
        NSArray *sendArray = [NSArray arrayWithObject:[selectedObject objectForKey:@"contactInfo"]];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        [mc setSubject:@"HSHacks Help"];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:sendArray];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
    
    if([[selectedObject objectForKey:@"contactType"]isEqualToString: @"twitter"]){
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            NSString *message = [NSString stringWithFormat:@"Hey %@, ", [selectedObject objectForKey:@"contactInfo"]];
            [tweetSheet setInitialText:message];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
    }
    
    if([[selectedObject objectForKey:@"contactType"]isEqualToString: @"phone"]){
        
        NSArray *sendArray = [NSArray arrayWithObject:[selectedObject objectForKey:@"contactInfo"]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            
            [messageController setRecipients:sendArray];
            [messageController setBody:[NSString stringWithFormat:@"Hey %@, ", [selectedObject objectForKey:@"name"]]];
            [self presentViewController:messageController animated:YES completion:nil];
        });
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *simpleTableIdentifier = @"ConciergeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    // If no skills, then move name downto center of cell
    

    UILabel *nameLabel = (UILabel*) [cell viewWithTag:100];
    nameLabel.text = [object objectForKey:@"name"];
    
    UILabel *skillsLabel = (UILabel*) [cell viewWithTag:101];
    skillsLabel.text = [object objectForKey:@"skills"];
    
    //Set the photo
    UIImageView *comImage = (UIImageView*) [cell viewWithTag:102];
    if([[object objectForKey:@"contactType"]isEqualToString: @"email"]){
        comImage.image = [UIImage imageNamed:@"email.png"];
    } else if([[object objectForKey:@"contactType"]isEqualToString: @"twitter"]){
        comImage.image = [UIImage imageNamed:@"twitter.png"];
    } else if([[object objectForKey:@"contactType"]isEqualToString: @"phone"]){
        comImage.image = [UIImage imageNamed:@"phone.png"];
    }
    comImage.frame = CGRectMake(self.view.frame.size.width-50, comImage.frame.origin.y, comImage.frame.size.width, comImage.frame.size.height);
    
    return cell;
}

@end
