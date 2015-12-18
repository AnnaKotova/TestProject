//
//  ListViewController.h
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"


@interface ListViewController : UIViewController


typedef NS_ENUM(NSInteger, UserViewStyle) {
    ViewTile,
    ViewTable
};

@end
