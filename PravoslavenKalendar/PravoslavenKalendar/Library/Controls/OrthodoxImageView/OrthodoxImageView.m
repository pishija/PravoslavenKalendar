//
//  OrthodoxImageView.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/16/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "OrthodoxImageView.h"

@interface OrthodoxImageView ()

@property (nonatomic, weak) UIImageView *placeholderImageView;

@end

@implementation OrthodoxImageView

#pragma mark - Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupView_private];
}

- (void)setupView_private
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:50]];
    
     [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0
                                                            constant:50]];
    [self addSubview:imageView];
    
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeCenterX
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:imageView
                                                        attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0 constant:0.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self
                                                        attribute:NSLayoutAttributeCenterY
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:imageView
                                                        attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0 constant:0.0]];

    [self addConstraints:constraints];
    
    self.placeholderImageView = imageView;
    
    if(!self.image)
    {
        self.placeholderImageView.hidden = NO;
    }
}

#pragma mark - Getters and Setters

- (void)setImage:(UIImage *)image
{
    if (!image)
    {
        self.placeholderImageView.hidden = NO;
    }
    else
    {
        self.placeholderImageView.hidden = YES;
    }
    super.image = image;
}

- (void)setPlaceholderImage:(UIImage *)image
{
    self.placeholderImageView.image = image;
}

@end
