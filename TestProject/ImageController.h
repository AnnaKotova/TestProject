//
//  ImageController.h
//  TestProject
//
//  Created by Егор Сидоренко on 11/30/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ImageController : BaseViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
    //@property (nonatomic,strong) UIIma
- (instancetype)initWithSetting:(BOOL) isCamera Model:(TravelItem*) model;
@end
