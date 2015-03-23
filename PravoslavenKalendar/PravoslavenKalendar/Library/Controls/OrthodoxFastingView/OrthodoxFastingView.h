//
//  OrthodoxFastingTypeView.h
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/5/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kOrthodoxFastingTypeNone = 1,
    kOrthodoxFastingTypeNoOil,
    kOrthodoxFastingTypeOil,
    kOrthodoxFastingTypeNoFasting,
    kOrthodoxFastingTypeFasting,
    kOrthodoxFastingTypeDiary,
    kOrthodoxFastingTypeFish,
    kOrthodoxFastingTypeWine,
    
}OrthodoxFastingViewType;

@interface OrthodoxFastingView : UIView

// Designated Initialiser 
- (instancetype)initWithType:(OrthodoxFastingViewType)type;

@property (nonatomic) OrthodoxFastingViewType type;

@end
