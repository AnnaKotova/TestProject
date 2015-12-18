//
//  TravelItem+CoreDataProperties.h
//  TestProject
//
//  Created by User on 12/16/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TravelItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface TravelItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imagePath;
@property (nullable, nonatomic, retain) NSString *soundPath;
@property (nullable, nonatomic, retain) NSString *thumbnailPath;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSNumber *latitude;

@end

NS_ASSUME_NONNULL_END
