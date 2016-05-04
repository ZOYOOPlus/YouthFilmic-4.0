
// HXDataBase.m
//  121mai
//
//  Created by 高刘备 on 16/2/26.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import "HXDataBase.h"

#ifndef SQLITE_DB_NAME
#define SQLITE_DB_NAME   @"HXDataBase.sqlite"
#endif

@interface HXDataBase () <NSFetchedResultsControllerDelegate>
{
 }

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation HXDataBase

static NSManagedObjectModel* s_managedObjectModel = nil;
static NSPersistentStoreCoordinator* s_persistentStoreCoordinator= nil;

- (id)init
{
    self = [super init];
    if (self)
    {
        _context = [[NSManagedObjectContext alloc] init];
        if (s_managedObjectModel == nil)//init first
        {
            s_managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
            NSString *storePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:SQLITE_DB_NAME];
            
            bool bInitDB = false;
            
            // set up the backing store
            NSFileManager *fileManager = [NSFileManager defaultManager];
            // If the expected store doesn't exist, copy the default store.
            bInitDB = [fileManager fileExistsAtPath:storePath];
            
            NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
            
            NSError *error;
            s_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:s_managedObjectModel];
            NSDictionary *options=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
            if ([s_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error])
            {
                [_context setPersistentStoreCoordinator:s_persistentStoreCoordinator];
                if (!bInitDB)
                {
                    [self save];
                }
            }
            else
            {
                id returnRes=nil;

    #if DEBUG
                [[NSFileManager defaultManager] removeItemAtURL:storeUrl error:nil];
                returnRes = [s_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error];
                if (!returnRes)
                {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
    #else
                returnRes = [s_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error];
                if (!returnRes)
                {
                    [[NSFileManager defaultManager] removeItemAtURL:storeUrl error:nil];
                    returnRes = [s_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
                    if (!returnRes)
                    {
                        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    }
                }
    #endif
                [_context setPersistentStoreCoordinator:s_persistentStoreCoordinator];
            }
            
        }
        else
        {
            [_context setPersistentStoreCoordinator:s_persistentStoreCoordinator];
        }
    }
    
    return self;
}

- (void)dealloc
{
    _entityName = nil;
    _idKey = nil;
    _sortKey = nil;
    _predicateFilter = nil;
    _context = nil;
}

- (void)fetch
{
    if (_entityName)
    {
        _results = [self fetch:_entityName
                       sortKey:_sortKey
                     ascending:_ascending
                     predicate:_predicateFilter
                      Delegate:self];
        _results.delegate = self;
    }
}

- (void)fetchWithLimit:(NSUInteger)limit offset:(NSUInteger)offset
{
    if (_entityName)
    {
        _results = [self fetch:_entityName
                       sortKey:_sortKey
                     ascending:_ascending
                     predicate:self.predicateFilter
                         limit:limit
                        offset:offset
               fetchResultType:NSManagedObjectResultType
                      Delegate:self];
        _results.delegate = self;
    }
}

- (NSUInteger)getTotalCount
{
    NSUInteger count = 0;
    if (_entityName)
    {
        NSFetchedResultsController* vc = [self fetch:_entityName
                                             sortKey:_sortKey
                                           ascending:_ascending
                                           predicate:self.predicateFilter
                                               limit:0
                                              offset:0
                                     fetchResultType:NSCountResultType
                                            Delegate:self];
        if (vc && vc.fetchedObjects && ([vc.fetchedObjects count] > 0))
        {
            count = [[vc.fetchedObjects objectAtIndex:0] intValue];
        }
    }
    
    return count;
}

- (NSArray*)allItem
{
    return _results.fetchedObjects;
}

- (NSInteger)itemCount
{
    return [_results.fetchedObjects count];
}

- (NSManagedObject*)item:(NSUInteger)i
{
    return [_results.fetchedObjects objectAtIndex:i];
}

- (NSManagedObject*)itemAt:(NSIndexPath *)indexPath
{
    return [_results objectAtIndexPath:indexPath];
}

