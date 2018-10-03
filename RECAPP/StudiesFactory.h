//
//  StudiesFactory.h
//  RECAPP
//
//  Created by RECAPP Developer on 07/06/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudiesFactory : NSOperation

@property (strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *sharedpersistentStoreCoordinator;
@property (nonatomic, strong) NSData *studiesJSON;

-(id)initWithData:(NSData *)studies;

@end
