//
//  HSLoginViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 1/9/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import "HSLoginViewController.h"
#import "HSHackathonManager.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "HSUser.h"
#import <TwitterKit/TwitterKit.h>
#import <Parse-iOS/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#define LOGO_WIDTH 1724*3.5
#define LOGO_HEIGHT 1984*3.5
#define SHRINK_FACTOR 35
#define FONT_SIZE 20

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@interface HSLoginViewController () {
    
}

@end

@implementation HSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    self.view.backgroundColor = [[HSHackathonManager sharedInstance] primaryColor];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: [HSHackathonManager sharedInstance].largeLogoFileName]];
    logoImageView.frame = CGRectMake(0, 0, LOGO_WIDTH, LOGO_HEIGHT);
    logoImageView.center = CGPointMake(self.view.center.x, self.view.center.y);
    
    UILabel *welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.text = [NSString stringWithFormat: @"WELCOME TO %@.", [HSHackathonManager sharedInstance].hackathonName];
    welcomeLabel.font = [UIFont fontWithName:@"DINCondensed-Bold" size: FONT_SIZE*3.5];
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.adjustsFontSizeToFitWidth = YES;
    welcomeLabel.alpha = 0.0;
    
    UIButton *fbLoginButton = [[UIButton alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - 205, self.view.frame.size.width, 80)];
    [fbLoginButton addTarget:self action:@selector(facebookLoginTapped:) forControlEvents:UIControlEventTouchUpInside];
    fbLoginButton.backgroundColor = [UIColor colorWithRed: 59.0/255.0 green: 89.0/255.0 blue: 152.0/255.0 alpha: 1.0];
    [fbLoginButton setTitle:@"LOGIN WITH FACEBOOK" forState:UIControlStateNormal];
    fbLoginButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size: FONT_SIZE];
    [fbLoginButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [fbLoginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    UIView *fbBlankView = [[UIView alloc] initWithFrame: fbLoginButton.frame];
    fbBlankView.backgroundColor = [[HSHackathonManager sharedInstance] primaryColor];
    
    UIButton *twitterLoginButton = [[UIButton alloc] initWithFrame: CGRectMake(0, fbLoginButton.frame.origin.y+fbLoginButton.frame.size.height, self.view.frame.size.width, 80)];
    [twitterLoginButton addTarget:self action:@selector(twitterLoginTapped:) forControlEvents:UIControlEventTouchUpInside];
    twitterLoginButton.backgroundColor = [UIColor colorWithRed: 64.0/255.0 green: 153.0/255.0 blue: 255.0/255.0 alpha: 1.0];
    [twitterLoginButton setTitle:@"LOGIN WITH TWITTER" forState:UIControlStateNormal];
    twitterLoginButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size: FONT_SIZE];
    [twitterLoginButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [twitterLoginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    UIView *twitterBlankView = [[UIView alloc] initWithFrame: twitterLoginButton.frame];
    twitterBlankView.backgroundColor = [[HSHackathonManager sharedInstance] primaryColor];
    
    UIButton *guestButton = [[UIButton alloc] initWithFrame: CGRectMake(0, twitterLoginButton.frame.origin.y+twitterLoginButton.frame.size.height + 10, self.view.frame.size.width, 25)];
    [guestButton setTitle:@"Continue as Guest" forState:UIControlStateNormal];
    [guestButton addTarget:self action:@selector(guestLoginTapped:) forControlEvents:UIControlEventTouchUpInside];
    guestButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size: FONT_SIZE - 4];
    [guestButton setTitleColor: [UIColor whiteColor] forState: UIControlStateNormal];
    [guestButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    guestButton.alpha = 0;
    
    [self.view addSubview: welcomeLabel];
    [self.view addSubview: fbLoginButton];
    [self.view addSubview: fbBlankView];
    [self.view addSubview: twitterLoginButton];
    [self.view addSubview: twitterBlankView];
    [self.view addSubview: guestButton];
    [self.view addSubview: logoImageView];
    
    [UIView animateWithDuration: 1.0f delay: 0.0f options: UIViewAnimationOptionCurveEaseInOut animations:^{
        //animate logo
        CGRect logoImageViewFrameShrink = CGRectMake(logoImageView.frame.origin.x + logoImageView.frame.size.width/2 - LOGO_WIDTH/SHRINK_FACTOR/2, logoImageView.frame.origin.y + logoImageView.frame.size.height/2 - LOGO_HEIGHT/SHRINK_FACTOR/2, LOGO_WIDTH/SHRINK_FACTOR, LOGO_HEIGHT/SHRINK_FACTOR);
        logoImageView.frame = logoImageViewFrameShrink;
    }completion:^(BOOL finished) {
        //shift logo
        [UIView animateWithDuration: 1.0f delay: 0.35f options: UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect logoImageViewFrameShift = CGRectMake(logoImageView.frame.origin.x, self.view.center.y - self.view.frame.size.height/2.5, logoImageView.frame.size.width, logoImageView.frame.size.height);
            logoImageView.frame = logoImageViewFrameShift;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration: 0.4f delay: 0.f options: UIViewAnimationOptionCurveEaseOut animations:^{
                //animate fb
                fbBlankView.frame = CGRectMake(self.view.frame.size.width, fbBlankView.frame.origin.y, fbBlankView.frame.size.width, fbBlankView.frame.size.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration: 0.4f delay: 0.f options: UIViewAnimationOptionCurveEaseOut animations:^{
                    //animate twitter
                     twitterBlankView.frame = CGRectMake(0 - twitterBlankView.frame.size.width, twitterBlankView.frame.origin.y, twitterBlankView.frame.size.width, twitterBlankView.frame.size.height);
                } completion:^(BOOL finished) {
                    if(IS_IPHONE_6 || IS_IPHONE_6P) {
                        welcomeLabel.frame = CGRectMake(13, logoImageView.frame.origin.y + logoImageView.frame.size.height + 40, self.view.frame.size.width - 26, 50);
                    } else {
                        welcomeLabel.frame = CGRectMake(13, logoImageView.frame.origin.y + logoImageView.frame.size.height + 25, self.view.frame.size.width - 26, 50);
                    }
                    [UIView animateWithDuration: 2.0 animations:^{
                        //animate welcome
                        welcomeLabel.alpha = 1.0;
                        guestButton.alpha = 1;
                    }];
                }];
            }];
        }];
    }];
}

