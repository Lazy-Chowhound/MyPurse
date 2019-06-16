//
//  PopViewController.h
//  MyWallet
//
//  Created by szp on 2019/6/15.
//  Copyright © 2019 szp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopViewController : UIViewController

@property (nonatomic , strong) NSString * user;

@property (nonatomic, strong) NSMutableArray * action;
@property (nonatomic, strong) NSMutableArray * amount;
@property (nonatomic, strong) NSMutableArray * createTime;

@property (nonatomic, strong) UITableView *tableView;



@end

NS_ASSUME_NONNULL_END
