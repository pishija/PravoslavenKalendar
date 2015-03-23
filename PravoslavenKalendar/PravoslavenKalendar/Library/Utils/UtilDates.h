//
//  UtilDates.h
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/3/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilDates : NSObject

+ (NSDate *)dateFromNumberOfDay:(NSUInteger)numberOfDay;
+ (NSInteger)numberOfMonthForDate:(NSDate *)date;
+ (NSInteger)numberOfDayInYearForDate:(NSDate *)date;

@end
