//
//  LikertOption.h
//  RECAPP
//
//  Created by RECAPP Developer on 07/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ExtendedManagedObject.h"

@interface LikertOption : ExtendedManagedObject

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSManagedObject *question;

@end
