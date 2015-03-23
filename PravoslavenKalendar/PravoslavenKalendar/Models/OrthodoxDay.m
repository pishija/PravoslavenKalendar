//
//  OrthodoxDay.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/2/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "OrthodoxDay.h"
#import "UtilOrthodoxStrings.h"

@implementation OrthodoxDay

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self != nil)
    {
        _dayOfYear = [(NSNumber *)[coder decodeObjectForKey:@"dayOfYear"] intValue];
        _nationalHoliday = [[coder decodeObjectForKey:@"nationalHoliday"] copy];
        _imageUrl = [[coder decodeObjectForKey:@"imageUrl"] copy];
        _holidays = [coder decodeObjectForKey:@"holidays"];
        _fastingFoods = [coder decodeObjectForKey:@"fastingFoods"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:[NSNumber numberWithInt:self.dayOfYear] forKey:@"dayOfYear"];
    [coder encodeObject:self.nationalHoliday forKey:@"nationalHoliday"];
    [coder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [coder encodeObject:self.holidays forKey:@"holidays"];
    [coder encodeObject:self.fastingFoods forKey:@"fastingFoods"];
}

- (NSString *)imageUrl
{
    return [NSString stringWithFormat:@"%@%d.jpg",kOrthodoxImagesBaseUrl,_dayOfYear];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Day: %d, Nacional holiday: %@, ImageUrl: %@ FastingFoods: %@",_dayOfYear,_nationalHoliday, _imageUrl,_fastingFoods];
}



@end
