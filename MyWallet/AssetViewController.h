//
//  AssetControllerViewController.h
//  MyWallet
//
//  Created by szp on 2019/6/7.
//  Copyright © 2019 szp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetControllerViewController : UIViewController

@property (nonatomic , strong) NSString * str;
@property NSInteger money;

@property (nonatomic, strong) NSMutableArray * asset;
@property (nonatomic, strong) NSMutableArray * balance;
@property (nonatomic, strong) NSMutableArray * availableBalance;

@property (nonatomic, strong) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
