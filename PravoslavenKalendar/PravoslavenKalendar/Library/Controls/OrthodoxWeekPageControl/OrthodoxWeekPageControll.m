//
//  OrthodoxWeekPageController.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/5/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "OrthodoxWeekPageControll.h"
#import "ColorsAndFonts.h"

@interface OrthodoxWeekPageControll ()

@property (nonatomic, strong) NSArray *pageIndicators;

@end

@implementation OrthodoxWeekPageControll

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self createSubviews];
    self.selectedItem = 0;
}

#pragma mark - Private methods
- (void)createSubviews
{
    NSMutableArray *pageIndicatorsMutable = [[NSMutableArray alloc] init];
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    self.userInteractionEnabled = YES;
    
    UILabel *previousPageIndicator = nil;
    for(int i = 0; i < 7; ++i)
    {
        UILabel *pageIndicator = [[UILabel alloc] init];
        pageIndicator.textColor = [ColorsAndFonts secondaryTextDark];
        pageIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        pageIndicator.userInteractionEnabled = YES;
        pageIndicator.font = [UIFont boldSystemFontOfSize:18.0];
        pageIndicator.tag = i;
        [self addSubview:pageIndicator];
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped:)];
        [pageIndicator addGestureRecognizer:singleFingerTap];
        
        [pageIndicatorsMutable addObject:pageIndicator];
        
        switch (i)
        {
            case 0:
                pageIndicator.text = @"П";
                break;
            
            case 1:
                pageIndicator.text = @"В";
                break;
                
            case 2:
                pageIndicator.text = @"С";
                break;
                
            case 3:
                pageIndicator.text = @"Ч";
                break;
                
            case 4:
                pageIndicator.text = @"П";
                break;
            
            case 5:
                pageIndicator.text = @"С";
                break;
                
            case 6:
                pageIndicator.text = @"Н";
                break;
            default:
                break;
        }
        
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:pageIndicator
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0
                                                             constant:0]];
        
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[pageIndicator]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:NSDictionaryOfVariableBindings(pageIndicator)]];
        
        if(previousPageIndicator == nil)
        {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[pageIndicator]"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:NSDictionaryOfVariableBindings(pageIndicator)]];
        }
        else
        {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousPageIndicator]-(15)-[pageIndicator]"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                       views:NSDictionaryOfVariableBindings(pageIndicator,previousPageIndicator)]];
        }
        
        if(i == 6)
        {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[pageIndicator]-(0)-|"
                                                                                     options:0
                                                                                     metrics:nil
                                                                                    views:NSDictionaryOfVariableBindings(pageIndicator)]];
        }
        previousPageIndicator = pageIndicator;
    }
    self.pageIndicators = pageIndicatorsMutable;
    [self addConstraints:constraints];
}

#pragma mark - Getters and Setteds

- (void)setSelectedItem:(NSUInteger)selectedItem
{
    [self.pageIndicators[_selectedItem] setTextColor:[ColorsAndFonts secondaryTextDark]];
    
    _selectedItem = selectedItem;
    
    [self.pageIndicators[_selectedItem] setTextColor:[UIColor blackColor]];
}

#pragma mark - Actions
- (void)labelTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    UILabel *label = (UILabel *)gestureRecognizer.view;
    [self setSelectedItem:label.tag];
    [self.delegate orthodoxPageControll:self didSelectIndex:_selectedItem];
}

@end
