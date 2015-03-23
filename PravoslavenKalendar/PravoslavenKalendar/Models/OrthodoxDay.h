//
//  OrthodoxDay.h
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/2/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "JSONModel.h"
#import "OrthodoxHoliday.h"

@interface OrthodoxDay : JSONModel

@property (nonatomic) int dayOfYear;
@property (nonatomic, copy) NSString<Optional> *nationalHoliday;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) NSArray<OrthodoxHoliday> *holidays;
@property (nonatomic, strong) NSArray *fastingFoods;

@end
