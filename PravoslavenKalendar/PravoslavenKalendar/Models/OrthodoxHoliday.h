//
//  OrthodoxHoliday.h
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/2/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "JSONModel.h"

@protocol OrthodoxHoliday

@end


@interface OrthodoxHoliday : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString<Optional> *descriptionUrl;

@end
