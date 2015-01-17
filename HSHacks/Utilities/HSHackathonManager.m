//
//  HSHackathonManager.m
//  HSHacks
//
//  Created by Spencer Yen on 1/12/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

/* 
 
Hey! If you want to customize parts of this app, follow these instructions:

1. Change the stuff in sharedInstance below. (logo, hackathon name, firebasechaturl, parse stuff)
    - Apologies for the way logo works, our HSHacks logo is not a square so the dimensions for your logo will likely be off. Go to HSLoginViewController and change the logo sizes/magnification to whatever you like. 
 
2. Change the color scheme below.
    - The primary color is color for nav bar, tab bar tint
    - The secondary color should be darker, used for the logistics tab's cell (fake) headers
    - The third color is the color of the countdown shade.
 
3. I had to make this app super quickly, so I used storyboard :/ So if you want to change fonts, you'll have to go into storyboard and change all the fonts. Right now it uses Open Sans for all the body text (pretty standard) and DIN Condensed Bold for nav bar/login logo animation.
 
4. For login with facebook, you're going to have to replace all the facebook app id stuff in the Info.plist. 
 
5. Login with twitter is slightly more complicated as we're using their new Fabric framework, which makes integration super easy but sharing code a bit harder.
   - I deleted our own Fabric account, so he best thing do to here is to go to www.fabric.io and manually add fabric again to this project. Code is the same.
 
6. For Parse:
    a. You're going to need 4 parse classes
        - Announcements
            1. title (string) 2. body (string) 3. sender (string) 4. category (string, right now app is configured to take important, general, food, workshops)
        - Schedule
            1. name (string) 2. description (string) 3. time (date)
        - Workshops (you can change this to something like awards or tech talks if you don't have workshops?)
            1. name (string) 2. description (string) 3. time (date)
        - Concierge (confusingly called 'mentors' in HSHacks' case)
            1. name (string) 2. company (string) 3. contactInfo (string - @sample, sample@sample.com, 4081231234) 4. contactType (string - twitter, phone, email) 5. skills (string)
    b. If you decide to use different classes or rename them, make sure to change them in each class. It's a constant at the top of each class.
    c. For push notifications to work, follow this guide: https://parse.com/tutorials/ios-push-notifications 

7. To change the times of the countdown timer, go into HSLogisticsViewController and change the constants at the top to what your hackathon times are. 

8. Launch image and app icon is in images.xcassets
 
9.  Again, apologies for using storyboard/not autolayout. Feel free to change anything, but give credit where credit is due :)
    
    You probably have complaints or questions, so find me on facebook or github issue or something.
 
    Made by Spencer Yen and Alex Yeh
*/


#import "HSHackathonManager.h"

@implementation HSHackathonManager

+ (HSHackathonManager *)sharedInstance {
    static HSHackathonManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[HSHackathonManager alloc] init];
        _sharedInstance.largeLogoFileName = @"logoLargeTransparent.png";
#warning MAKE SURE YOU GO INTO LOGINVC AND CHANGE THE DEFINED DIMENSIONS OF YOUR LOGO
        _sharedInstance.hackathonName = @"HACKATHON_NAME";
        _sharedInstance.firebaseChatURL =  @"YOUR_FIREBASE_CHAT_URL_HERE";
        _sharedInstance.parseAppID = @"YOUR_PARSE_APP_ID";
        _sharedInstance.parseClientKey = @"YOUR_PARSE_CLIENT_KEY";
        //Title font is the font in the nav bar
        _sharedInstance.titleFont = [UIFont fontWithName:@"DINCondensed-Bold" size:36];
        
    });
    return _sharedInstance;
}

- (UIColor *)primaryColor {
    return [UIColor colorWithRed:88.0/255.0 green:176.0/255.0 blue:213.0/255.0 alpha:1.0f];
}

- (UIColor *)secondaryColor {
    return [UIColor colorWithRed:64.0/255.0 green:138.0/255.0 blue:183.0/255.0 alpha:1.0f];
}

-(UIColor *)countdownColor {
    return [UIColor colorWithRed:88.0/255.0 green:176.0/255.0 blue:213.0/255.0 alpha:1.0f];
}

- (UIColor *)hshacksRed {
    return [UIColor colorWithRed:192/255.0 green:57/255.0 blue:43/255.0 alpha:1.0f];
}

- (UIColor *)hshacksYellow {
    return [UIColor colorWithRed:243/255.0 green:156/255.0 blue:18/255.0 alpha:1.0f];
}

@end
