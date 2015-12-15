//
//  DbController.h
//  TestProject
//
//  Created by Егор Сидоренко on 12/1/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DbController : NSObject

@property (strong) NSManagedObjectContext * managedObjectContext;

- (void)initializeCoreData;

@end
