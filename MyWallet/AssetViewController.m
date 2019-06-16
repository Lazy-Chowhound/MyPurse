//
//  AssetControllerViewController.m
//  MyWallet
//
//  Created by szp on 2019/6/7.
//  Copyright © 2019 szp. All rights reserved.
//

#import "AssetViewController.h"
#import "PopViewController.h"
#import "TabbarView.h"

@interface AssetControllerViewController ()

@property (nonatomic , strong) UITextView * tit;
@property (nonatomic , strong) UITextView * totalmoney;
@property (nonatomic, strong)  UILabel *totallabel;

@end

@implementation AssetControllerViewController

- (UITextView *)tit{
    if(_tit == nil){
        _tit = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 80)];
        UIImageView * image = [[UIImageView alloc]initWithFrame:_tit.bounds];
        image.image = [UIImage imageNamed:@"back1"];
        [_tit addSubview:image];
        [_tit sendSubviewToBack:image];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-38, 35, 100, 30)];
        label.text = @"我的资产";
        [_tit addSubview:label];
    }
    return _tit;
}

- (UITextView *)totalmoney{
    if(_totalmoney == nil){
        _totalmoney = [[UITextView alloc]initWithFrame:CGRectMake(0, 81, [[UIScreen mainScreen] bounds].size.width, 100)];
        _totalmoney.font = [UIFont systemFontOfSize:30];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-30, 50, 100, 30)];
        label.text = [[NSString alloc] initWithFormat:@" %.2lf", (float)self.money];
        [_totalmoney addSubview:label];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:_totalmoney.bounds];
        image.image = [UIImage imageNamed:@"back2"];
        [_totalmoney addSubview:image];
        [_totalmoney sendSubviewToBack:image];
    }
    return _totalmoney;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.totallabel = [[UILabel alloc]initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-50, 90, 130, 60)];
    self.totallabel.text =@"账户余额（元）";
    self.totallabel.autoresizesSubviews=TRUE;
    [self setupDatas];
    [self setupSubviews];
    [self.view addSubview:self.tit];
    [self.view addSubview:self.totalmoney];
    [self.view addSubview:self.totallabel ];    
}

- (void)setupSubviews {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}


//初始化数据
- (void)setupDatas {
    NSMutableArray * dataArray = [self synGet];
    self.asset = [[NSMutableArray alloc]init];
    self.balance = [[NSMutableArray alloc]init];;
    self.availableBalance = [[NSMutableArray alloc]init];
    for(NSInteger i = 0 ; i < dataArray.count ; i++){
        [self.asset addObject:dataArray[i][@"asset"]];
        [self.balance addObject:dataArray[i][@"balance"]];
        [self.availableBalance addObject:dataArray[i][@"availableBalance"]];
        self.money += [dataArray[i][@"availableBalance"] intValue];
    }
}

//get请求数据
- (NSMutableArray *)synGet{
    NSString *urlString = @"https://t1.tempo.fan/account/balance/493c6b4ca883ed33b693e6811d66b3feecdb4bdb";
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [mRequest setHTTPMethod:@"get"];
    
    NSData *resultData = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:nil error:nil];
    
    NSString * jsonStr = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    
    return [self zeData:jsonStr];
}

//把返回的结果转化为数组
-(NSMutableArray *)zeData:(NSString *)response{
    NSString *regexStr = @"(?<=\\{|\\{).*?(?=\\}|\\})";
    
    NSArray  * array = [self matchString:response toRegexString:regexStr];
    
    NSMutableArray *mArray1 = [NSMutableArray array];
    for(NSInteger i = 0 ; i < array.count ; i++){
        NSString* string = [[NSString alloc] initWithFormat:@"{%@}", array[i]];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        [mArray1 addObject:dictionary];
    }
    
    return mArray1;
}

- (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < [match numberOfRanges]; i++) {
            if (i == 0) {
                NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
                
                [array addObject:component];
            }
        }
    }
    
    return array;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//设置每个分区显示的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.asset.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * str = @"";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"账户:%@",[self.asset objectAtIndex:indexPath.row]];
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"余额: %@",[self.availableBalance objectAtIndex:indexPath.row]];
    return cell;
}

// 设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

#pragma UITableViewDelegate

//点击单元格触发该方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PopViewController * popView = [[PopViewController alloc] init];
    popView.user = [cell.textLabel.text substringFromIndex:3];
    [self presentViewController:popView animated:YES completion:nil];
}

@end
