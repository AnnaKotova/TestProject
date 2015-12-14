//
//  MapController.m
//  TestProject
//
//  Created by Егор Сидоренко on 11/29/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "MapController.h"
#import "TravelInfoViewController.h"
#import "ChoosingSourceController.h"


@interface MapController()

@property (nonatomic) int mapTypeHeight;
@property (nonatomic, retain) UIPickerView* mapTypePicker;
@property (nonatomic, retain) NSArray* mapTypesStrings;
@property (nonatomic, retain) TravelItem* model;
@property (nonatomic, retain) NSArray* travelItemCollection;
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) CLLocationManager* location;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end

@implementation MapController

@synthesize mapTypeHeight = _mapTypeHeight;
@synthesize mapTypePicker = _mapTypePicker;
@synthesize mapTypesStrings = _mapTypesStrings;

-(MKMapView*) mapView {
    if(!_mapView){
        _mapView = [[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - self.mapTypeHeight)] autorelease];
        [_mapView setShowsUserLocation:YES];
        _mapView.delegate = self;
        [_mapView setZoomEnabled:YES];
        [_mapView setShowsScale:YES];
        [_mapView setScrollEnabled:YES];
    }
    return _mapView;
}
/*-(TravelModel*) model {
    if(!_model) _model = [[TravelModel alloc] init];
    return _model;
}*/

-(CLLocationManager*) location {
    if(!_location) {
        _location = [[[CLLocationManager alloc] init] autorelease];
        _location.delegate = self;
    }
    return _location;
}
-(NSArray*) travelItemCollection {
    if(!_travelItemCollection) _travelItemCollection = [DataSource.sharedDataSource getTravelItemCollection];
    return _travelItemCollection;
}
- (int) mapTypeHeight {
    return 70;
}

- (NSArray*) mapTypesStrings {
    return @[@"Standart",@"Satellite",@"Hybrid"];
}

-(void) viewDidUnload {
    [super viewDidUnload];
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
    TravelItem* item= [DataSource.sharedDataSource createNewTravelItem];
    [item setValuesForKeysWithDictionary:@{
                                          @"longitude":item.longitude,
                                          @"latitude":item.latitude }];
    ChoosingSourceController* chooseController = [[ChoosingSourceController alloc] initWithModel:item];
    [self.navigationController pushViewController: chooseController animated:YES];
    [chooseController release];
}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
    self.latitude =  userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
}

-(void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    //NSLog(@"Annotation Selected");
    int index = ((AnnotationModel*)view.annotation).Index;
    TravelInfoViewController* controller = [[TravelInfoViewController alloc] initWithModel:self.travelItemCollection];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void) addAnotations {
    int count = 0;
    
    for (TravelItem* mod in self.travelItemCollection) {
        CLLocationCoordinate2D  coord =  CLLocationCoordinate2DMake([mod.latitude doubleValue], [mod.longitude doubleValue]);
        AnnotationModel* annotation = [[AnnotationModel alloc] initWithTitle:mod.name andCoordinates:coord];
        annotation.Index = count;
        [self.mapView addAnnotation:annotation];
        [annotation release];
        count++;
    }
}
@end
