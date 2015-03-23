//
//  ColorsAndFonts.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/18/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "ColorsAndFonts.h"

@implementation ColorsAndFonts

+ (UIColor *)whiteTransparent
{
    return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.85];
}

+ (UIColor *)greenDark
{
    return [UIColor colorWithRed:102.0/255.0 green:153.0/255.0 blue:0.0 alpha:1.0];
}

+ (UIColor *)primary
{
    return [UIColor colorWithRed:252.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1.0];
}

+ (UIColor *)primaryDark
{
    return [UIColor colorWithRed:176.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0];
}

+ (UIColor *)accent
{
    return [UIColor colorWithRed:253.0/255.0 green:170.0/255.0 blue:7.0/255.0 alpha:1.0];
}

+ (UIColor *)secondaryTextDark //do not like to put android names of colors :)
{
    return [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];
}

+ (UIColor *)tertiaryTextDark //do not like to put android names of colors :)
{
    return [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
}


@end
