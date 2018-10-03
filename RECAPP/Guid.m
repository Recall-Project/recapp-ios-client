//
//  Guid.m
//  OurTravel
//
//  Created by ecampus on 25/04/2010.
//  Copyright 2010 lancaster university. All rights reserved.
//

#import "Guid.h"

@implementation Guid

static Guid *guid = nil;

+ (Guid *) getInstance {
	
	@synchronized(self)
	{
		if(guid == nil){
		
			guid = [[Guid alloc] init];
		}
		
		return guid;
	}
}


- (NSString *) newGuid {

	CFUUIDRef uuidref = CFUUIDCreate(nil);
	NSString *guidStr = (__bridge_transfer NSString*) CFUUIDCreateString(nil, uuidref);
	//CFRelease(uuidref);
	
	//////////////////NSLog@"%@",guidStr);
	return guidStr;
}

@end
