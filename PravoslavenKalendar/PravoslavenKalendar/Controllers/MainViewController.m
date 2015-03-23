//
//  MainViewController.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/2/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "MainViewController.h"
#import "OrthodoxDayViewController.h"
#import "UtilDates.h"
#import "OrthodoxFastingViewHolder.h"

#import "OrthodoxFastingView.h"
#import "OrthodoxWeekPageControll.h"
#import "UtilOrthodoxStrings.h"
#import "ColorsAndFonts.h"

#import "UtilConstraints.h"

#import "CalendarViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface MainViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, OrthodoxWeekPageControllDelegate, UIActionSheetDelegate, CalendarViewControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) id<OrthodoxDataProviderProtocol> orthodoxDataProvider;

@property (nonatomic, strong) NSArray *daysControllers;

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic) NSUInteger numberOfPresentedDay;

@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic) NSUInteger nextIndex;

@property (nonatomic, strong) OrthodoxDay *presentedDay;

@property (weak, nonatomic) IBOutlet UIView *detailHolder;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameOfMontLabel;

@property (weak, nonatomic) IBOutlet UILabel *holidayLabel;

@property (strong, nonatomic) NSArray *constraints;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *holidaysTableView;
@property (weak, nonatomic) IBOutlet OrthodoxFastingViewHolder *orthodoxFastingViewHolder;
@property (weak, nonatomic) IBOutlet UIView *additionalHolidaysHolder;
@property (weak, nonatomic) IBOutlet UIView *bottomHolder;

@property (weak, nonatomic) IBOutlet OrthodoxWeekPageControll *weekPageControl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainHolidayHolderHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *mainHolidayHolder;

@property (nonatomic) BOOL selected;

@property (weak, nonatomic) IBOutlet UILabel *oldMonthNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;

@property (strong, nonatomic) UITapGestureRecognizer *detailHolderFingerTap;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end

@implementation MainViewController

- (instancetype)initWithOrthodoxDataProvider:(id<OrthodoxDataProviderProtocol>)orthodoxDataProvider
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.orthodoxDataProvider = orthodoxDataProvider;
    }
    return self;
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [self.view layoutSubviews];
    
    self.mainHolidayHolderHeightConstraint.constant =  self.view.frame.size.height / 3;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //Due to iOS7 not supporting preferred width automatic
    CGRect holidayLabelFrame = self.holidayLabel.frame;
    holidayLabelFrame.size.width = self.view.frame.size.width;
    self.holidayLabel.frame = holidayLabelFrame;
}

- (void)pageViewControllerTapped:(id)sender
{
    self.selected = !self.selected;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _selected = NO;
    
    //initializing and setting the pageViewController
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    self.pageViewController.view.frame = self.view.frame;
    self.pageViewController.view.backgroundColor = [ColorsAndFonts primary];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self.view insertSubview:self.pageViewController.view belowSubview:self.detailHolder]; //detailHolder is defined in xib

    self.favoritesButton.layer.cornerRadius = 25.0;
    self.favoritesButton.backgroundColor = [ColorsAndFonts primary];
    [self.favoritesButton setImage:[UIImage imageNamed:@"button_favorites_normal"] forState:UIControlStateNormal];
    [self.favoritesButton setImage:[UIImage imageNamed:@"button_favorites_selected"] forState:UIControlStateSelected];

    
    self.detailHolder.backgroundColor = [UIColor clearColor];
    
    self.mainHolidayHolder.backgroundColor = [ColorsAndFonts whiteTransparent];
    self.additionalHolidaysHolder.backgroundColor = [ColorsAndFonts whiteTransparent];
    self.bottomHolder.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.95];
    
    self.weekPageControl.delegate = self;
    
    self.holidayLabel.font = [UIFont fontWithName:@"kapak" size:22];
    
    //adds tap recognizes
    UITapGestureRecognizer *pageViewFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageViewControllerTapped:)];
    [self.pageViewController.view addGestureRecognizer:pageViewFingerTap];
    
    UITapGestureRecognizer *holidayFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainHolidayLabelTapped:)];
    [self.holidayLabel addGestureRecognizer:holidayFingerTap];
    
    UITapGestureRecognizer *detailHolderFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailHolderTappd:)];
