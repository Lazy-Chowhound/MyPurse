//
//  TabbarView.m
//  MyWallet
//
//  Created by szp on 2019/6/12.
//  Copyright © 2019 szp. All rights reserved.
//

#import "TabbarView.h"

@implementation TabbarView

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UITabBarItem *item in self.tabBar.items) {
        item.selectedImage = [item.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
}
@end
