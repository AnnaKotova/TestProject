//
//  TravelCollection.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "TravelCollection.h"

@implementation TravelCollection

@synthesize travelPoints = _travelPoints;

-(NSArray*) travelPoints {
    
        if(!_travelPoints) {
            DbController* coreController =  [[DbController alloc] init];
            NSManagedObjectContext* context = coreController.managedObjectContext;
            //[context deletedObjects];
            //[context save:nil];
            
            NSFetchRequest* inf = [NSFetchRequest fetchRequestWithEntityName:@"TravelInfo"];
            NSArray* arr = [context executeFetchRequest:inf error:nil];

            _travelPoints = [[NSMutableArray alloc] init];
            
            for (NSManagedObject *obj in arr) {
                //[context deletedObjects];
                TravelModel * inf = [[TravelModel alloc] init];
                inf.latitude = [((TravelInfo*)obj).latitude doubleValue];
                inf.longitude = [((TravelInfo*)obj).longitude doubleValue];
                inf.imageUrl = ((TravelInfo *) obj).imageUrl;
                inf.soundUrl = ((TravelInfo *) obj).soundUrl;
                inf.name = ((TravelInfo * ) obj).name;
                [_travelPoints addObject:inf];
            }
            //[arr release];
            //[inf release];
            [context release];
            [coreController release];

        }
        return _travelPoints;
}

@end
