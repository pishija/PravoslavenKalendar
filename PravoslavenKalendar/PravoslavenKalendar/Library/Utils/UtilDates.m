//
//  UtilDates.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/3/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "UtilDates.h"

@implementation UtilDates

+ (NSDate *)dateFromNumberOfDay:(NSUInteger)numberOfDay
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    [components setDay:numberOfDay];
    [components setYear:[[currentCalendar components:NSCalendarUnitYear fromDate:[NSDate date]] year]];

    return [currentCalendar dateFromComponents:components];
}

+ (NSInteger)numberOfMonthForDate:(NSDate *)date
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [currentCalendar components:NSCalendarUnitMonth fromDate:date];
    
    return weekdayComponents.month;
}

+ (NSInteger)numberOfDayInYearForDate:(NSDate *)date
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSUInteger dayOfYear = [currentCalendar ordinalityOfUnit:NSCalendarUnitDay
                                                      inUnit:NSCalendarUnitYear
                                                     forDate:date];
    return dayOfYear;
}


@end
