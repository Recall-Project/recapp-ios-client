//
//  ImageExperienceCapture.m
//  RECAPP
//
//  Created by RECAPP Developer on 15/05/2014.
//  Copyright (c) 2014 Lancaster University. All rights reserved.
//

#import "ImageExperienceCapture.h"


@implementation ImageExperienceCapture

@dynamic image;
@dynamic label;
@dynamic image_url;

-(void) removeCapturedData
{
    //[NSException raise:@"Method Not Implemented" format:@"ImageExperienceCapture:removeCaptureData"];
}

-(BOOL) isEmpty
{
    return false;
}

- (NSDictionary*) toDictionary
{
    NSArray* attributes = [[[self entity] attributesByName] allKeys];
    NSArray* relationships = [[[self entity] relationshipsByName] allKeys];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:
                                 [attributes count] + [relationships count] + 1];
    
    [dict setObject:[[self class] description] forKey:@"type"];
    
    for (NSString* attr in attributes)
    {
        NSObject* value = [self valueForKey:attr];
        
        if (value != nil)
        {
            //remove supporting properties i.e. image
            if(![value isKindOfClass:[NSData class]])
            {
               [dict setObject:value forKey:attr];
            }
        }
    }
    
    for (NSString* relationship in relationships) {
        NSObject* value = [self valueForKey:relationship];
        
        if ([value isKindOfClass:[NSSet class]]) {
            // To-many relationship
        }
        else if ([value isKindOfClass:[ExtendedManagedObject class]]) {
            // To-one relationship
        }
    }
    
    NSMutableDictionary *collectionModfied = [dict mutableCopy];
    for (id key in dict)
    {
        NSObject* value = [dict objectForKey:key];
        if([value isKindOfClass:[NSSet class]])
        {
            NSSet *objSet = (NSSet*) value;
            NSArray *objArray = [objSet allObjects];
            [collectionModfied setObject:objArray forKey:key];
        }
    }
    
    return collectionModfied;
}

@end
