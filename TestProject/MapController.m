//
//  MapController.m
//  TestProject
//
//  Created by Егор Сидоренко on 11/29/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "MapController.h"
#import "ChoosingSourceController.h"
#import "TravelModel.h"
#import "TravelInfoViewController.h"

@interface MapController()

@property (nonatomic) int mapTypeHeight;
@property (nonatomic) UIPickerView* mapTypePicker;
@property (nonatomic) NSArray* mapTypesStrings;
@property (nonatomic) TravelModel* model;
@property (nonatomic) TravelCollection* collection;
@property (nonatomic) MKMapView* mapView;
@property (nonatomic) CLLocationManager* location;

@end

@implementation MapController

@synthesize mapTypeHeight = _mapTypeHeight;
@synthesize mapTypePicker = _mapTypePicker;
@synthesize mapTypesStrings = _mapTypesStrings;

-(MKMapView*) mapView {
    if(!_mapView){
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.mapTypeHeight)];
        [_mapView setShowsUserLocation:YES];
        _mapView.delegate = self;
        [_mapView setZoomEnabled:YES];
        [_mapView setShowsScale:YES];
        [_mapView setScrollEnabled:YES];
    }
    return _mapView;
}
-(TravelModel*) model {
    if(!_model) _model = [[TravelModel alloc] init];
    return _model;
}

-(CLLocationManager*) location {
    if(!_location) {
        _location = [[CLLocationManager alloc] init];
        _location.delegate = self;
    }
    return _location;
}
-(TravelCollection*) collection {
    if(!_collection) _collection = [[TravelCollection alloc] init];
    return _collection;
}
- (int) mapTypeHeight {
    return 70;
}

- (NSArray*) mapTypesStrings {
    return @[@"Standart",@"Satellite",@"Hybrid"];
}

-(void) viewDidUnload {
    [super viewDidUnload];
    self.mapTypePicker = nil;
    [self.collection release];
    [self.model release];
    [self.location release];
    [self.mapView release];
}

-(UIPickerView*) mapTypePicker
{
    if(!_mapTypePicker)
    {
        _mapTypePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - self.mapTypeHeight, self.view.bounds.size.width, self.mapTypeHeight)];
        [_mapTypePicker setBackgroundColor:[UIColor whiteColor]];
        _mapTypePicker.delegate = self;
        [_mapTypePicker setShowsSelectionIndicator:YES];
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
    [self.location requestWhenInUseAuthorization];
    [self.location startUpdatingLocation];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.mapTypePicker];
    UIBarButtonItem*barbutton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(goToNextView:)];
    self.navigationItem.rightBarButtonItem =  barbutton;
    [barbutton release];
    [self addAnotations];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
-(void) goToNextView:(UIBarButtonItem*) sender{
    ChoosingSourceController* chooseController = [[ChoosingSourceController alloc] initWithModel:self.model];
    [self.navigationController pushViewController: chooseController animated:YES];
    [chooseController release];
}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
    self.model.latitude =  userLocation.location.coordinate.latitude;
    self.model.longitude = userLocation.location.coordinate.longitude;
}

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    //NSLog(@"Annotation Selected");
    int index = ((AnnotationModel*)view.annotation).Index;
    TravelInfoViewController* controller = [[TravelInfoViewController alloc] initWithModel:(TravelModel*)self.collection.travelPoints[index]];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void) addAnotations {
    int count = 0;
    for (TravelModel* mod in self.collection.travelPoints) {
        CLLocationCoordinate2D  coord =  CLLocationCoordinate2DMake(mod.latitude, mod.longitude);
        AnnotationModel* annotation = [[AnnotationModel alloc] initWithTitle:mod.name andCoordinates:coord];
        annotation.Index = count;
        [self.mapView addAnnotation:annotation];
        [annotation release];
        count++;
    }
}
@end
