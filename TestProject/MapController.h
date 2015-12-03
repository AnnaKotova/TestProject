//
//  MapController.h
//  TestProject
//
//  Created by Егор Сидоренко on 11/29/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TravelCollection.h"
#import "AnnotationModel.h"
//#import <MapKit/MKAnnotation.h>

@interface MapController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>



@end
