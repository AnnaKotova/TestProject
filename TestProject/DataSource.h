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

-(NSArray*) getTravelItemCollection;

-(void) removeTravelItem:(TravelItem *) item;

-(void) saveContexChanges;

@end
