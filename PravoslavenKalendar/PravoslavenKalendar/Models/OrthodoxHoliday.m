//
//  OrthodoxHoliday.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/2/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "OrthodoxHoliday.h"

@implementation OrthodoxHoliday

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self != nil)
    {
        _name = [[coder decodeObjectForKey:@"name"] copy];
        _color = [[coder decodeObjectForKey:@"color"] copy];
        _descriptionUrl = [[coder decodeObjectForKey:@"descriptionUrl"] copy];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.color forKey:@"color"];
    [coder encodeObject:self.descriptionUrl forKey:@"descriptionUrl"];
}

@end
