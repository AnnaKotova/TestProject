//
//  BaseViewController.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/1/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - BaseController Life cycle

- (instancetype)initWithModel:(TravelItem *)travelItemModel
{
    self = [super init];
    if(self)
    {
        self.travelItemModel = travelItemModel;
    }
    return self;
}

@end
