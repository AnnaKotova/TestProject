
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

+ (instancetype)sharedDataSource
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

- (NSArray *)getTravelItemCollection:(NSString *) predicate
{
    NSFetchRequest * inf = [NSFetchRequest fetchRequestWithEntityName: @"TravelInfo"];
    if(predicate)
    {
        NSPredicate * fetchPredicate = [NSPredicate predicateWithFormat:predicate];
        [inf setPredicate:fetchPredicate];
    }
    NSArray * arr = [self.coreController.managedObjectContext executeFetchRequest: inf error: nil];
    return arr;
}

- (NSArray *)getTravelItemCollectionByPage:(NSInteger) currentPage
{
    [self saveContexChanges];
    NSInteger pageSize = 10;
    NSFetchRequest * inf = [NSFetchRequest fetchRequestWithEntityName: @"TravelInfo"];
    inf.fetchBatchSize = pageSize;
    inf.fetchOffset = pageSize * currentPage;
    inf.fetchLimit = pageSize;
    NSArray * arr = [self.coreController.managedObjectContext executeFetchRequest: inf error: nil];
    return arr;
}

- (TravelItem *)getTravelItem:(NSInteger) offset
{
    [self saveContexChanges];
    NSInteger pageSize = 1;
    NSFetchRequest * inf = [NSFetchRequest fetchRequestWithEntityName: @"TravelInfo"];
    inf.fetchBatchSize = pageSize;
    inf.fetchOffset = offset;
    inf.fetchLimit = pageSize;
    TravelItem * item = (TravelItem *)[[self.coreController.managedObjectContext executeFetchRequest: inf error: nil] firstObject];
    NSLog(@"Name: %@ Offset: %d", item.name, offset);
    return item;
}

- (NSInteger) getCountOfTravelItems
{
    NSFetchRequest * inf = [NSFetchRequest fetchRequestWithEntityName: @"TravelInfo"];
    [inf setIncludesSubentities:NO];
    NSError * err;
    NSUInteger count = [self.coreController.managedObjectContext countForFetchRequest:inf error:&err];
    return count;
}

- (void)removeTravelItem:(TravelItem *) item
{
    [self.coreController.managedObjectContext deleteObject: item];
}

- (void)saveContexChanges
{
    if([self.coreController.managedObjectContext hasChanges])
    {
        [self.coreController.managedObjectContext save: nil];
    }
}


@end
