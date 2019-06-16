//
//  ViewController.m
//  MyWallet
//
//  Created by szp on 2019/6/6.
//  Copyright © 2019年 szp. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtAccount;
@property (weak, nonatomic) IBOutlet UITextField *txtPsd;
- (IBAction)btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btn_login;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _btn_login.layer.cornerRadius=20;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showError:(NSString *)errorMsg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errorMsg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:true completion:nil];
}

- (IBAction)btnLogin {
    NSString * account = self.txtAccount.text;
    NSString * password = self.txtPsd.text;
//    if([account isEqual:@""] || [password isEqual:@""]){
//        [self showError:@"用户名和密码不能为空"];
//    }
//    if([account isEqual:@"123456"]  && [password isEqual:@"123456"]){
//        UIViewController * interface = [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarView"];
//        [self presentViewController:interface animated:YES completion:nil];
//    }else{
//        NSLog(@"登陆失败");
//        [self showError:@"用户名或密码错误 \n默认账号和密码均为123456"];
//    }
    UIViewController * interface = [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarView"];
    [self presentViewController:interface animated:YES completion:nil];
    [self.view endEditing:YES];
}
@end
