#import "DbController.h"
@import CoreData;
@implementation DbController

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self setupCoreDataController];
    }
    
    return self;
}

- (void)setupCoreDataController
{
    NSURL * modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension: @"momd"];
    NSManagedObjectModel * mom = [[[NSManagedObjectModel alloc] initWithContentsOfURL: modelURL] autorelease];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    NSPersistentStoreCoordinator * psc = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: mom] autorelease];
    NSManagedObjectContext * moc = [[[NSManagedObjectContext alloc] initWithConcurrencyType: NSMainQueueConcurrencyType] autorelease];

    moc.persistentStoreCoordinator = psc;
    self.managedObjectContext = moc;
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSURL * documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains: NSUserDomainMask] lastObject];
    NSURL * storeURL = [documentsURL URLByAppendingPathComponent:@"CoreDataModel.sqlite"];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^(void)
    {
        NSError * error = nil;
        NSPersistentStoreCoordinator * psc = [[self managedObjectContext] persistentStoreCoordinator];
        NSPersistentStore * store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration: nil
                                                                URL: storeURL
                                                            options: nil
                                                              error: &error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    });
}
@end