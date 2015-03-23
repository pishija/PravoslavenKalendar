//
//  OrthodoxFavoritesManagerProtocol.h
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/17/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrthodoxDay.h"

@protocol OrthodoxFavoritesManagerProtocol <NSObject>

@required
- (void)saveDayToFavorites:(OrthodoxDay *)orthodoxDay error:(NSError *)error;
- (void)removeDayFromFavorites:(OrthodoxDay *)orthodoxDay error:(NSError *)error;
- (BOOL)doFavoriteForDateExits:(NSDate *)date;

@end
