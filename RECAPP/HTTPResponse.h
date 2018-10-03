//
//  HTTPResponse.h
//  RECAPP
//
//  Created by RECAPP Developer on 14/05/2014.
//  Copyright (c) 2014 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPResponse : NSObject

@property(nonatomic, strong) NSString *code;
@property(nonatomic, strong) NSString *payload;

@end
