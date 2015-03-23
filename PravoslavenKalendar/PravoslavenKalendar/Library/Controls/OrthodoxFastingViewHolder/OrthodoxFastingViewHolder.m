//
//  OrthodoxFastingViewHolder.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/5/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "OrthodoxFastingViewHolder.h"

@interface OrthodoxFastingViewHolder ()

@property (nonatomic, strong) NSArray *fastingViews;
@property (nonatomic, weak) UIView *leadingSpacerView;
@property (nonatomic, weak) UIView *trailingSpacerView;

@property (nonatomic, weak) UIView *centeredContainer;

@end

@implementation OrthodoxFastingViewHolder

#pragma mark - Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self createSubviews];
}

#pragma mark - Getters & Setters

- (void)setFastingElements:(NSArray *)fastingElements
{
    _fastingElements = fastingElements;
    [self adjustView];
}

#pragma mark - Private Methods
- (void)createSubviews
{
    UIView *container = [[UIView alloc] init];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:container];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:container
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[container]-(0)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(container)]];
    self.centeredContainer = container;
}

- (void)adjustView
{
    //will remove old constraints
    for(UIView *view in self.fastingViews)
    {
        [view removeFromSuperview];
    }

    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    NSMutableArray *fastingViewsMutable = [[NSMutableArray alloc] init];

    UIView *previousView;
    for( int i = 0; i < self.fastingElements.count; i++)
    {
        NSNumber *fastingElement = self.fastingElements[i];
        OrthodoxFastingView *fastingView = [[OrthodoxFastingView alloc] initWithType:(OrthodoxFastingViewType)[fastingElement integerValue]];
        [self.centeredContainer addSubview:fastingView];
        
        [fastingViewsMutable addObject:fastingView];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[fastingView]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(fastingView)]];
        
        if(previousView == nil) //first element
        {
            
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[fastingView]"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(fastingView)]];
        }
        else
        {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousView]-(15)-[fastingView]"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(fastingView,previousView)]];
        }
        
        if(i == self.fastingElements.count - 1) //last element
        {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[fastingView]-(0)-|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(fastingView)]];
        }
        
        previousView = fastingView;
    }
    
    [self.centeredContainer addConstraints:constraints];
    
    self.fastingViews = fastingViewsMutable;
}

@end
