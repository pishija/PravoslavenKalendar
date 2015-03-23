//
//  OrthodoxDayViewController.m
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/2/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import "OrthodoxDayViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageEffects.h"
#import "OrthodoxImageView.h"


@interface OrthodoxDayViewController ()

@property (weak, nonatomic) IBOutlet OrthodoxImageView *orthodoxImageView;

@end

@implementation OrthodoxDayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.orthodoxImageView setPlaceholderImage:[UIImage imageNamed:@"placeholder_downloading"]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Getters & Setters

- (void)setOrthodoxDay:(OrthodoxDay *)orthodoxDay
{
    _orthodoxDay = orthodoxDay;
    [self setImage];
}

- (void)setBlurred:(BOOL)blurred
{
    _blurred = blurred;
    [self setImage];
}


- (void)setImage
{
    if(_blurred)
    {
        UIImage *originalImage = self.orthodoxImageView.image;
        UIImage *blurredImage = [UIImageEffects imageByApplyingBlurToImage:originalImage withRadius:10.0 tintColor:nil saturationDeltaFactor:1.0 maskImage:nil];
        self.orthodoxImageView.image = blurredImage;
        
    }
    else
    {
        self.orthodoxImageView.contentMode = UIViewContentModeScaleAspectFit;
        __weak OrthodoxDayViewController *weakSelf = self;
        [self.orthodoxImageView sd_setImageWithURL:[NSURL URLWithString:self.orthodoxDay.imageUrl]
                                  placeholderImage:nil  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      self.orthodoxImageView.contentMode = UIViewContentModeScaleToFill;
//                                      if(error)
//                                      {
//                                          dispatch_async(dispatch_get_main_queue(), ^{
//                                              weakSelf.orthodoxImageView.image = [UIImage imageNamed:@"placeholder_error_download.jpg"];
//                                          });
//                                      }
                                      if(self.isBlurred)
                                      {
                                          [weakSelf setImage];
                                      }
                                  }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
