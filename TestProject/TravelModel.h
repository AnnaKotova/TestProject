//
//  TravelModel.h
//  TestProject
//
//  Created by Егор Сидоренко on 12/1/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface TravelModel : NSObject

@property (strong,nonatomic) NSString* imageUrl;
@property (strong, nonatomic) NSString* soundUrl;
@property (strong,nonatomic) NSString* name;

@property (nonatomic) double longitude;
@property (nonatomic) double latitude;

@end
