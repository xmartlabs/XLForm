//
//  CoreDataStore.m
//  XLForm ( https://github.com/xmartlabs/XLForm )
//
//  Copyright (c) 2015 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "CoreDataStore.h"

static NSString *const TBCoreDataModelFileName = @"Model";

@interface CoreDataStore ()

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (strong, nonatomic) NSManagedObjectContext *mainQueueContext;
@property (strong, nonatomic) NSManagedObjectContext *privateQueueContext;

@end

@implementation CoreDataStore


+ (instancetype)defaultStore {
    static CoreDataStore *_defaultStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultStore = [[self alloc] init];
    });
    return _defaultStore;
}

#pragma mark - Singleton Access

+ (NSManagedObjectContext *)mainQueueContext
{
    return [[self defaultStore] mainQueueContext];
}

+ (NSManagedObjectContext *)privateQueueContext
{
    return [[self defaultStore] privateQueueContext];
}

+(void)savePrivateQueueContext
{
    NSError * error;
    [[self privateQueueContext] save:&error];
    NSAssert(!error, [error localizedDescription]);
}

+ (void)saveMainQueueContext
{
    NSError * error;
    [[self mainQueueContext] save:&error];
    NSAssert(!error, [error localizedDescription]);
}

+ (NSManagedObjectID *)managedObjectIDFromString:(NSString *)managedObjectIDString
{
    return [[[self defaultStore] persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:managedObjectIDString]];
}

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSavePrivateQueueContext:)name:NSManagedObjectContextDidSaveNotification object:[self privateQueueContext]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSaveMainQueueContext:) name:NSManagedObjectContextDidSaveNotification object:[self mainQueueContext]];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications

- (void)contextDidSavePrivateQueueContext:(NSNotification *)notification
{
    @synchronized(self) {
        [self.mainQueueContext performBlock:^{
            for(NSManagedObject *object in [[notification userInfo] objectForKey:NSUpdatedObjectsKey]) {
                [[self.mainQueueContext objectWithID:[object objectID]] willAccessValueForKey:nil];
            }
            [self.mainQueueContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

- (void)contextDidSaveMainQueueContext:(NSNotification *)notification
{
    @synchronized(self) {
        [self.privateQueueContext performBlock:^{
            [self.privateQueueContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

#pragma mark - Getters

- (NSManagedObjectContext *)mainQueueContext
{
    if (!_mainQueueContext) {
        _mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _mainQueueContext;
}

- (NSManagedObjectContext *)privateQueueContext
{
    if (!_privateQueueContext) {
        _privateQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _privateQueueContext;
}

#pragma mark - Stack Setup

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSError *error = nil;
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:[self persistentStoreOptions] error:&error]) {
            NSLog(@"Error adding persistent store. %@, %@", error, error.userInfo);
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:TBCoreDataModelFileName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

- (NSURL *)persistentStoreURL
{
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
}

- (NSDictionary *)persistentStoreOptions
{
    return @{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES, NSSQLitePragmasOption: @{@"synchronous": @"OFF"}};
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




@end


@implementation NSManagedObject (Additions)


+(instancetype)findFirstByAttribute:(NSString *)attribute withValue:(id)value inContext:(NSManagedObjectContext *)context
{
    NSString * predicateStr = [NSString stringWithFormat:@"%@ = %%@", attribute];
    NSPredicate * searchByAttValue = [NSPredicate predicateWithFormat:predicateStr argumentArray:@[value]];
    NSFetchRequest * fetchRequest = [self fetchRequest];
    fetchRequest.predicate = searchByAttValue;
    fetchRequest.fetchLimit = 1;
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
    return [result lastObject];
}

+(NSFetchRequest*)fetchRequest
{
    return [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass(self)];
}

+(NSEntityDescription*)entityDescriptor:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
}

+(instancetype)insert:(NSManagedObjectContext *)context
{
    return [[NSManagedObject alloc] initWithEntity:[self entityDescriptor:context] insertIntoManagedObjectContext:context];
}

@end



