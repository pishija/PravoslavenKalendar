//
//  OrthodoxJSONDataProvider.h
//  PravoslavenKalendar
//
//  Created by Mihail Stevcev on 3/2/15.
//  Copyright (c) 2015 Mihail Stevchev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrthodoxDataProviderProtocol.h"

@interface OrthodoxJSONDataProvider : NSObject <OrthodoxDataProviderProtocol>

- (instancetype)initWithPathToJSON:(NSString *)path;

@end
