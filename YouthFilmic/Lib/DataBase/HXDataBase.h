//
// HXDataBase.h
//  121mai
//
//  Created by 高刘备 on 16/2/26.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "HXSingleton.h"

@interface HXDataBase : NSObject

@property (nonatomic, strong) NSString* entityName;
@property (nonatomic, strong) NSString* idKey;
@property (nonatomic, strong) NSString* sortKey;
@property (nonatomic, assign) BOOL ascending;
@property (nonatomic, strong) NSPredicate *predicateFilter;
@property (nonatomic, strong)NSFetchedResultsController*results;

- (void)fetch;
- (void)fetchWithLimit:(NSUInteger)limit offset:(NSUInteger)offset;
- (NSUInteger)getTotalCount;
- (NSArray *)allItem;
- (NSInteger)itemCount;
- (NSManagedObject *)item:(NSUInteger)i;
- (NSManagedObject *)itemAt:(NSIndexPath *)indexPath;
- (BOOL)addItem:(NSDictionary *)item compareAttr:(NSArray*)attrArray;
- (void)addAndUpdateItem:(NSDictionary *)item;
- (NSArray *)findItem:(NSDictionary *)item;
- (NSManagedObject *)addItem:(NSDictionary *)item;
- (void)updateItem:(NSDictionary *)item withObject:(NSManagedObject *)obj;
- (void)deleteItem:(NSArray *)objArray;
- (void)deleteAllItems;

- (NSManagedObject *)insertNewObject:(NSString *)entityName;
- (void)deleteObject:(NSManagedObject *)obj;
- (void)deleteAllObjects:(NSString *)entityName;

- (NSFetchedResultsController*)fetch:(NSString *)entityName;

- (NSFetchedResultsController*)fetch:(NSString *)entityName
                            sortKey:(NSString *)key
                          ascending:(BOOL)asc
                          predicate:(NSPredicate *)predicate
                           Delegate:(id<NSFetchedResultsControllerDelegate>)delegate;

- (NSArray*)fetch:(NSString *)entityName
         sortKey:(NSString *)key
       ascending:(BOOL)asc
       predicate:(NSPredicate *)predicate;

- (NSFetchedResultsController*)fetch:(NSString *)entityName
                            sortKey:(NSString *)key
                          ascending:(BOOL)asc
                          predicate:(NSPredicate *)predicate
                              limit:(NSUInteger)limit
                             offset:(NSUInteger)offset
                    fetchResultType:(NSFetchRequestResultType)fetchResultType
                           Delegate:(id<NSFetchedResultsControllerDelegate>)delegate;

- (NSFetchedResultsController*)fetch:(NSString *)entityName
                            sortKey:(NSString *)key
                          ascending:(BOOL)asc
                          predicate:(NSPredicate *)predicate
                              limit:(NSUInteger)limit
                             offset:(NSUInteger)offset
                 sectionNameKeyPath:(NSString *)sectionKey
                    fetchResultType:(NSFetchRequestResultType)fetchResultType
                           Delegate:(id<NSFetchedResultsControllerDelegate>)delegate;

- (NSArray *)findObject:(NSString *)entityName Key:(NSString *)key Value:(id)value;

- (NSArray *)findObject:(NSString *)entityName withPredicate:(NSPredicate *)predicate;

- (void)save;

@end
