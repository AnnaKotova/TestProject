//
//  Utils.h
//  TestProject
//
//  Created by User on 12/22/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (instancetype)sharedUtils;

- (NSString *)getCurrentTime;

- (NSString *)generateGUID;

@end
