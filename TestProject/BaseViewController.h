//
//  BaseViewController.h
//  TestProject
//
//  Created by Егор Сидоренко on 12/1/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TravelModel.h"

@interface BaseViewController : UIViewController

-(instancetype)initWithModel:(TravelModel *)model;
@property (nonatomic) TravelModel* model;

@end
