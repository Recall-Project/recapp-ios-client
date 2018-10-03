//
//  Guid.h
//  OurTravel
//
//  Created by ecampus on 25/04/2010.
//  Copyright 2010 lancaster university. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Guid : NSObject {
	
}


+ (Guid *) getInstance;
- (NSString *) newGuid;

@end