- (BOOL)addItem:(NSDictionary*)item compareAttr:(NSArray*)attrArray
{
    BOOL rtv = NO;
    NSPredicate* predicate = nil;
    switch ([attrArray count])
    {
        case 1:
        {
            NSString* k0 = [attrArray objectAtIndex:0];
            NSString* v0 = [item valueForKey:k0];
            predicate = [NSPredicate predicateWithFormat:@"%K == %@",k0,v0];
        }
            break;
            
        case 2:
        {
            NSString* k0 = [attrArray objectAtIndex:0];
            NSString* v0 = [item valueForKey:k0];
            NSString* k1 = [attrArray objectAtIndex:1];
            NSString* v1 = [item valueForKey:k1];
            predicate = [NSPredicate predicateWithFormat:@"(%K == %@) && (%K == %@)",k0,v0,k1,v1];
        }
            break;
            
        default:
            break;
    }
    
    NSArray *arr = [self findObject:_entityName withPredicate:predicate];
    if ((arr == nil) || [arr count] == 0)
    {
        NSManagedObject* obj = [self insertNewObject:_entityName];
        
        NSEnumerator *enumerator = [item keyEnumerator];
        id key;
        while ((key = [enumerator nextObject]))
        {
            if([item objectForKey:key] != [NSNull null])
            {
                [obj setValue:[item objectForKey:key] forKey:key];
            }
        }
        
        rtv = YES;
    }
    
    return rtv;
}

- (void)addAndUpdateItem:(NSDictionary*)item
{
    NSArray* arr = [self findItem:item];
    if (arr && ([arr count] > 0))
    {
        for (NSManagedObject* obj in arr)
        {
            [self updateItem:item withObject:obj];
        }
    }
    else
    {
        [self addItem:item];
    }
}

- (NSArray*)findItem:(NSDictionary*)item
{
    NSArray *arr = nil;
    NSString* strID = [item objectForKey:_idKey];
    if (strID)
    {
        arr = [self findObject:_entityName Key:_idKey Value:strID];
    }
    return arr;
}

- (NSManagedObject*)addItem:(NSDictionary*)item
{
    NSManagedObject* obj = [self insertNewObject:_entityName];
    [self updateItem:item withObject:obj];
    return obj;
    
}

- (void)updateItem:(NSDictionary*)item withObject:(NSManagedObject*)obj
{
    if (obj)
    {
        NSEnumerator *enumerator = [item keyEnumerator];
        id key;
        while ((key = [enumerator nextObject]))
        {
            if([item objectForKey:key] != [NSNull null])
            {
                [obj setValue:[item objectForKey:key] forKey:key];
            }
        }
    }
}

- (void)deleteItem:(NSArray*)objArray
{
    if (objArray && [objArray count] > 0)
    {
        for (NSManagedObject*obj in objArray)
        {
            [self deleteObject:obj];
        }
        [self save];
    }
}

- (void)deleteAllItems
{
    [self deleteAllObjects:_entityName];
    [self save];
}

- (NSManagedObject*)insertNewObject:(NSString*)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.context];
}

- (void)deleteObject:(NSManagedObject*)obj
{
    if (obj)
    {
        [self.context deleteObject:obj];
    }
}

- (void)deleteAllObjects:(NSString*)entityName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName
                                                         inManagedObjectContext:self.context];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *objects = [_context executeFetchRequest:request error:&error];
    
    if (objects)
    {
        for (NSManagedObject *oneLine in objects)
        {
            [_context deleteObject:oneLine];
        }
    }
    
    [self save];
}

- (NSFetchedResultsController*)fetch:(NSString *)entityName
{
    return [self fetch:entityName sortKey:Nil ascending:YES predicate:Nil Delegate:nil];
}

- (NSFetchedResultsController*)fetch:(NSString *)entityName
                             sortKey:(NSString *)key
                           ascending:(BOOL)asc
                           predicate:(NSPredicate*)predicate
                            Delegate:(id<NSFetchedResultsControllerDelegate>)delegate
{
    return [self fetch:entityName sortKey:key ascending:asc predicate:predicate limit:0 offset:0 fetchResultType:NSManagedObjectResultType Delegate:delegate];
}

