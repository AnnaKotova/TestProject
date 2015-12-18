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
#import "DataSource.h"


@interface TravelInfoViewController : UIViewController

- (instancetype)initWithCurrentIndex:(NSInteger) index;

typedef NS_ENUM (NSInteger, ScrollDirection){
    ScrollDirectionRight,
    ScrollDirectionLeft
} ;

@end
