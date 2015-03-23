//
//  OrthodoxFavoritesManagerUserDefaults.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/17/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "OrthodoxFavoritesManagerUserDefaults.h"
#import "UtilDates.h"
#define kFavoritesKey @"FavoritesUserDefaultsKey"

@interface OrthodoxFavoritesManagerUserDefaults ()

//@property (nonatomic, strong) NSMutableArray *favorites;

@property (nonatomic, strong) NSMutableDictionary *favoritesDic;

@end

@implementation OrthodoxFavoritesManagerUserDefaults

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

#pragma mark - Orthodox Favorites Manager Protocol
- (void)saveDayToFavorites:(OrthodoxDay *)orthodoxDay error:(NSError *)error
{
    [self.favoritesDic setObject:orthodoxDay forKey:[NSString stringWithFormat:@"%d",orthodoxDay.dayOfYear]];
    [self saveFavorites];
}

- (void)removeDayFromFavorites:(OrthodoxDay *)orthodoxDay error:(NSError *)error
{
    [self.favoritesDic removeObjectForKey:[NSString stringWithFormat:@"%d",orthodoxDay.dayOfYear]];
    [self saveFavorites];
}

#pragma mark - Overrides

- (NSMutableDictionary *)favoritesDic
{
    if(!_favoritesDic)
    {
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];

        NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:kFavoritesKey];
        if (dataRepresentingSavedArray != nil)
        {
            NSDictionary *oldSavedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
            if (oldSavedDictionary != nil)
            {
                _favoritesDic = [[NSMutableDictionary alloc] initWithDictionary:oldSavedDictionary];
            }
            else
            {
                _favoritesDic = [[NSMutableDictionary alloc] init];
            }
        }
        else
        {
             _favoritesDic = [[NSMutableDictionary alloc] init];
        }

    }
    return _favoritesDic;
}

- (BOOL)doFavoriteForDateExits:(NSDate *)date
{
    int numberOfDay = (int)[UtilDates numberOfDayInYearForDate:date];
    if([self.favoritesDic objectForKey:[NSString stringWithFormat:@"%d",numberOfDay]])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)saveFavorites
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.favoritesDic] forKey:kFavoritesKey];
}

@end
