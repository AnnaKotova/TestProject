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

@property (nonatomic, retain) UIButton * mapButton;
@property (nonatomic, retain) UIButton * listButton;

@property (nonatomic) int padding;

@end

@implementation RootViewController

#pragma mark ViewController Life Cycle

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
    [self setTitle: NSLocalizedString(@"Main Window",nil)];
    self.navigationItem.title = NSLocalizedString(@"Main Window",nil);
}

-(void) viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark Properties Setters and Getters

- (int) padding {
    return 5;
}

- (UIButton *)mapButton {
    if(!_mapButton)
    {
        _mapButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_mapButton setTitle: NSLocalizedString(@"Map",nil) forState: UIControlStateNormal];
        _mapButton.frame = CGRectMake(0.0 + self.padding, 210.0, self.view.bounds.size.width - self.padding * 2, 40.0);
        _mapButton.backgroundColor = [UIColor grayColor];
        [_mapButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
        
        [_mapButton addTarget: self
                       action: @selector(_buttonAction:)
             forControlEvents: UIControlEventTouchDown];
    }
    
    return _mapButton;
}

- (UIButton *)listButton {
    if(!_listButton)
    {
        _listButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_listButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
        _listButton.backgroundColor = [UIColor grayColor];
        _listButton.frame = CGRectMake(0.0+self.padding, 260.0, self.view.bounds.size.width - self.padding * 2, 40.0);
        [_listButton setTitle: NSLocalizedString(@"List",nil) forState: UIControlStateNormal];
        [_listButton addTarget: self
                        action: @selector(_buttonAction:)
              forControlEvents: UIControlEventTouchDown];
    }
    
    return _listButton;
}




#pragma mark Private Action

-(void) _buttonAction:(UIButton *) sender
{
    if(sender == _mapButton)
    {
        self.navigationItem.title = NSLocalizedString(@"Back",nil);
        MapViewController * mapController = [[[MapViewController alloc] init] autorelease];
        [self.navigationController pushViewController: mapController animated: YES];
    }
    else
    {
        self.navigationItem.title = NSLocalizedString(@"Back",nil);
        ListViewController * listController = [[[ListViewController alloc] init] autorelease];
        [self.navigationController pushViewController:listController animated:YES];
    }
}

@end