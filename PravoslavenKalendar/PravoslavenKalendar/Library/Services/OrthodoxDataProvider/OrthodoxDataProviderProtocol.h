//
//  OrthodoxDataProviderProtocol.h
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/2/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrthodoxDay.h"

@protocol OrthodoxDataProviderProtocol <NSObject>

@required
- (OrthodoxDay *)orthodoxDayForDate:(NSDate *)date;
- (OrthodoxDay *)orthodoxDayForDayNumber:(NSUInteger)numberOfDay;
- (NSInteger)orthodoxDaysCount;

@end
