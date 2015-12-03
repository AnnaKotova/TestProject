//
//  SaveController.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/1/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "SaveController.h"
#import "DbController.h"
#import "TravelInfo.h"

@interface SaveController()

@property (nonatomic) TravelModel* model;

@end

@implementation SaveController

@synthesize model = _model;

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
    DbController* coreController =  [[DbController alloc] init];
    NSManagedObjectContext* context = coreController.managedObjectContext;
    TravelInfo* info = (TravelInfo*)[NSEntityDescription insertNewObjectForEntityForName:@"TravelInfo" inManagedObjectContext:context];
    [info setValuesForKeysWithDictionary:@{
                                           @"longitude":[NSNumber numberWithDouble:self.model.longitude],
                                           @"latitude":[NSNumber numberWithDouble:self.model.latitude],
                                           @"name":self.model.name,
                                           @"imageUrl":self.model.imageUrl,
                                           @"soundUrl":self.model.soundUrl,
                                           }];
    [context save:nil];
    [coreController release];
    /*
    NSFetchRequest* inf = [NSFetchRequest fetchRequestWithEntityName:@"TravelInfo"];
    NSArray* arr = [context executeFetchRequest:inf error:nil];
    for(id obj in arr) {
        if( [obj isMemberOfClass:[TravelInfo class]]) {
            TravelInfo * inf = (TravelInfo*)obj;
            NSLog(inf.name);
        }
    }
     */
}

@end
