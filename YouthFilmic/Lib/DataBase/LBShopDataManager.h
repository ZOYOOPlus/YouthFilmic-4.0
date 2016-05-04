//
//  LBShopDataManager.h
//  121mai
//
//  Created by 高刘备 on 16/2/26.
//  Copyright © 2016年 谷武科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXSingleton.h"
#import "HXDataBase.h"
#import "MessageModel.h"
typedef  void (opreatSucOrfailture)(BOOL isSucsess);

@interface LBShopDataManager : NSObject

HXSingleton_interface(LBShopDataManager)

@property (nonatomic,strong) HXDataBase *collectShopDB;


- (void)addCollectMessage:(MessageModel *)Message;
- (NSArray *)collectShops;
- (NSArray*)colletMessages:(int)page;
- (void)removeAllShops;

@end
