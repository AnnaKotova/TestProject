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

@interface MapViewController() <MKMapViewDelegate, CLLocationManagerDelegate, UIPickerViewDelegate>

@property (nonatomic, retain) NSArray * travelItemCollection;
@property (nonatomic, retain) MKMapView * mapView;
@property (nonatomic, retain) CLLocationManager * locationManager;
//@property (nonatomic, retain) UIButton * mapTypeButton;
@property (nonatomic, retain) UIToolbar * toolbar;

@property (nonatomic) int _mapHeight;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end

@implementation MapViewController



#pragma mark - UIViewController Life Cycle

- (void)dealloc
{
    [self.mapView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.mapView];
    //[self.view addSubview:self.mapTypeButton];
    //[self.view bringSubviewToFront:self.mapTypeButton];
    UIBarButtonItem * barbutton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"New", nil)
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(_buttonAction:)] autorelease];
    self.navigationItem.rightBarButtonItem =  barbutton;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
    
    self.toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.mapView.bounds.size.height - 30, self.mapView.bounds.size.width,  30)] autorelease];
    [self.toolbar setOpaque:YES];
    self.toolbar.alpha = 0.5;
    //[self.toolbar setBarStyle:UIBarStyleBlackOpaque];
    self.toolbar.barTintColor = [UIColor colorWithRed:210 green:210 blue:210 alpha:0.5];
    UIBarButtonItem * standartMapTabBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Standart" style:UIBarButtonItemStylePlain target:self action: @selector(_changeMapStyleBarButtonAction:)];
    standartMapTabBarItem.tag = 1;
    [standartMapTabBarItem setEnabled:NO];
    UIBarButtonItem * hybridMapTabBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Hybrid" style:UIBarButtonItemStylePlain target:self action: @selector(_changeMapStyleBarButtonAction:)];
    hybridMapTabBarItem.tag = 2;
    UIBarButtonItem * satelliteMapTabBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Satellite" style:UIBarButtonItemStylePlain target:self action: @selector(_changeMapStyleBarButtonAction:)];
    satelliteMapTabBarItem.tag = 3;
    UIBarButtonItem * flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self.toolbar setItems:@[flexibleItem, standartMapTabBarItem, satelliteMapTabBarItem, hybridMapTabBarItem, flexibleItem]];
    [self.view addSubview:self.toolbar];
    [self.view bringSubviewToFront:self.toolbar];
    
    [standartMapTabBarItem release];
    [hybridMapTabBarItem release];
    [satelliteMapTabBarItem release];
    [flexibleItem release];
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden: NO];
    _travelItemCollection = nil;
    [self.mapView removeAnnotations: self.mapView.annotations];
    [self _addAnotationsFromTravelCollectionToMap];
}


#pragma mark - Properties Setters and Getters

@synthesize _mapHeight = __mapHeight;

- (MKMapView *)mapView
{
    if(!_mapView){
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [_mapView setShowsUserLocation: YES];
        
        [_mapView setZoomEnabled: YES];
        _mapView.delegate = self;
        [_mapView setShowsScale: YES];
        //[_mapView setScrollEnabled: YES];
        
    }
    return _mapView;
}


- (CLLocationManager *)locationManager
{
    if(!_locationManager) {
        _locationManager = [[[CLLocationManager alloc] init] autorelease];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.delegate = self;
    }
    return _locationManager;
}


- (NSArray *)travelItemCollection
{
    if(!_travelItemCollection) _travelItemCollection = [DataSource.sharedDataSource getTravelItemCollectionByPage:0];
    return _travelItemCollection;
}
- (int)_mapHeight {
    return 70;
}

