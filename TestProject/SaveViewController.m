//
//  SaveController.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/1/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "SaveViewController.h"

@interface SaveViewController()

@end

@implementation SaveViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Saved!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self saveModelToCoreData];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) viewDidUnload
{
    [super viewDidUnload];
}

-(void) saveModelToCoreData
{
    [DataSource.sharedDataSource saveContexChanges];
}

@end
