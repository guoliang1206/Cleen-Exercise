//
//  ViewController.m
//  Cleen-Exercise
//
//  Created by os x on 17/1/4.
//  Copyright © 2017年 Guo. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "AFNetWorking.h"
#import "MBProgressHUD.h"

#define DATA_SOURCE_URL @"http://thoughtworks-ios.herokuapp.com/facts.json"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation ViewController

/**
 *  lazy loading init
 */
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (MBProgressHUD *)HUD{
    if (!_HUD) {
        _HUD = [[MBProgressHUD alloc] init];
        [self.view addSubview:_HUD];
    }
    return _HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"About Canada";
    self.automaticallyAdjustsScrollViewInsets = false;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshAction:)];
    self.HUD.labelText = @"loading...";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    self.tableView.estimatedRowHeight = 104.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self requestDataFromRemote];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshAction:(UIBarButtonItem *)item{
    [self requestDataFromRemote];
}

/**
 *  Request data 
 */
- (void)requestDataFromRemote{
    
    [self.HUD show:YES];


    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer     = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer    = [AFHTTPResponseSerializer serializer];
    
    [sessionManager GET:DATA_SOURCE_URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        [self parseDataWithDic:dic];
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.HUD hide:YES afterDelay:1.3];
    }];
}

/**
 *  parse json data and feed local dataSource
 *
 *  @param data json data
 */
- (void)parseDataWithDic:(NSDictionary *)data{
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:[data objectForKey:@"rows"]];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.HUD hide:YES afterDelay:1.3];
        [self.tableView reloadData];
    });

}


/**
 *  UITableViewDataSouce && UITableViewDelegate
 */
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    NSDictionary *model = self.dataSource[indexPath.row];
    [cell setCellWithModel:model];
    
    return cell;
}









@end