//    detailHolderFingerTap.cancelsTouchesInView = NO;
    detailHolderFingerTap.delegate = self;
    [self.detailHolder addGestureRecognizer:detailHolderFingerTap];
    self.detailHolderFingerTap = detailHolderFingerTap;
    
    UITapGestureRecognizer *dateLabelFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateLabelTapped:)];
    [self.dateLabel addGestureRecognizer:dateLabelFingerTap];
    
    self.dateLabel.userInteractionEnabled = YES;

    
    //initializes OrhodoxDayViewController(s) for whole week
    NSMutableArray *daysControllersMutable = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; ++i)
    {
        OrthodoxDayViewController *controller = [[OrthodoxDayViewController alloc] init];
        controller.pageIndex = i;
        [daysControllersMutable addObject:controller];
    }
    self.daysControllers = daysControllersMutable;
    
    self.holidaysTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.holidaysTableView.backgroundColor = [UIColor clearColor];
    
    [self setNumberOfCurrentDayFromDate:[NSDate date]]; //sets today date as a start on load

    [self.view setNeedsLayout];
    
     _toolbar.barStyle = -1;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.selected = _selected; //animates up or down the detailHolder
}

#pragma mark - UIPageController delegate & datasource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if(self.numberOfPresentedDay == [self.orthodoxDataProvider orthodoxDaysCount])
    {
        return nil;
    }
    
    NSUInteger index = ((OrthodoxDayViewController *) viewController).pageIndex;
    
    if (index == NSNotFound)
    {
        return nil;
    }
    index++;
    
    if (index == [self.daysControllers count])
    {
        index = 0; //in order to make circle
    }
    
   return self.daysControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if(self.numberOfPresentedDay == 1)
    {
        return nil;
    }
    
    NSUInteger index = ((OrthodoxDayViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound))
    {
        index = self.daysControllers.count; //in order to make circle
    }
    index--;
    
    return self.daysControllers[index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed)
    {
        if(self.currentIndex < self.nextIndex)
        {
            if(self.nextIndex == 6 && self.currentIndex == 0) //checks if makes circle back
            {
                self.numberOfPresentedDay--;
            }
            else
            {
                self.numberOfPresentedDay++;
            }
        }
        else
        {
            if(self.nextIndex == 0 && self.currentIndex == 6) //checks if makes circle forward
            {
                self.numberOfPresentedDay++;
            }
            else
            {
                self.numberOfPresentedDay--;
            }
        }
        self.currentIndex = self.nextIndex;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    OrthodoxDayViewController *pendingController = (OrthodoxDayViewController *)pendingViewControllers[0];
    self.nextIndex = [pendingController pageIndex];
    
    
    //prepares views that are about to be shown with the circle logic
    if(self.currentIndex < self.nextIndex)
    {
        if(self.nextIndex == 6 && self.currentIndex == 0)
        {
            pendingController.orthodoxDay = [self.orthodoxDataProvider orthodoxDayForDayNumber:self.numberOfPresentedDay - 1];
        }
        else
        {
            pendingController.orthodoxDay = [self.orthodoxDataProvider orthodoxDayForDayNumber:self.numberOfPresentedDay + 1];
        }
    }
    else
    {
        if(self.nextIndex == 0 && self.currentIndex == 6)
        {
            pendingController.orthodoxDay = [self.orthodoxDataProvider orthodoxDayForDayNumber:self.numberOfPresentedDay + 1];
        }
        else
        {
            pendingController.orthodoxDay = [self.orthodoxDataProvider orthodoxDayForDayNumber:self.numberOfPresentedDay - 1];
        }
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - Getter & Setter Overrides

- (void)setNumberOfCurrentDayFromDate:(NSDate *)date
{
    NSUInteger dayOfYear = [UtilDates numberOfDayInYearForDate:date];
    [self setNumberOfPresentedDay:dayOfYear adjustCalendar:YES];
}

- (void)setNumberOfPresentedDay:(NSUInteger)numberOfPresentedDay adjustCalendar:(BOOL)adjustCalendar
{
    _numberOfPresentedDay = numberOfPresentedDay;
    NSDate *presentedDate = [UtilDates dateFromNumberOfDay:_numberOfPresentedDay];
    
    if(adjustCalendar)
    {
        OrthodoxDayViewController *currentViewController = self.daysControllers[self.currentIndex];
        [currentViewController setBlurred:NO]; //unblurs the current view controller because it may scroll to another one
        
        NSCalendar *currentCalendar = [NSCalendar currentCalendar];
        NSDateComponents *weekdayComponents = [currentCalendar components:NSCalendarUnitWeekday fromDate:presentedDate];
        NSUInteger weekday = [weekdayComponents weekday];
        
        //setts the current index for the date
        if(weekday == 1) //NSDateComponents returns 1 for Sunday
        {
            self.currentIndex = 6;
        }
        else
        {
            self.currentIndex = weekday - 2;
        }
        
        OrthodoxDayViewController *todayViewController = self.daysControllers[self.currentIndex];
        todayViewController.orthodoxDay = [self.orthodoxDataProvider orthodoxDayForDayNumber:_numberOfPresentedDay];
        [todayViewController setBlurred:self.selected];
        
        [self.pageViewController setViewControllers:@[todayViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM"];
    
    self.dateLabel.text = [formatter stringFromDate:presentedDate];
    self.oldMonthNameLabel.text = [UtilOrthodoxStrings getOldMonthName:[UtilDates numberOfMonthForDate:presentedDate]];
    self.favoritesButton.selected = [self.favoritesManager doFavoriteForDateExits:presentedDate];
    
    OrthodoxDay *presentedDay = [self.orthodoxDataProvider orthodoxDayForDayNumber:numberOfPresentedDay];
    OrthodoxHoliday *firstHoliday = presentedDay.holidays[0];
    
    self.holidayLabel.text = firstHoliday.name;
    
    NSMutableArray *fastingElements = [[NSMutableArray alloc] init];
    for (NSString *string in presentedDay.fastingFoods)
    {
        if([string isEqualToString:@"Строг пост"])
        {
            [fastingElements addObject:[NSNumber numberWithInt:kOrthodoxFastingTypeFasting]];
            continue;
        }
        
        if([string isEqualToString:@"Без пост"])
        {
            [fastingElements addObject:[NSNumber numberWithInt:kOrthodoxFastingTypeNoFasting]];
            continue;
        }
        
        if([string isEqualToString:@"Масло"])
        {
            [fastingElements addObject:[NSNumber numberWithInt:kOrthodoxFastingTypeOil]];
            continue;
        }
        
        if([string isEqualToString:@"Без Масло"])
        {
            [fastingElements addObject:[NSNumber numberWithInt:kOrthodoxFastingTypeNoOil]];
            continue;
        }
        
        if([string isEqualToString:@"Вино"])
        {
            [fastingElements addObject:[NSNumber numberWithInt:kOrthodoxFastingTypeWine]];
            continue;
        }
        
        if([string isEqualToString:@"Риба"])
        {
            [fastingElements addObject:[NSNumber numberWithInt:kOrthodoxFastingTypeFish]];
            continue;
        }
        
        if([string isEqualToString:@"Млечни"])
        {
            [fastingElements addObject:[NSNumber numberWithInt:kOrthodoxFastingTypeDiary]];
            continue;
        }
    }
    
    [self.orthodoxFastingViewHolder setFastingElements:fastingElements];
    
    self.presentedDay = presentedDay;
    
    [self.holidaysTableView reloadData];
}

- (void)setNumberOfPresentedDay:(NSUInteger)numberOfPresentedDay
{
    [self setNumberOfPresentedDay:numberOfPresentedDay adjustCalendar:NO];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    for (UIScrollView *view in self.pageViewController.view.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            view.scrollEnabled = !selected;
        }
    }
    
    [self.daysControllers[self.currentIndex] setBlurred:self.selected];
    
    [UIView animateWithDuration:0.5 animations:^{
        if(selected)
        {
            self.bottomConstraint.constant = 0;

        }
        else
        {
            self.bottomConstraint.constant =  - (self.detailHolder.frame.size.height - self.mainHolidayHolder.frame.size.height - 25);
        }
        [self.view layoutIfNeeded];
    }];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
    self.weekPageControl.selectedItem = currentIndex; //updates selecte item on the OrthodoxPageControll
}

#pragma mark - UITableView Delegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.presentedDay.holidays.count - 1; //becuase the holiday at postion 0 is set on the main label
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"OrthodoxHoliday";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    cell.textLabel.text = [self.presentedDay.holidays[indexPath.row + 1] name]; //plus 1 because the main holiday is at zero position in the datasource
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrthodoxHoliday *holiday = self.presentedDay.holidays[indexPath.row + 1]; //plus 1 because the main holiday is at zero position in the datasource
    [self presentOpenURLActionSheetForHoliday:holiday];
}

#pragma mark - Actions

- (IBAction)favoritesButtonTapped:(id)sender
{
    self.favoritesButton.selected = !self.favoritesButton.selected;
    if(self.favoritesButton.selected)
    {
        [self.favoritesManager saveDayToFavorites:self.presentedDay error:nil];
    }
    else
    {
        [self.favoritesManager removeDayFromFavorites:self.presentedDay error:nil];
    }
}

- (void)mainHolidayLabelTapped:(id)sender
{
    OrthodoxHoliday *holiday = self.presentedDay.holidays[0]; //main holiday is always at zero position
    [self presentOpenURLActionSheetForHoliday:holiday];
}
                                
- (void)presentOpenURLActionSheetForHoliday:(OrthodoxHoliday *)holiday
{
      [[[UIActionSheet alloc] initWithTitle:[holiday descriptionUrl] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open link in Safari", nil), NSLocalizedString(@"Copy link", nil),nil] showInView:self.view];
}

- (IBAction)shareButtonTapped:(id)sender
{
    NSURL *url = [NSURL URLWithString:[self.presentedDay.holidays[0] descriptionUrl]];
    NSString *string = [self.presentedDay.holidays[0] name];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[string,url] applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)calendarButtonTapped:(id)sender
{
    CalendarViewController *calendar = [[CalendarViewController alloc] init];
    calendar.delegate = self;
    calendar.favoritesManager = self.favoritesManager;
    [self presentCalendarViewController:calendar];
}

- (void)detailHolderTappd:(UITapGestureRecognizer *)recognizer
{
    self.selected = !self.selected;
}

- (void)dateLabelTapped:(UITapGestureRecognizer *)recognizer
{
    CalendarViewController *calendar = [[CalendarViewController alloc] init];
    calendar.delegate = self;
    calendar.favoritesManager = self.favoritesManager;
    [self presentCalendarViewController:calendar];
}

#pragma mark - Orthodox Week Page Control

- (void)orthodoxPageControll:(OrthodoxWeekPageControll *)pageControl didSelectIndex:(NSInteger)index
{
    [(OrthodoxDayViewController *)self.daysControllers[self.currentIndex] setBlurred:NO];
    
    self.numberOfPresentedDay = _numberOfPresentedDay - (_currentIndex - index);
    self.currentIndex = index;
    OrthodoxDayViewController *todayViewController = self.daysControllers[self.currentIndex];
    todayViewController.orthodoxDay = [self.orthodoxDataProvider orthodoxDayForDayNumber:self.numberOfPresentedDay];
    todayViewController.blurred = self.selected;
    
    [self.pageViewController setViewControllers:@[todayViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark - Action Sheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    
    if(buttonIndex==0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
    }
    
    if(buttonIndex==1)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = actionSheet.title;
    }
}

#pragma mark - Calendar delegate 

- (void)calendarViewController:(CalendarViewController *)controller didSelectDate:(NSDate *)date
{
    [self hideCalendarViewController:controller];
    NSCalendar* calendar = [NSCalendar currentCalendar];
   
    NSDateComponents* components = [calendar components:NSCalendarUnitYear fromDate:date];
    if(components.year == 2015)
    {
        [self setNumberOfCurrentDayFromDate:date];
    }
    else
    {
        if(components.year < 2015)
        {
            [self setNumberOfPresentedDay:1 adjustCalendar:YES];
        }
        else
        {
            [self setNumberOfPresentedDay:365 adjustCalendar:YES];
        }
    }
}

- (void)calendarViewControllerDidClose:(CalendarViewController *)controller
{
    [self hideCalendarViewController:controller];
}

#pragma mark - Private Methods

- (void)presentCalendarViewController:(CalendarViewController *)controller
{
    [self addChildViewController:controller];

    controller.view.frame = self.view.frame;
    controller.view.alpha = 0.0;
    
    [self.view addSubview:controller.view];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         controller.view.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [controller didMoveToParentViewController:self];
//                         self.selected = NO; //is not looking good and has no sence
                     }];
}

- (void)hideCalendarViewController:(CalendarViewController *)controller
{
    [controller willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         controller.view.alpha = 0.0;
                     }
                     completion:^(BOOL completed){
                         [controller.view removeFromSuperview];
                         [controller removeFromParentViewController];
                     }];
}

#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if([gestureRecognizer isEqual:self.detailHolderFingerTap])
    {
        if(IS_OS_8_OR_LATER)
        {
            if([touch.view.superview isKindOfClass:[UITableViewCell class]])
            {
                return NO;
            }
        }
        else
        {
            if([touch.view.superview.superview isKindOfClass:[UITableViewCell class]])
            {
                return NO;
            }
        }
    }
    return YES;
}

@end
