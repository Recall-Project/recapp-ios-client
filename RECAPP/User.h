//
//  User.h
//  RECAPP
//
//  Created by RECAPP Developer on 07/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"


@interface User : ExtendedManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * passphrase;

@end


