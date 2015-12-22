//
//  Utils.m
//  TestProject
//
//  Created by User on 12/22/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "Utils.h"
@interface Utils()
{
    NSDateFormatter * _dateFormatter;
    //NSDate * _date;
}

@end

@implementation Utils

+ (instancetype)sharedUtils
{
    static Utils * singleTone = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        singleTone = [[self alloc] init];
    });
    return singleTone;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
    }
    return self;
}

-(NSString *)getCurrentTime
{
    return [_dateFormatter stringFromDate:[NSDate date]];
}

-(NSString *)generateGUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(__bridge NSString *)string autorelease];
}

@end
