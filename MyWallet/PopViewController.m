//
//  PopViewController.m
//  MyWallet
//
//  Created by szp on 2019/6/15.
//  Copyright © 2019 szp. All rights reserved.
//

#import "PopViewController.h"

@interface PopViewController ()

@property (nonatomic , strong) UITextView * tit;
@property (nonatomic , strong) UIButton * backbtn;

@end

@implementation PopViewController

- (UITextView *)tit{
    if(_tit == nil){
        _tit = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
        _tit.font = [UIFont systemFontOfSize:20];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width/2-90, 50, 200, 30)];
        label.text =self.user;
        [_tit addSubview:label];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:_tit.bounds];
        image.image = [UIImage imageNamed:@"back3"];
        [_tit addSubview:image];
        [_tit sendSubviewToBack:image];
    }
    return _tit;
}

- (UIButton *)backbtn{
    if(_backbtn == nil){
        _backbtn = [[UIButton alloc]initWithFrame:CGRectMake(10 , 40 , 40 , 50)];
        [_backbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_backbtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        [_backbtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_backbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        [_backbtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backbtn;
}

//btn点击事件跳转至页面2
-(void)btnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.user = @"SEN:FJU:CMZ0-99QQ";
    //加载数据
    [self setupDatas];
    [self setupSubviews];
    
    [self.view addSubview:self.tit];
    [self.view addSubview:self.backbtn];

}

- (void)setupSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}


//初始化数据
- (void)setupDatas {
    NSArray * dataArray = [self synGet:self.user];
    self.action = [[NSMutableArray alloc]init];
    self.amount = [[NSMutableArray alloc]init];;
    self.createTime = [[NSMutableArray alloc]init];
    for(NSInteger i = 0 ; i < dataArray.count - 1; i++){
        [self.action addObject:dataArray[i][@"action"]];
        [self.amount addObject:dataArray[i][@"amount"]];
        [self.createTime addObject:dataArray[i][@"tx"][@"createTime"]];
    }
}


//请求数据
- (NSArray *)synGet:(NSString *)user{
    NSString *urlString =  [@"https://t1.tempo.fan/ledger/493c6b4ca883ed33b693e6811d66b3feecdb4bdb/" stringByAppendingString:user];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    //设置方法体
    [mRequest setHTTPMethod:@"get"];
    
    NSData *resultData = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:nil error:nil];
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingAllowFragments error:nil];
    
    return dictionary[@"notes"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.createTime.count;
}

//设置每个分区显示的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * str = [[NSString alloc] initWithFormat:@"%@", self.createTime[indexPath.row]];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    if (![[self.action objectAtIndex:indexPath.row] isEqualToString:@"in"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"类型: 收入"];
    }else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"类型: 支出"];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"余额: %@",[self.amount objectAtIndex:indexPath.row]];
    
    return cell;
}

//由于表格的样式设置成plain样式,但是不能说明当前的表格不显示分区
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[NSString alloc] initWithFormat:@"%@", self.createTime[section]];
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

@end
