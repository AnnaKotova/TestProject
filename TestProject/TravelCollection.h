//
//  TravelCollection.h
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "TravelModel.h"
#import "TravelInfo.h"
#import "DbController.h"

@interface TravelCollection : NSObject

@property (strong, readonly,nonatomic) NSMutableArray* travelPoints;

@end
