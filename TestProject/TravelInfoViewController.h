//
//  TravelInfoViewController.h
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "TravelCollection.h"

@interface TravelInfoViewController : UIViewController
- (instancetype)initWithModel:(TravelCollection*) model andCurrentIndex:(int) index;

@end
