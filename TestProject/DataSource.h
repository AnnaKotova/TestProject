//
//  DataSource.h
//  TestProject
//
//  Created by User on 12/14/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Travelitem.h"
#import "DbController.h"

@interface DataSource : NSObject

+(DataSource*) sharedDataSource;

-(TravelItem*) createNewTravelItem;

- (NSArray *)getTravelItemCollection:(NSString *) predicate;

- (NSArray *)getTravelItemCollectionByPage:(NSInteger) currentPage;

- (TravelItem *)getTravelItem:(NSInteger) offset;

-(void) removeTravelItem:(TravelItem *) item;

-(void) saveContexChanges;

-(NSInteger) getCountOfTravelItems;

@end
