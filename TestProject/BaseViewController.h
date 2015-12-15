//
//  BaseViewController.h
//  TestProject
//
//  Created by Егор Сидоренко on 12/1/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"

@interface BaseViewController : UIViewController

-(instancetype)initWithModel:(TravelItem *)travelItemModel;

@property (nonatomic,retain) TravelItem * travelItemModel;

@end
