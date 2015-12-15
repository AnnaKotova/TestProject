//
//  RootController.m
//  TestProject
//
//  Created by Егор Сидоренко on 11/29/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "RootViewController.h"
#include "MapViewController.h"
#include "ListViewController.h"
@interface RootViewController()

@property (nonatomic, retain) UIButton* mapButton;
@property (nonatomic, retain) UIButton* listButton;

@property (nonatomic) int padding;

@end

@implementation RootViewController
- (int) padding {
    return 5;
}

-(UIButton*) mapButton {
    if(!_mapButton)
    {
        _mapButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_mapButton setTitle: @"MAP" forState: UIControlStateNormal];
        _mapButton.frame = CGRectMake(0.0 + self.padding, 210.0, self.view.bounds.size.width - self.padding * 2, 40.0);
        _mapButton.backgroundColor = [UIColor grayColor];
        [_mapButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
        
        [_mapButton addTarget: self action: @selector(goToNextView:) forControlEvents: UIControlEventTouchDown];
    }
    
    return _mapButton;
}

-(UIButton*) listButton {
    if(!_listButton)
    {
        _listButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_listButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
        _listButton.backgroundColor = [UIColor grayColor];
        _listButton.frame = CGRectMake(0.0+self.padding, 260.0, self.view.bounds.size.width - self.padding * 2, 40.0);
        [_listButton setTitle: @"LIST" forState: UIControlStateNormal];
        [_listButton addTarget: self action: @selector(goToNextView:) forControlEvents: UIControlEventTouchDown];
    }
    
    return _listButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapButton];
    [self.view addSubview:self.listButton];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self setTitle: @"Main Window"];
     self.navigationItem.title = @"Main Window";
}

-(void) viewDidUnload
{
    [super viewDidUnload];
}

-(void) goToNextView:(UIButton *) sender
{
    if(sender == _mapButton)
    {
        self.navigationItem.title = @"Back";
        MapViewController * mapController = [[MapViewController alloc] init];
        [self.navigationController pushViewController: mapController animated: YES];
    }
    else if ([sender.currentTitle isEqualToString: @"LIST"])
    {
        self.navigationItem.title = @"Back";
        ListViewController * listController = [[ListViewController alloc] init];
        [self.navigationController pushViewController:listController animated:YES];
        [listController release];
    }
}

@end