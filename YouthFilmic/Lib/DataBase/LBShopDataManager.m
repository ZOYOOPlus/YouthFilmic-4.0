//
//  LBShopDataManager.m
//  121mai
//
//  Created by 高刘备 on 16/2/26.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import "LBShopDataManager.h"

@implementation LBShopDataManager

HXSingleton_implementation(LBShopDataManager)

- (id)init
{
    self = [super init];
    if (self)
    {
        _collectShopDB = [[HXDataBase alloc]init];
        _collectShopDB.entityName = @"NormallMessage";
         _collectShopDB.sortKey = @"date";
        _collectShopDB.ascending = YES;
        [_collectShopDB fetch];
        
    }
    return self;
    
}
- (void)addCollectMessage:(MessageModel *)Message
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:Message.isme forKey:@"isme"];
    [dic setObject:Message.content forKey:@"content"];
    [dic setObject:Message.date forKey:@"date"];
    [dic setObject:Message.dateStr forKey:@"DateStr"];
    [dic setObject:Message.height forKey:@"height"];
    [_collectShopDB addItem:dic];
    [_collectShopDB save];
    [_collectShopDB fetch ];
}

- (void)removeCollectNormalShop:(NSString*)shopID
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"data_id == %@",shopID];
    NSArray *shopAry = [_collectShopDB findObject:@"Shop" withPredicate:predicate];
    NSManagedObject *obj = [shopAry firstObject];
    [_collectShopDB deleteObject:obj];
    [_collectShopDB save];
    [_collectShopDB fetch];
}
- (NSArray *)collectShops
{
    //    [_collectShopDB fetchWithLimit:2 offset:2*page ];
    
    NSArray *shopArray =  [_collectShopDB allItem];
    return shopArray;
    
}
- (NSArray*)colletMessages:(int)page
{
  [_collectShopDB fetchWithLimit:2 offset:2*page ];
    return _collectShopDB.results.fetchedObjects;
  
}

- (void)removeAllShops
{
    [_collectShopDB deleteAllItems];
    
}

@end