- (void)guestLoginTapped:(id)sender {
    [self doneWithLogin];
}

- (void)facebookLoginTapped:(id)sender {
    [SVProgressHUD setForegroundColor:[[HSHackathonManager sharedInstance] primaryColor]];
    [SVProgressHUD showWithStatus:@"Logging into Facebook..." maskType:SVProgressHUDMaskTypeClear];
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"public_profile",
                            nil];
    [PFFacebookUtils initializeFacebook];
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"The guy who wrote this Facebook login code did something wrong." delegate: nil cancelButtonTitle:@"Okay, I'll tell him." otherButtonTitles:nil];
            [alert show];

        } else {
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary *user = (NSDictionary *)result;
                    HSUser *userData = [HSUser sharedManager];
                    userData.userName = user[@"name"];
                    NSString *photo = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=square", user[@"id"]];
                    userData.userPhoto = photo;
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:userData.userName forKey:@"name"];
                    [defaults setObject:userData.userPhoto forKey:@"photo"];
                    
                    [defaults synchronize];
                    [SVProgressHUD dismiss];
                    
                    [self doneWithLogin];
                } else {
                    [SVProgressHUD dismiss];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"The guy who wrote this Facebook login code did something wrong." delegate: nil cancelButtonTitle:@"Okay, I'll tell him." otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
    }];
}

- (void)twitterLoginTapped:(id)sender {
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         if (session) {
             NSLog(@"signed in as %@", [session userName]);
             [[[Twitter sharedInstance] APIClient] loadUserWithID:session.userID
                                                       completion:^(TWTRUser *user,
                                                                    NSError *error) {
                 if(!error) {
                     HSUser *userData = [HSUser sharedManager];
                     userData.userName = user.name;
                     userData.userPhoto = user.profileImageLargeURL;
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:userData.userName forKey:@"name"];
                     [defaults setObject:userData.userPhoto forKey:@"photo"];
                     
                     [defaults synchronize];

                     [self doneWithLogin];
                 } else {
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"The guy who wrote this Twitter login code did something wrong." delegate: nil cancelButtonTitle:@"Okay, I'll tell him." otherButtonTitles:nil];
                     [alert show];
                 }
             }];
         } else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Oops." message: @"The guy who wrote this Twitter login code did something wrong." delegate: nil cancelButtonTitle:@"Okay, I'll tell him." otherButtonTitles:nil];
             [alert show];
         }
     }];
}

-(void)doneWithLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"loggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBar = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBar"];
    tabBar.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:tabBar animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
