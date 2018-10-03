//
//  UploadFeedItems.h
//  Flooder
//
//  Created by RECAPP Developer on 04/04/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilledFormUploader : NSOperation

@property (strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *sharedpersistentStoreCoordinator;

@end
