#import "NSDate+TimeAgo.h"
#import "DateTimeUtil.h"

@implementation NSDate (TimeAgo)

#ifndef NSDateTimeAgoLocalizedStrings
#define NSDateTimeAgoLocalizedStrings(key) \
    NSLocalizedStringFromTable(key, @"NSDateTimeAgo", nil)
#endif

-(NSString *)timeAgo {
    NSDate *now = [DateTimeUtil adjustUTCtoLocalTimeZone:[NSDate date]];
    
    ////////////////NSLog(@"Now:%@", now);
    ////////////////NSLog(@"Created:%@", self);
    
 
    double deltaSeconds = [now timeIntervalSinceDate:self]; //negative if now is earlier so this date is in the future
    double deltaMinutes = deltaSeconds / 60.0f;
    
    if(deltaSeconds < 0)
    {
    
        if(deltaSeconds > -5) {
            return NSDateTimeAgoLocalizedStrings(@"Any Time Now");
        } else if(deltaSeconds > -60) {
            return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"in %d seconds"), (int)fabs(deltaSeconds)];
        } else if(deltaSeconds > -120) {
            return NSDateTimeAgoLocalizedStrings(@"In 1 minute");
        } else if (deltaMinutes > -60) {
            return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"in %d minutes"), (int)fabs(deltaMinutes)];
        } else if (deltaMinutes > -120) {
            return NSDateTimeAgoLocalizedStrings(@"In an hour");
        } else if (deltaMinutes > (24 * 60 * -1)) {
            return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"in %d hours"), (int)floor(fabs(deltaMinutes)/60)];
        } else if (deltaMinutes > (24 * 60 * 2 * -1)) {
            return NSDateTimeAgoLocalizedStrings(@"Tomorrow");
        } else if (deltaMinutes > (24 * 60 * 7 * -1)) {
            return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"in %d days"), (int)floor(fabs(deltaMinutes)/(60 * 24))];
        } else if (deltaMinutes > (24 * 60 * 14 * -1)) {
            return NSDateTimeAgoLocalizedStrings(@"Next Week");
        } else if (deltaMinutes > (24 * 60 * 31 * -1)) {
            return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"in %d weeks"), (int)floor(fabs(deltaMinutes)/(60 * 24 * 7))];
        } else if (deltaMinutes > (24 * 60 * 61 * -1)) {
            return NSDateTimeAgoLocalizedStrings(@"Next Month");
        } else if (deltaMinutes > (24 * 60 * 365.25 * -1)) {
            return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"in %d months"), (int)floor(fabs(deltaMinutes)/(60 * 24 * 30))];
        } else if (deltaMinutes > (24 * 60 * 731 * -1)) {
            return NSDateTimeAgoLocalizedStrings(@"Next year");
        }
        
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"in %d years"), (int)floor(fabs(deltaMinutes)/(60 * 24 * 365 * -1))];
    }
    else
    {
        if(deltaSeconds < 5) {
            return NSDateTimeAgoLocalizedStrings(@"Just now");
        } else if(deltaSeconds < 60) {
            return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"%d seconds ago"), (int)deltaSeconds];
        } else if(deltaSeconds < 120) {
            return NSDateTimeAgoLocalizedStrings(@"A minute ago");
        } else if (deltaMinutes < 60) {
            return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"%d minutes ago"), (int)deltaMinutes];
        } else if (deltaMinutes < 120) {
            return NSDateTimeAgoLocalizedStrings(@"An hour ago");
        } else if (deltaMinutes < (24 * 60)) {
            return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"%d hours ago"), (int)floor(deltaMinutes/60)];
        }
        else if (deltaMinutes < (24 * 60 * 2))
        {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"HH:mm"];
            NSString *timestr = [NSString stringWithFormat:@"Yesterday at %@",[df stringFromDate:self]] ;
            
            return NSDateTimeAgoLocalizedStrings(timestr);
        }
        else if (deltaMinutes < (24 * 60 * 7)) {
            return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"%d days ago"), (int)floor(deltaMinutes/(60 * 24))];
        } else if (deltaMinutes < (24 * 60 * 14)) {
            return NSDateTimeAgoLocalizedStrings(@"Last week");
        } else if (deltaMinutes < (24 * 60 * 31)) {
            return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"%d weeks ago"), (int)floor(deltaMinutes/(60 * 24 * 7))];
        } else if (deltaMinutes < (24 * 60 * 61)) {
            return NSDateTimeAgoLocalizedStrings(@"Last month");
        } else if (deltaMinutes < (24 * 60 * 365.25)) {
            return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"%d months ago"), (int)floor(deltaMinutes/(60 * 24 * 30))];
        } else if (deltaMinutes < (24 * 60 * 731)) {
            return NSDateTimeAgoLocalizedStrings(@"Last year");
        }
        
        return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(@"%d years ago"), (int)floor(deltaMinutes/(60 * 24 * 365))];
        
    }

}

@end
