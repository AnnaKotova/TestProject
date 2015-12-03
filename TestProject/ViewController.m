//
//  ViewController.m
//  TestProject
//
//  Created by Егор Сидоренко on 11/29/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,weak) UIButton* mapButton;
@property (nonatomic,weak) UIButton* listButton;

@end



@implementation ViewController

- (UIButton*) getMapButton:(UIButton*)mapButton {
    if(!_listButton) _listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    return _listButton;
}

- (UIButton*) getListButton:(UIButton*)mapButton {
    if(!_mapButton) _mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    return _mapButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Main Menu";
    [self.listButton setTitle:@"LIST" forState:UIControlStateNormal];
    self.listButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:self.listButton];
}
/*
 UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
 [button addTarget:self
 action:@selector(aMethod:)
 forControlEvents:UIControlEventTouchUpInside];
 [button setTitle:@"Show View" forState:UIControlStateNormal];
 button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
 [view addSubview:button];
 */

@end
