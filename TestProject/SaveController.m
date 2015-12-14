//
//  SaveController.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/1/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "SaveController.h"

@interface SaveController()

@end

@implementation SaveController

-(void) viewDidLoad {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Saved!" message:@"" preferredStyle:UIAlertActionStyleDefault];
    //alert addAction:[UIAlertAction]
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //SaveModel to CoreData
        [self saveModelToCoreData];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void) viewDidUnload {
    [super viewDidUnload];
    [self.model release];
}

-(void) saveModelToCoreData {
    [DataSource.sharedDataSource addTravelItem: self.model];
    [DataSource.sharedDataSource saveContexChanges];
}

@end
