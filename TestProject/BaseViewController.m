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
-(instancetype)initWithModel:(TravelModel *)model {
    self = [super init];
    if(self){
        self.model = model;
    }
    NSLog(@"%f %f",self.model.latitude,self.model.longitude);
    return self;
}
@end
