//
//  OrthodoxFastingTypeView.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/5/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "OrthodoxFastingView.h"

@interface OrthodoxFastingView ()

@property (weak, nonatomic) UIImageView *orthodoxFastingImageView;
@property (weak, nonatomic) UILabel *orthodoxFastingNameLabel;


@end

@implementation OrthodoxFastingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithType:(OrthodoxFastingViewType)type
{
    self = [super initWithFrame:CGRectZero];
    if (self)
    {
        [self createSubviews];
        self.type = type;
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithType:kOrthodoxFastingTypeNone];
}

#pragma mark - Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self createSubviews];
}

#pragma mark - Getters & Setters

- (void)setType:(OrthodoxFastingViewType)type
{
    _type = type;
    [self adjustViewToType];
}

#pragma mark - Private methods

- (void)adjustViewToType
{
    switch (_type)
    {
    case kOrthodoxFastingTypeNone:
        
        break;
        
    case kOrthodoxFastingTypeNoOil:
        
        self.orthodoxFastingImageView.image = [UIImage imageNamed:@"fasting_view_water"];
        self.orthodoxFastingNameLabel.text = @"Без масло";
        break;
        
    case kOrthodoxFastingTypeOil:
            
        self.orthodoxFastingImageView.image = [UIImage imageNamed:@"fasting_view_oil"];
        self.orthodoxFastingNameLabel.text = @"Mасло";
        break;
        
    case kOrthodoxFastingTypeNoFasting:
            self.orthodoxFastingImageView.image = [UIImage imageNamed:@"fasting_view_meat"];
            self.orthodoxFastingNameLabel.text = @"Без пост";
        
        break;
        
    case kOrthodoxFastingTypeFasting:
            
        self.orthodoxFastingImageView.image = [UIImage imageNamed:@"fasting_view_strict_fasting"];
        self.orthodoxFastingNameLabel.text = @"Строг пост";
        
        break;
        
    case kOrthodoxFastingTypeDiary:
            
        self.orthodoxFastingImageView.image = [UIImage imageNamed:@"fasting_view_diary"];
        self.orthodoxFastingNameLabel.text = @"Млечни";
        
        break;
        
    case kOrthodoxFastingTypeFish:
            
        self.orthodoxFastingImageView.image = [UIImage imageNamed:@"fasting_view_fish"];
        self.orthodoxFastingNameLabel.text = @"Риба";
        
        break;
        
    case kOrthodoxFastingTypeWine:
        self.orthodoxFastingImageView.image = [UIImage imageNamed:@"fasting_view_wine"];
        self.orthodoxFastingNameLabel.text = @"Вино";
        break;
        
    default:
        break;
    }
}

- (void)createSubviews
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:imageView
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.font = [UIFont systemFontOfSize:13.0];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[label]-(0)-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(imageView,label)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[imageView(==27)]-(-2)-[label(==17)]-(0)-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(imageView,label)]];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:imageView
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1
                                                                        constant:0];
    [constraints addObject:centerX];

    [self addConstraints:constraints];
    
    self.orthodoxFastingImageView = imageView;
    self.orthodoxFastingNameLabel = label;
}


@end
