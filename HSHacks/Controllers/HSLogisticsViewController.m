//
//  HSLogisticsViewController.m
//  HSHacks
//
//  Created by Spencer Yen on 1/9/15.
//  Copyright (c) 2015 Alex Yeh. All rights reserved.
//

#import "HSLogisticsViewController.h"
#import "HSHackathonManager.h"

//start time
#define START_YEAR 2015
#define START_MONTH 2
#define START_DAY 7
#define START_HOUR 13
#define START_MIN 0
#define START_SEC 0

//end time
#define END_YEAR 2015
#define END_MONTH 2
#define END_DAY 8
#define END_HOUR 13
#define END_MIN 0
#define END_SEC 0

@interface HSLogisticsViewController () {
    NSDate *startDate;
    NSDate *endDate;
    NSDate *firstDay;
    NSUInteger flagsStart;
    NSUInteger flagsEnd;
}

@end

@implementation HSLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Schedule", @"Workshops", nil]];
    [segControl addTarget:self
                   action:@selector(changeView:)
         forControlEvents:UIControlEventValueChanged];
    [segControl setTintColor:[UIColor whiteColor]];
    [segControl sizeToFit];
    segControl.selectedSegmentIndex = 0;
    UIFont *font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];

    self.navigationItem.titleView = segControl;
    
    self.progressView.hidden = YES;
    
    _workshopsContainer.hidden = YES;
    _scheduleContainer.hidden = NO;
    [self.view bringSubviewToFront:_scheduleContainer];
    
    NSDateComponents* startDateComponents = [[NSDateComponents alloc] init];
    [startDateComponents setDay: START_DAY];
    [startDateComponents setMonth: START_MONTH];
    [startDateComponents setYear: START_YEAR];
    [startDateComponents setHour: START_HOUR];
    [startDateComponents setMinute: START_MIN];
    [startDateComponents setSecond: START_SEC];
    startDate = [[NSCalendar currentCalendar] dateFromComponents: startDateComponents];
    
    NSDateComponents* endDateComponents = [[NSDateComponents alloc] init];
    [endDateComponents setDay: END_DAY];
    [endDateComponents setMonth: END_MONTH];
    [endDateComponents setYear: END_YEAR];
    [endDateComponents setHour: END_HOUR];
    [endDateComponents setMinute: END_MIN];
    [endDateComponents setSecond: END_SEC];
    endDate = [[NSCalendar currentCalendar] dateFromComponents: endDateComponents];
    
    NSDateComponents* firstDayComponents = [[NSDateComponents alloc] init];
    [firstDayComponents setDay: 1];
    [firstDayComponents setMonth: 1];
    [firstDayComponents setYear: 2015];
    [firstDayComponents setHour: 0];
    [firstDayComponents setMinute: 0];
    [firstDayComponents setSecond: 0];
    firstDay = [[NSCalendar currentCalendar] dateFromComponents: firstDayComponents];
    
    flagsStart = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    flagsEnd = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSTimer *progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target: self
                            selector: @selector(updateProgressView) userInfo: nil repeats: YES];
    
}

-(void)changeView: (id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        //Show schedule
        _workshopsContainer.hidden = YES;
        _scheduleContainer.hidden = NO;
        [self.view bringSubviewToFront:_scheduleContainer];
    } else if (selectedSegment == 1) {
        //Show workshops
        _workshopsContainer.hidden = NO;
        _scheduleContainer.hidden = YES;
        [self.view bringSubviewToFront:_workshopsContainer];
    }
}

- (void)updateProgressView {
    self.progressView.hidden = NO;
    self.progressView.backgroundColor = [[HSHackathonManager sharedInstance] countdownColor];
    NSDateComponents *components;
    double ratio;
    double currentMin;
    double totalMin;
    if ([[NSDate date] compare: startDate] == NSOrderedAscending && [[NSDate date] compare: endDate] == NSOrderedAscending) {
         components = [[NSCalendar currentCalendar] components:flagsStart fromDate: [NSDate date] toDate: startDate options:0];
        if ((long)[components day] == 0) {
            self.countdownLabel.text = [NSString stringWithFormat:@"%ld:%ld:%ld until hacking begins!", (long)[components hour], (long)[components minute], (long)[components second]];
        } else {
            self.countdownLabel.text = [NSString stringWithFormat:@"%ld:%ld:%ld:%ld until hacking begins!", (long)[components day], (long)[components hour], (long)[components minute], (long)[components second]];
        }
        NSTimeInterval timeBetweenDates = [startDate timeIntervalSinceDate: firstDay];
        totalMin  = timeBetweenDates;
        
        timeBetweenDates = [[NSDate date] timeIntervalSinceDate: firstDay];
        currentMin = timeBetweenDates;
        
        ratio = currentMin/totalMin;
    } else if (([[NSDate date] compare: startDate] == NSOrderedDescending || [[NSDate date] compare: startDate] == NSOrderedSame) && [[NSDate date] compare: endDate] == NSOrderedAscending){
        components = [[NSCalendar currentCalendar] components:flagsEnd fromDate: [NSDate date] toDate: endDate options:0];
        self.countdownLabel.text = [NSString stringWithFormat:@"%ld:%ld:%ld until hacking ends!", (long)[components hour], (long)[components minute], (long)[components second]];
        NSTimeInterval timeBetweenDates = [endDate timeIntervalSinceDate: startDate];
        totalMin  = timeBetweenDates;
        
        timeBetweenDates = [[NSDate date] timeIntervalSinceDate: startDate];
        currentMin = timeBetweenDates;
        
        ratio = currentMin/totalMin;
    } else {
        self.countdownLabel.text = @"Hacking has ended. We hope you had fun!";
        ratio = 1;
    }
    
    self.countdownLabel.adjustsFontSizeToFitWidth = YES;
    self.progressView.frame = CGRectMake(self.progressView.frame.origin.x, self.progressView.frame.origin.y, self.view.frame.size.width * ratio, self.progressView.frame.size.height);
}


@end
