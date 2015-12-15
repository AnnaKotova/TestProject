//
//  MapController.m
//  TestProject
//
//  Created by Егор Сидоренко on 11/29/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "MapViewController.h"
#import "TravelInfoViewController.h"
#import "ImageViewController.h"


@interface MapViewController()

@property (nonatomic) int _mapHeight;
@property (nonatomic, retain) UIPickerView * mapTypePicker;
@property (nonatomic, retain) NSArray * mapTypesStrings;
@property (nonatomic, retain) NSArray * travelItemCollection;
@property (nonatomic, retain) MKMapView * mapView;
@property (nonatomic, retain) CLLocationManager * locationManager;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;


@end

@implementation MapViewController

@synthesize _mapHeight = __mapHeight;
@synthesize mapTypePicker = _mapTypePicker;
@synthesize mapTypesStrings = _mapTypesStrings;

#pragma  UIControl Prperties

-(MKMapView*) mapView {
    if(!_mapView){
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self._mapHeight)];
        [_mapView setShowsUserLocation: YES];
        _mapView.delegate = self;
        [_mapView setZoomEnabled: YES];
        [_mapView setShowsScale: YES];
        [_mapView setScrollEnabled: YES];
    }
    return _mapView;
}

-(CLLocationManager*) locationManager {
    if(!_locationManager) {
        _locationManager = [[[CLLocationManager alloc] init] autorelease];
        _locationManager.delegate = self;
    }
    return _locationManager;
}


-(NSArray*) travelItemCollection {
    if(!_travelItemCollection) _travelItemCollection = [DataSource.sharedDataSource getTravelItemCollection];
    return _travelItemCollection;
}
- (int) _mapHeight {
    return 70;
}

- (NSArray*) mapTypesStrings {
    return @[@"Standart", @"Satellite", @"Hybrid"];
}

-(void) viewDidUnload {
    [super viewDidUnload];
}

-(UIPickerView*) mapTypePicker
{
    if(!_mapTypePicker)
    {
        _mapTypePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - self._mapHeight, self.view.bounds.size.width, self._mapHeight)];
        [_mapTypePicker setBackgroundColor: [UIColor whiteColor]];
        _mapTypePicker.delegate = self;
        [_mapTypePicker setShowsSelectionIndicator: YES];
    }
    return _mapTypePicker;
}

-(int) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString* ) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    [self.mapView setMapType:(MKMapType)row];
    return self.mapTypesStrings[row];
}

-(int) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.mapTypesStrings.count;
}

-(void) viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.mapTypePicker];
    UIBarButtonItem*barbutton = [[UIBarButtonItem alloc] initWithTitle: @"Next" style:UIBarButtonItemStyleDone target: self action: @selector(goToNextView:)];
    self.navigationItem.rightBarButtonItem =  barbutton;
    [barbutton release];
    [self addAnotationsFromTravelCollectionToMap];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

-(void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden: NO];

}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id ) annotation {
    
    if(annotation == mapView.userLocation) {
        return nil;
    }
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"currentloc"];
    annView.animatesDrop = TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    return annView;
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

-(void) goToNextView:(UIBarButtonItem*) sender{
    TravelItem * item= [DataSource.sharedDataSource createNewTravelItem];
    [item setValuesForKeysWithDictionary:@{
                                           @"longitude":[NSNumber numberWithDouble: self.longitude],
                                           @"latitude":  [NSNumber numberWithDouble: self.latitude] }];
    
    ImageViewController * chooseController = [[[ImageViewController alloc] initWithModel: item] autorelease];
    [self.navigationController pushViewController: chooseController animated: YES];
    
}


-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated: YES];
    self.latitude =  userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
}

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    AnnotationModel * annotationModelItem = ((AnnotationModel *)view.annotation);
    TravelInfoViewController * tviController = [[[TravelInfoViewController alloc] initWithCurrentIndex: annotationModelItem.number] autorelease];
    [self.navigationController pushViewController: tviController animated: YES];
}


-(void) addAnotationsFromTravelCollectionToMap
{
    int count = 0;
    for (TravelItem * travelItemObject in self.travelItemCollection) {
        //CLLocationCoordinate2D  coord =  CLLocationCoordinate2DMake([travelItemObject.longitude doubleValue], [travelItemObject.latitude doubleValue]);
        CLLocationCoordinate2D  coord =  CLLocationCoordinate2DMake(47.8524931, 35.1270998);
        AnnotationModel * annotationModel = [[AnnotationModel alloc] initWithTitle: travelItemObject.name Coordinates: coord Number: count];
        [self.mapView addAnnotation: annotationModel];
        [annotationModel release];
        count++;
    }
}

-(void) dealloc {
    [self.locationManager release];
    [self.mapView release];
    [super dealloc];
}
@end
