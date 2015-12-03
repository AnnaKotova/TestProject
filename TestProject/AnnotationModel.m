//
//  AnnotationModel.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "AnnotationModel.h"

@implementation AnnotationModel

-(instancetype) initWithTitle:(NSString*) title andCoordinates:(CLLocationCoordinate2D) coordinates {
    self = [super init];
    if(self) {
        self.coordinate = coordinates;
        self.title = title;
    }
    return self;
}
/*- (MKMapItem*)mapItem {
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinates
                              addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.customTitle;
    return mapItem;
}*/
@end