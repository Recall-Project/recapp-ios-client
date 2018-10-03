//
//  FilledFormCache.h
//  RECAPP
//
//  Created by RECAPP Developer on 10/05/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilledFormCache : NSObject

@property (strong,nonatomic,readonly) NSThread *cacheThread;
@property (strong, nonatomic) NSTimer *cacheUpdateTimer;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

-(void)startCacheAutoUpdate;
-(void)initializeCacheAutoUpdate;

-(void) updateStudiesList;

+(FilledFormCache*)getInstance;

@end
