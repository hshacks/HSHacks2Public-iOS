//
//  HSChatViewController.h
//  HSHacks
//
//  Created by Spencer Yen on 1/9/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface HSChatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *photoURL;
@property (nonatomic, strong) NSMutableArray *chat;
@property (nonatomic, strong) Firebase *firebase;

@property (strong, nonatomic) IBOutlet UITableView *chatTableView;
@property (strong, nonatomic) IBOutlet UITextField *chatTextField;
@property (strong, nonatomic) IBOutlet UIButton *chatSendButton;

- (IBAction)logoutPressed:(id)sender;
- (IBAction)sendPressed:(id)sender;

@end
