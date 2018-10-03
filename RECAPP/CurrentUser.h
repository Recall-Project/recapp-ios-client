//
//  CurrentUser.h
//  Flooder
//
//  Created by RECAPP Developer on 09/04/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface CurrentUser : NSObject

+(CurrentUser*)getInstance;

-(User*)getUser;

@end
