//
//  User.m
//  YouthFilmic
//
//  Created by 高刘备 on 16/4/16.
//  Copyright © 2016年 寰影(北京)文化传媒有限公司. All rights reserved.
//

#import "User.h"

@implementation User

HXSingleton_implementation(User)

- (NSString *)UserToken
{
   return [HXTools getStringFromUserDefaultsForKey:@"token"];
}

- (void)setSanBoxToken:(NSString *)token
{
    [HXTools setStringToUserDefaults:token forKey:@"token"];
    
}
- (BOOL)tokenIsoutDate
{
    if (![HXTools getStringFromUserDefaultsForKey:@"outdate"])
    {
        return YES;
    }
    NSString *sanboxDate = [HXTools getStringFromUserDefaultsForKey:@"outdate"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    
    NSString *nowDate = [dateFormatter stringFromDate:date];
    NSString *str = [self intervalFromLastDate:sanboxDate toTheDate:nowDate];
    NSString *firstStr = [[str componentsSeparatedByString:@":"]firstObject];
    NSString *secondStr = [[str componentsSeparatedByString:@":"] objectAtIndex:1];
    if ([firstStr integerValue] > 0 && [firstStr integerValue] < 2 && [secondStr integerValue] > 58)
    {
        
        return YES;
    }
    if ([firstStr integerValue]>2)
    {
        return YES;
    }

    
    

    return NO;
}

- (NSString *)intervalFromLastDate: (NSString *) dateString1  toTheDate:(NSString *) dateString2
{
    NSArray *timeArray1=[dateString1 componentsSeparatedByString:@"."];
    dateString1=[timeArray1 objectAtIndex:0];
    
    
    NSArray *timeArray2=[dateString2 componentsSeparatedByString:@"."];
    dateString2=[timeArray2 objectAtIndex:0];
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate *d1=[date dateFromString:dateString1];
    
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    
    
    NSDate *d2=[date dateFromString:dateString2];
    
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    
    
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *house=@"";
    NSString *min=@"";
    NSString *sen=@"";
    
    sen = [NSString stringWithFormat:@"%d", (int)cha%60];
    //        min = [min substringToIndex:min.length-7];
    //    秒
    sen=[NSString stringWithFormat:@"%@", sen];
    
    
    
    min = [NSString stringWithFormat:@"%d", (int)cha/60%60];
    //        min = [min substringToIndex:min.length-7];
    //    分
    min=[NSString stringWithFormat:@"%@", min];
    
    
    //    小时
    house = [NSString stringWithFormat:@"%d", (int)cha/3600];
    //        house = [house substringToIndex:house.length-7];
    house=[NSString stringWithFormat:@"%@", house];
    
    
    timeString=[NSString stringWithFormat:@"%@:%@:%@",house,min,sen];
    
    
    
    return timeString;
}



@end
