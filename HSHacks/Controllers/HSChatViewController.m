//
//  HSChatViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 1/9/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import "HSChatViewController.h"
#import "HSLoginViewController.h"
#import "HSUser.h"
#import <QuartzCore/QuartzCore.h>
#import "SDWebImage/UIImageView+WebCache.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "HSHackathonManager.h"

@interface HSChatViewController () {
    BOOL connected;
}

@end

@implementation HSChatViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"Chat";
    self.chatTextField.delegate = self;
    
    [SVProgressHUD setForegroundColor:[[HSHackathonManager sharedInstance] primaryColor]];
    [SVProgressHUD show];
    self.chatTextField.userInteractionEnabled = NO;
    self.chatTextField.enablesReturnKeyAutomatically = YES;
    
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.chatTableView.separatorColor = [UIColor clearColor];
    
    [self.chatSendButton setTitleColor:[[HSHackathonManager sharedInstance] primaryColor] forState:UIControlStateNormal];
    [self.chatSendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

    self.chat = [[NSMutableArray alloc] init];
    self.firebase = [[Firebase alloc] initWithUrl:[HSHackathonManager sharedInstance].firebaseChatURL];
    
    HSUser *user = [HSUser sharedManager];

    //Store name and photoURL in UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    user.userName = [defaults objectForKey:@"name"];
    user.userPhoto = [defaults objectForKey:@"photo"];
    
    self.name = user.userName;
    self.photoURL = user.userPhoto;
    
    if(!self.name || !self.photoURL) {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Slow down there!" message:@"You need to log in with Facebook or Twitter in order to chat here." delegate:self cancelButtonTitle:@"I will succumb to your social constructs!" otherButtonTitles:nil];
        [alert show];
    // init chat wihtout sending message
    } else {
        [[self.firebase childByAutoId] setValue:@{@"name" : self.name, @"text": @"initlolthisisreallybad", @"photo":self.photoURL}];
    }
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        if(self.chat.count > 50) {
            [self.chat removeObjectsInRange:NSMakeRange(0, 10)];
        }
        
        if(![[snapshot.value objectForKey:@"text"] isEqualToString:@"initlolthisisreallybad"]){
            [self.chat addObject:snapshot.value];
        }
        
        [SVProgressHUD dismiss];
        [self.chatTableView reloadData];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.chatTableView.hidden = NO;
            self.chatTextField.userInteractionEnabled = TRUE;
            if(self.chat.count > 1){
                [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.chatTableView.hidden = YES;

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}
- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Text field handling

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField {
    [self sendMessageInTextField];
    return NO;
}

- (IBAction)sendPressed:(id)sender {
    [self sendMessageInTextField];
}

- (void)sendMessageInTextField {
    if(!self.name || !self.photoURL) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Slow down there!" message:@"You need to log in with Facebook or Twitter in order to chat here." delegate:self cancelButtonTitle:@"I will succumb to your social constructs!" otherButtonTitles:nil];
        [alert show];
    } else {
        if(self.name && self.photoURL){
            [[self.firebase childByAutoId] setValue:@{@"name" : self.name, @"text": self.chatTextField.text, @"photo" : self.photoURL}];
        }
        if([self.chatTextField.text isEqualToString:@"hellyeah"]){
            UILabel *hellYeahLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 300, 50)];
            hellYeahLabel.center = self.view.center;
            hellYeahLabel.text = @"#HELLYEAHHH";
            hellYeahLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size:50.0];
            hellYeahLabel.adjustsFontSizeToFitWidth = YES;
            hellYeahLabel.textColor = [[HSHackathonManager sharedInstance] primaryColor];
            hellYeahLabel.textAlignment = NSTextAlignmentCenter;
            hellYeahLabel.alpha = 0;
            [self.view addSubview:hellYeahLabel];
            
            hellYeahLabel.transform = CGAffineTransformMakeScale(0.01, 0.01);
            hellYeahLabel.alpha = 1;
            [UIView animateWithDuration:1.2 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                hellYeahLabel.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                [UIView animateWithDuration:1.5 delay:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    hellYeahLabel.alpha = 0;
                } completion:nil];
            }];
        }
        [self.chatTextField setText:@""];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section {
    return [self.chat count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *bodyString= [self.chat objectAtIndex:indexPath.row][@"text"];

    CGSize constraint = CGSizeMake(self.view.frame.size.width-70, MAXFLOAT);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"OpenSans" size:15.0] forKey:NSFontAttributeName];
    CGRect textsize = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    float textHeight = textsize.size.height;
    
    return textHeight + 33;
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ChatCell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:0.02];
    else
        cell.backgroundColor = [UIColor colorWithRed:189.0/255.0 green:195.0/255.0 blue:199.0/255.0 alpha:0.1];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* chatMessage = [self.chat objectAtIndex:indexPath.row];
    
    UIImageView *imageView = (UIImageView*) [cell viewWithTag:100];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;

    [imageView sd_setImageWithURL:[NSURL URLWithString:chatMessage[@"photo"]] placeholderImage:[UIImage imageNamed:@"placeholderIcon.png"]];
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = chatMessage[@"name"];
    
    UILabel *messageLabel = (UILabel*) [cell viewWithTag:102];
    NSString *message = chatMessage[@"text"];
    
    CGSize constraint = CGSizeMake(self.view.frame.size.width-70, MAXFLOAT);
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"OpenSans" size:15.0] forKey:NSFontAttributeName];
    CGRect textsize = [message boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    messageLabel.frame = CGRectMake(57,27,self.view.frame.size.width-70, textsize.size.height);
    messageLabel.text = message;
    [messageLabel sizeToFit];
    
    return cell;
}

