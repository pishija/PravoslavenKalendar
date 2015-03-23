//
//  MainViewController.h
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/2/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrthodoxDataProviderProtocol.h"
#import "OrthodoxFavoritesManagerProtocol.h"

@interface MainViewController : UIViewController

- (instancetype)initWithOrthodoxDataProvider:(id<OrthodoxDataProviderProtocol>)orthodoxDataProvider;

@property (nonatomic, strong) id<OrthodoxFavoritesManagerProtocol> favoritesManager;

@end
