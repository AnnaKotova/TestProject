//
//  DataSource.m
//  TestProject
//
//  Created by User on 12/14/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "DataSource.h"
@interface DataSource()

- (instancetype)init;
@property (nonatomic)  DbController * coreController;
@end

@implementation DataSource

- (DbController *)coreController
{
    if(!_coreController)
    {
        _coreController = [[DbController alloc] init];
    }
    return _coreController;
}

+ (DataSource *)sharedDataSource
{
    static DataSource * singletonObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
    });
    return singletonObject;
}

- (instancetype)init
{
    self = [super init];
    return self;
}

- (TravelItem *)createNewTravelItem
{
    return (TravelItem *)[NSEntityDescription insertNewObjectForEntityForName: @"TravelInfo"
                                                       inManagedObjectContext: self.coreController.managedObjectContext];
}

- (NSArray *)getTravelItemCollection
{
    NSFetchRequest * inf = [NSFetchRequest fetchRequestWithEntityName: @"TravelInfo"];
    NSArray * arr = [self.coreController.managedObjectContext executeFetchRequest: inf error: nil];
    return arr;
}

- (void)removeTravelItem:(TravelItem *) item
{
    [self.coreController.managedObjectContext deleteObject: item];
}

- (void)saveContexChanges
{
    [self.coreController.managedObjectContext save: nil];
}


@end
