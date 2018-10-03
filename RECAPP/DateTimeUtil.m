//
//  DateTimeUtil.m
//  Flooder
//
//  Created by RECAPP Developer on 01/04/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import "DateTimeUtil.h"

@implementation DateTimeUtil


+(NSDate*)DateFromJSON2:(NSString*)jsonDT
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //[df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //2010-12-01T21:35:43+0000
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSZZZZ"];
    NSDate *date = [df dateFromString:jsonDT];    
    return date;
}

+(NSString*)JSON2StringFromNSDate:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    //2010-12-01T21:35:43+0000
    //2014-10-28T12:25:00.000+0000
    //////NSLog(@"%@", date);
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSZ"];
    return [df stringFromDate:date];
}


+(NSDate*)adjustUTCtoLocalTimeZone:(NSDate*)utcTime
{
    return [utcTime dateByAddingTimeInterval:[NSTimeZone localTimeZone].secondsFromGMT];
}


@end
