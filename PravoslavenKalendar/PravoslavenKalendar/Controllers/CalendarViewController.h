//
//  CalendarViewController.h
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/17/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrthodoxFavoritesManagerProtocol.h"
@class CalendarViewController;

@protocol CalendarViewControllerDelegate <NSObject>

@optional
- (void)calendarViewController:(CalendarViewController *)controller didSelectDate:(NSDate *)date;
- (void)calendarViewControllerDidClose:(CalendarViewController *)controller;

@end

@interface CalendarViewController : UIViewController

@property (nonatomic, weak) id<CalendarViewControllerDelegate> delegate;

@property (nonatomic, strong) id<OrthodoxFavoritesManagerProtocol> favoritesManager;

@end
