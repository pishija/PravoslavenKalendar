//
//  OrthodoxWeekPageController.h
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/5/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrthodoxWeekPageControll;

@protocol OrthodoxWeekPageControllDelegate <NSObject>

@optional
- (void)orthodoxPageControll:(OrthodoxWeekPageControll *)pageControl didSelectIndex:(NSInteger)index;

@end

@interface OrthodoxWeekPageControll : UIView

@property (nonatomic) NSUInteger selectedItem;
@property (nonatomic, assign) id<OrthodoxWeekPageControllDelegate> delegate;

@end
