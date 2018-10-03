//
//  DateTimeUtil.h
//  Flooder
//
//  Created by RECAPP Developer on 01/04/2013.
//  Copyright (c) 2013 Lancaster University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeUtil : NSObject


+(NSDate*)DateFromJSON2:(NSString*)jsonDT;
+(NSString*)JSON2StringFromNSDate:(NSDate*)date;
+(NSDate*)adjustUTCtoLocalTimeZone:(NSDate*)utcTime;



@end
