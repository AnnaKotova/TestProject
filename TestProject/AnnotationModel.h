//
//  AnnotationModel.h
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotationModel : NSObject<MKAnnotation>

-(instancetype) initWithTitle:(NSString*) title andCoordinates:(CLLocationCoordinate2D) coordinates;

@property (nonatomic) NSString* title;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) int Index;

//- (MKMapItem*)mapItem;

@end
