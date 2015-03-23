//
//  OrthodoxDayViewController.h
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/2/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrthodoxDay.h"

@interface OrthodoxDayViewController : UIViewController

@property (nonatomic) int pageIndex;

@property (nonatomic, strong) OrthodoxDay *orthodoxDay;
@property (nonatomic, getter=isBlurred) BOOL blurred;

@end
