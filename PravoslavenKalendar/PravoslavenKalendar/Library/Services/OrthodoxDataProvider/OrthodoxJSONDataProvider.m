//
//  OrthodoxJSONDataProvider.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/2/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "OrthodoxJSONDataProvider.h"

@interface OrthodoxJSONDataProvider ()

@property (nonatomic, copy) NSString *pathToJSON;
@property (nonatomic, copy) NSArray *orthodoxDays;

@end

@implementation OrthodoxJSONDataProvider

#pragma mark - Initialisers

- (instancetype)initWithPathToJSON:(NSString *)path
{
    self = [super init];
    if (self)
    {
        self.pathToJSON = path;
        
        NSData *data = [[NSData alloc] initWithContentsOfFile:_pathToJSON];
        
        NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableArray *orthodoxDaysMutable = [[NSMutableArray alloc] init];
        for (NSDictionary *status in result)
        {
            OrthodoxDay *day = [[OrthodoxDay alloc] initWithDictionary:status error:nil];
            [orthodoxDaysMutable addObject:day];
        }
        self.orthodoxDays = orthodoxDaysMutable;
    }
    return self;
}

- (instancetype)init
{
    NSLog(@"Please use designate initialiser: initWithPathToJSON:");
    return [self initWithPathToJSON:nil];
}

#pragma mark - OrthodoxDataProviderProtocol

- (OrthodoxDay *)orthodoxDayForDate:(NSDate *)date
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSUInteger dayOfYear = [currentCalendar ordinalityOfUnit:NSCalendarUnitDay
                                                      inUnit:NSCalendarUnitYear
                                                     forDate:date];
    return self.orthodoxDays[dayOfYear];
}

- (OrthodoxDay *)orthodoxDayForDayNumber:(NSUInteger)numberOfDay
{
    return self.orthodoxDays[numberOfDay - 1]; //zero array numeration
}

- (NSInteger)orthodoxDaysCount
{
    return self.orthodoxDays.count;
}

@end
