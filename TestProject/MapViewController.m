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
@property (nonatomic, retain) NSArray * travelItemCollection;
@property (nonatomic, retain) MKMapView * mapView;
@property (nonatomic, retain) CLLocationManager * locationManager;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) UIButton* mapTypeButton;


@end

@implementation MapViewController

@synthesize _mapHeight = __mapHeight;

#pragma  UIControl Prperties

-(MKMapView*) mapView
{
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


-(CLLocationManager*) locationManager
{
    if(!_locationManager) {
        _locationManager = [[[CLLocationManager alloc] init] autorelease];
        _locationManager.delegate = self;
    }
    return _locationManager;
}


-(NSArray*) travelItemCollection
{
    if(!_travelItemCollection) _travelItemCollection = [DataSource.sharedDataSource getTravelItemCollection];
    return _travelItemCollection;
}
- (int) _mapHeight {
    return 70;
}

-(void) viewDidUnload
{
    [super viewDidUnload];
}
-(UIButton*) mapTypeButton
{
    if(!_mapTypeButton)
    {
        _mapTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - self._mapHeight, self.view.bounds.size.width, self._mapHeight)];
        [_mapTypeButton addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventAllTouchEvents];
        [_mapTypeButton setTitle:@"Map Type: Standart" forState:UIControlStateNormal];
        [_mapTypeButton setBackgroundColor:[UIColor grayColor]];
    }
    return _mapTypeButton;
}
-(void) chooseType:(UIButton*) sender {
    UIAlertController* chooseMapTypeAlert = [UIAlertController alertControllerWithTitle:@"choose map type" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* setStandartmaptypeAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"Standart",nil) style:UIAlertControllerStyleActionSheet handler:^(UIAlertAction * _Nonnull action)
                                               {
                                                   [self.mapView setMapType:MKMapTypeStandard];
                                                   [_mapTypeButton setTitle:@"Map Type: Standart" forState:UIControlStateNormal];
                                               }];
    UIAlertAction* setHybridMapTypeAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"Hybrid",nil) style:UIAlertControllerStyleActionSheet handler:^(UIAlertAction * _Nonnull action)
                                               {
                                                   [self.mapView setMapType:MKMapTypeHybrid];
                                                   [_mapTypeButton setTitle:@"Map Type: Hybrid" forState:UIControlStateNormal];
                                               }];
    UIAlertAction* setSatelliteMapTypeAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"Satellite",nil) style:UIAlertControllerStyleActionSheet handler:^(UIAlertAction * _Nonnull action)
                                               {
                                                   [self.mapView setMapType:MKMapTypeSatellite];
                                                   [_mapTypeButton setTitle:@"Map Type: Satellite" forState:UIControlStateNormal];
                                               }];
    UIAlertAction* setCancel = [UIAlertAction actionWithTitle: NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                                {
                                                    [self.mapView setMapType:MKMapTypeSatellite];
                                                    [_mapTypeButton setTitle:@"Map Type: Satellite" forState:UIControlStateNormal];
                                                }];
    [chooseMapTypeAlert addAction:setStandartmaptypeAction];
    [chooseMapTypeAlert addAction:setHybridMapTypeAction];
    [chooseMapTypeAlert addAction:setSatelliteMapTypeAction];
    [chooseMapTypeAlert addAction:setCancel];
    [self presentViewController:chooseMapTypeAlert animated:YES completion:nil];
                                                                             
}

-(int) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(void) viewDidLoad {
    [super viewDidLoad];
 
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.mapTypeButton];
    UIBarButtonItem*barbutton = [[[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"New",nil) style:UIBarButtonItemStyleDone target: self action: @selector(goToNextView:)] autorelease];
    self.navigationItem.rightBarButtonItem =  barbutton;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    //self.mapView add
}

-(void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden: NO];
    _travelItemCollection = nil;
    [self.mapView removeAnnotations: self.mapView.annotations];
    [self addAnotationsFromTravelCollectionToMap];
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id ) annotation {
    
    if(annotation == mapView.userLocation) {
        return nil;
    }
    if( [annotation isKindOfClass:[AnnotationModel class]] )
    {
        MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"currentloc"];
        annView.animatesDrop = TRUE;
        annView.canShowCallout = YES;
        annView.calloutOffset = CGPointMake(-5, 5);
        return annView;
    }
    return nil;
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
    if([view.annotation isKindOfClass:[AnnotationModel class]])
    {
        AnnotationModel * annotationModelItem = ((AnnotationModel *)view.annotation);
        TravelInfoViewController * tviController = [[[TravelInfoViewController alloc] initWithCurrentIndex: annotationModelItem.number] autorelease];
        [self.navigationController pushViewController: tviController animated: YES];
    }
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    NSLog(@"tap on title");
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
    [self.mapView release];
    [super dealloc];
}
@end
