//
//  AnnotationModel.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "AnnotationModel.h"

@implementation AnnotationModel

- (NSInteger)number {
    return _number;
}

- (instancetype)initWithTitle:(NSString *) title Coordinates:(CLLocationCoordinate2D) coordinates  Number:(NSInteger) index
{
    self = [super init];
    if(self)
    {
        self.coordinate = coordinates;
        self.title = title;
        _number = index;
    }
    return self;
}

@end