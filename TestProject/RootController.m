//
//  RootController.m
//  TestProject
//
//  Created by Егор Сидоренко on 11/29/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "RootController.h"
#include "MapController.h"
#include "ListViewController.h"
@interface RootController()

@property (nonatomic) UIButton* mapButton;
@property (nonatomic) UIButton* listButton;

@property (nonatomic) int padding;

@end

@implementation RootController
- (int) padding {
    return 5;
}

-(UIButton*) mapButton {
    if(!_mapButton)
    {
        _mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapButton setTitle:@"MAP" forState:UIControlStateNormal];
        _mapButton.frame = CGRectMake(0.0+self.padding, 210.0, self.view.bounds.size.width - self.padding*2, 40.0);
        _mapButton.backgroundColor = [UIColor grayColor];
        [_mapButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        [_mapButton addTarget:self action:@selector(goToNextView:) forControlEvents:UIControlEventTouchDown];
    }
    
    return _mapButton;
}

-(UIButton*) listButton {
    if(!_listButton)
    {
        _listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_listButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _listButton.backgroundColor = [UIColor grayColor];
        _listButton.frame = CGRectMake(0.0+self.padding, 260.0, self.view.bounds.size.width - self.padding*2, 40.0);
        [_listButton setTitle:@"LIST" forState:UIControlStateNormal];
        [_listButton addTarget:self action:@selector(goToNextView:) forControlEvents:UIControlEventTouchDown];
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

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setTitle:@"Main Window"];
     self.navigationItem.title = @"Main Window";

}

-(void) viewDidUnload {
    [super viewDidUnload];
    [self.mapButton release];
    [self.listButton release];
}

-(void) goToNextView:(UIButton*) sender {
    if([sender.currentTitle isEqualToString: @"MAP"]){
        self.navigationItem.title = @"Back";
        MapController* mapController = [[MapController alloc] init];
        [self.navigationController pushViewController:mapController animated:YES];
    } else if ([sender.currentTitle isEqualToString:@"LIST"]) {
        self.navigationItem.title = @"Back";
        ListViewController* listController = [[ListViewController alloc] init];
        [self.navigationController pushViewController:listController animated:YES];
        [listController release];
    }
}

@end