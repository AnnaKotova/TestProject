//
//  TravelItem+CoreDataProperties.h
//  TestProject
//
//  Created by User on 12/14/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TravelItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TravelItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *soundUrl;

@end

NS_ASSUME_NONNULL_END
