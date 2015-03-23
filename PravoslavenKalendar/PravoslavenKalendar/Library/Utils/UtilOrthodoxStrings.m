//
//  UtilOrthodoxStrings.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/10/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "UtilOrthodoxStrings.h"

@implementation UtilOrthodoxStrings

+ (NSString *)getOldMonthName:(NSUInteger)monthOfYear
{
    switch (monthOfYear)
    {
        case 1:
            return @"Kоложег";
            break;
            
        case 2:
            return @"Сечко";
            break;
        case 3:
            
            return @"Цутар";
            break;
        case 4:
            
            return @"Тревен";
            break;
        case 5:
            
            return @"Косар";
            break;
        case 6:
            
            return @"Жетвар";
            break;
        case 7:
            
            return @"Златец";
            break;
        case 8:
            
            return @"Житар";
            break;
        case 9:
            
            return @"Гроздобер";
            break;
        case 10:
            
            return @"Листопад";
            break;
            
        case 11:
            
            return @"Студен";
            break;
        case 12:
            
            return @"Снежник";
            break;
            
        default:
            NSLog(@"Wrong month of year value. Valid values 1-12");
            return nil;
            break;
    }
    return nil;
}

@end