/*- (UIButton *)mapTypeButton
{
    if(!_mapTypeButton)
    {
        _mapTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 70, self.view.bounds.size.width,  70)];
        [_mapTypeButton addTarget:self action:@selector(_chooseTypeButtonAction:) forControlEvents:UIControlEventAllTouchEvents];
        [_mapTypeButton setTitle:@"Map Type: Standart" forState:UIControlStateNormal];
        [_mapTypeButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [_mapTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _mapTypeButton;
}*/

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id ) annotation
{
    
    if(annotation == mapView.userLocation)
    {
        return nil;
    }
    if( [annotation isKindOfClass:[AnnotationModel class]] )
    {
        MKPinAnnotationView *annView=[[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"currentloc"] autorelease];

        annView.animatesDrop = TRUE;
        annView.canShowCallout = YES;
        annView.calloutOffset = CGPointMake(-5, 5);
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 10)];
        [btn setImage:[UIImage imageNamed:@"annotationInfo"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(_showTravelInfoAnnotationButtonAction:) forControlEvents:UIControlEventTouchDown];
        btn.tag = ((AnnotationModel *)annotation).number;

        annView.rightCalloutAccessoryView = btn;
        [btn release];
        return annView;
    }
    return nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self.locationManager startUpdatingLocation];
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated: YES];
    self.latitude =  userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
}

#pragma mark - Private Section
/*
- (void)_chooseTypeButtonAction:(UIButton *)sender
{
    UIAlertController * chooseMapTypeAlert = [UIAlertController alertControllerWithTitle:@"choose map type"
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * standartmaptypeAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"Standart",nil)
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action)
                                             {
                                                 [self.mapView setMapType:MKMapTypeStandard];
                                                 [_mapTypeButton setTitle:@"Map Type: Standart" forState:UIControlStateNormal];
                                             }];
    
    UIAlertAction * hybridMapTypeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Hybrid", nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action)
                                           {
                                               [self.mapView setMapType:MKMapTypeHybrid];
                                               [_mapTypeButton setTitle:@"Map Type: Hybrid" forState:UIControlStateNormal];
                                           }];
    
    UIAlertAction * satelliteMapTypeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Satellite", nil)
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * _Nonnull action)
                                              {
                                                  [self.mapView setMapType:MKMapTypeSatellite];
                                                  [_mapTypeButton setTitle:@"Map Type: Satellite"
                                                                  forState:UIControlStateNormal];
                                              }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) { }];
    
    [chooseMapTypeAlert addAction:standartmaptypeAction];
    [chooseMapTypeAlert addAction:hybridMapTypeAction];
    [chooseMapTypeAlert addAction:satelliteMapTypeAction];
    [chooseMapTypeAlert addAction:cancelAction];
    [self presentViewController:chooseMapTypeAlert animated:YES completion:nil];
}*/

- (void)_addAnotationsFromTravelCollectionToMap
{
    int count = 0;
    for (TravelItem * travelItemObject in self.travelItemCollection) {
        CLLocationCoordinate2D  coord =  CLLocationCoordinate2DMake(47.8524931, 35.1270998);
        AnnotationModel * annotationModel = [[AnnotationModel alloc] initWithTitle: travelItemObject.name Coordinates: coord Number: count];
        [self.mapView addAnnotation: annotationModel];
        [annotationModel release];
        count++;
    }
}

- (void)_buttonAction:(UIBarButtonItem *)sender
{
    TravelItem * item = [DataSource.sharedDataSource createNewTravelItem];
    [DataSource.sharedDataSource removeTravelItem:item];
    item = [DataSource.sharedDataSource createNewTravelItem];
    [item setValuesForKeysWithDictionary:@{
                                           @"longitude":[NSNumber numberWithDouble: self.longitude],
                                           @"latitude":[NSNumber numberWithDouble: self.latitude] }];
    
    ImageViewController * chooseController = [[[ImageViewController alloc] initWithModel: item] autorelease];
    [self.navigationController pushViewController: chooseController animated: YES];
    
}
- (void)_changeMapStyleBarButtonAction:(UIBarButtonItem *) sender
{
    for (UIBarButtonItem* item in [self.toolbar items]) {
        item.enabled = YES;
    }
    sender.enabled = NO;
    switch (sender.tag) {
        case 1:
            [self.mapView setMapType:MKMapTypeStandard];
            break;
        case 2:
            [self.mapView setMapType:MKMapTypeHybrid];
            break;
        case 3:
            [self.mapView setMapType:MKMapTypeSatellite];
            break;
    }
}

- (void)_showTravelInfoAnnotationButtonAction:(UIButton *)sender
{
    TravelInfoViewController * tviController = [[[TravelInfoViewController alloc] initWithCurrentIndex:sender.tag] autorelease];
    [self.navigationController pushViewController: tviController animated: YES];
}
@end
