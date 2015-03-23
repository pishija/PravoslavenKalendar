//
//  CalendarViewController.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/17/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "CalendarViewController.h"
#import <JTCalendar.h>


@interface CalendarViewController () <JTCalendarDataSource>

@property (nonatomic, strong) JTCalendar *calendar;

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;
@property (weak, nonatomic) IBOutlet UIView *dimView;

@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.dimView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calendarViewTapped:)]];
    
    self.calendar = [[JTCalendar alloc] init];
    
    self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
    self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
    self.calendar.calendarAppearance.ratioContentMenu = 2.;
    self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    [self.calendar reloadData];
    
    NSDate *date = [NSDate date];
    
    [self.calendar setCurrentDate:date];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [self.calendar repositionViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTapped:(id)sender
{
    [self.calendar setCurrentDate:[NSDate date]];
}
#pragma mark - Calendar Datasource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    return [self.favoritesManager doFavoriteForDateExits:date];
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    if([self.delegate respondsToSelector:@selector(calendarViewController:didSelectDate:)])
    {
        [self.delegate calendarViewController:self didSelectDate:date];
    }
}

#pragma mark - Action 

- (void)calendarViewTapped:(UIGestureRecognizer *)gesture
{
    if([self.delegate respondsToSelector:@selector(calendarViewControllerDidClose:)])
    {
        [self.delegate calendarViewControllerDidClose:self];
    }
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
