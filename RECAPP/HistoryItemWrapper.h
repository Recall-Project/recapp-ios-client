//
//  HistoryItemWrapper.h
//  RECAPP
//
//  Created by RECAPP Developer on 18/07/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExtendedManagedObject.h"

@interface HistoryItemWrapper : NSObject

@property(nonatomic, strong) NSDate *timestamp;
@property(nonatomic, strong) ExtendedManagedObject *item;

@end