- (NSArray*)fetch:(NSString *)entityName
          sortKey:(NSString *)key
        ascending:(BOOL)asc
        predicate:(NSPredicate*)predicate
{
    [s_persistentStoreCoordinator lock];
    
    // Init a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = nil;
    if (key)
    {
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:asc selector:nil];
        NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
        [fetchRequest setSortDescriptors:descriptors];
    }
    
    if (predicate)
    {
        fetchRequest.predicate = predicate;
    }
    NSError *error;
    NSArray *objects = [self.context executeFetchRequest:fetchRequest error:&error];
    //	bafAssert(objects);
    if (sortDescriptor)
    {
        sortDescriptor = nil;
    }
    
    [s_persistentStoreCoordinator unlock];
    
    return objects;
}

- (NSFetchedResultsController*)fetch:(NSString *)entityName
                             sortKey:(NSString *)key
                           ascending:(BOOL)asc
                           predicate:(NSPredicate*)predicate
                               limit:(NSUInteger)limit
                              offset:(NSUInteger)offset
                     fetchResultType:(NSFetchRequestResultType)fetchResultType
                            Delegate:(id<NSFetchedResultsControllerDelegate>)delegate
{
    [s_persistentStoreCoordinator lock];
    // Init a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:limit];
    [fetchRequest setFetchOffset:offset];
    [fetchRequest setResultType:fetchResultType];
    
    NSSortDescriptor *sortDescriptor = nil;
    // Apply an ascending sort for the color items
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:asc selector:nil];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    
    // Recover query
    if (predicate)
    {
        fetchRequest.predicate = predicate;
    }
    
    // Init the fetched results controller
    NSError *error;
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    if (delegate)
    {
        fetchedResultsController.delegate = delegate;
    }
    
    if (![fetchedResultsController performFetch:&error])
    {
        NSLog(@"error");
    }
    
    [s_persistentStoreCoordinator unlock];
    
    return fetchedResultsController;
}

- (NSFetchedResultsController*)fetch:(NSString *)entityName
                             sortKey:(NSString *)key
                           ascending:(BOOL)asc
                           predicate:(NSPredicate*)predicate
                               limit:(NSUInteger)limit
                              offset:(NSUInteger)offset
                  sectionNameKeyPath:(NSString *)sectionKey
                     fetchResultType:(NSFetchRequestResultType)fetchResultType
                            Delegate:(id<NSFetchedResultsControllerDelegate>)delegate
{
    [s_persistentStoreCoordinator lock];
    // Init a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:limit];
    [fetchRequest setFetchOffset:offset];
    [fetchRequest setResultType:fetchResultType];
    
    NSSortDescriptor *sortDescriptor = nil;
    // Apply an ascending sort for the color items
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:asc selector:nil];
    NSArray *descriptors = [NSArray arrayWithObject:sortDescriptor];
    [fetchRequest setSortDescriptors:descriptors];
    
    // Recover query
    if (predicate)
    {
        fetchRequest.predicate = predicate;
    }
    
    // Init the fetched results controller
    NSError *error;
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:sectionKey cacheName:nil];
    if (delegate)
    {
        fetchedResultsController.delegate = delegate;
    }
    
    if (![fetchedResultsController performFetch:&error])
    {
        NSLog(@"error");
    }
    
    [s_persistentStoreCoordinator unlock];
    
    return fetchedResultsController;
}


- (void)save
{
    NSError *error;
    if (![self.context save:&error])
    {
        return;
    }
}

- (NSArray*)findObject:(NSString *)entityName withPredicate:(NSPredicate*)predicate
{
    return [self fetch:entityName
               sortKey:nil
             ascending:NO
             predicate:predicate];
}

- (NSArray*)findObject:(NSString *)entityName Key:(NSString*)key Value:(id)value
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:
                              @"%K == %@",key,value];
    
    return [self fetch:entityName
               sortKey:nil 
             ascending:NO 
             predicate:predicate];
}

@end
