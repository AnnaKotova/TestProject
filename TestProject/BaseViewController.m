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
-(instancetype)initWithModel:(TravelItem *)model {
    self = [super init];
    if(self){
        self.model = model;
    }
     //NSLog(@"%f %f %@ %@ %@",self.model.latitude,self.model.longitude, self.model.name, self.model.soundUrl);
    return self;
}
@end