#pragma mark - Keyboard handling

- (void)keyboardWillShow:(NSNotification*)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    CGRect chatTextFieldFrame = CGRectMake(self.chatTextField.frame.origin.x,self.view.frame.size.height - keyboardSize.height - self.chatTextField.frame.size.height - 5,self.chatTextField.frame.size.width,self.chatTextField.frame.size.height);
    CGRect chatSendButtonFrame = CGRectMake(self.chatSendButton.frame.origin.x,chatTextFieldFrame.origin.y,self.chatSendButton.frame.size.width,self.chatSendButton.frame.size.height);
    CGRect chatTableViewFrame = CGRectMake(0,64,self.view.frame.size.width,chatTextFieldFrame.origin.y - 69);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.chatTextField.frame = chatTextFieldFrame;
        self.chatSendButton.frame = chatSendButtonFrame;
        self.chatTableView.frame = chatTableViewFrame;
    }];
    
    if(self.chat.count > 1) {
        if([NSIndexPath indexPathForRow:self.chat.count-1 inSection:0]){
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    CGRect chatTextFieldFrame = CGRectMake(self.chatTextField.frame.origin.x,self.view.frame.size.height - 49 - self.chatTextField.frame.size.height - 5,self.chatTextField.frame.size.width,self.chatTextField.frame.size.height);
    CGRect chatSendButtonFrame = CGRectMake(self.chatSendButton.frame.origin.x,chatTextFieldFrame.origin.y,self.chatSendButton.frame.size.width,self.chatSendButton.frame.size.height);
    CGRect chatTableViewFrame = CGRectMake(0,64,self.view.frame.size.width,chatTextFieldFrame.origin.y - 69);

    [UIView animateWithDuration:0.3 animations:^{
        self.chatTextField.frame = chatTextFieldFrame;
        self.chatSendButton.frame = chatSendButtonFrame;
        self.chatTableView.frame = chatTableViewFrame;
    }];
    
    if(self.chat.count > 1) {
        if([NSIndexPath indexPathForRow:self.chat.count-1 inSection:0]){
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chat.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

- (IBAction)logoutPressed:(id)sender {
    HSUser *userData = [HSUser sharedManager];
    userData.userName = nil;
    userData.userPhoto = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"name"];
    [defaults setObject:nil forKey:@"photo"];
    [defaults setObject:@"YES" forKey:@"loggedIn"];

    [defaults synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HSLoginViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"HSLoginViewController"];
    
    loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:loginVC animated:YES completion:nil];
}

@end
