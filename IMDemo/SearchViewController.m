//
//  SearchViewController.m
//  IMDemo
//
//  Created by 51jk on 2016/12/6.
//  Copyright © 2016年 田耀琦. All rights reserved.
//

#import "SearchViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>
@interface SearchViewController () <AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>
{
    AMapSearchAPI *_searchAPI;
     UITextField *_searchTF;
    UITableView *_tableView;
    NSMutableArray *_searchArr;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSearchUI];
}
#pragma mark --- AMapSearchKit 检索-----
- (void)SearchAPI {
    [_searchTF resignFirstResponder];
    [AMapServices sharedServices].apiKey = @"f4dea3441fc86f6e13af52cfdae1e266";
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = _searchTF.text;
    request.city                = @"上海";
    //    request.types               = @"高等院校";
    request.requireExtension    = YES;
    
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    
    [_searchAPI AMapPOIKeywordsSearch:request];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    NSLog(@" === %@",response.suggestion.cities);
    _searchArr = [NSMutableArray array];
    for (AMapPOI *poi in response.pois ) {
        NSString *name = poi.name;
        NSLog(@"name == %@",name);
        CLLocationCoordinate2D coordinate =
        CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        //用标注显示
        MAPointAnnotation *pointAnn = [[MAPointAnnotation alloc] init];
        pointAnn.coordinate = coordinate;
        pointAnn.title = name;
        pointAnn.subtitle = poi.address;
        [_searchArr addObject:poi];
    }
    [self setUpTableView];
}
- (void)setSearchUI {
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(15, 70, 250, 44)];
    _searchTF.placeholder = @"请输入关键词";
    _searchTF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_searchTF];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(270, 70, 60, 44);
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(SearchAPI) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:searchBtn];
}
#pragma mark ------ UITableViewDataSouce -------
- (void)setUpTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 115, App_WIDTH - 10, App_HEIGHT - 160) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _searchArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identify = @"search";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    AMapPOI *poi = _searchArr[indexPath.row];
    cell.textLabel.text = poi.name;
    return  cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AMapPOI *poi = _searchArr[indexPath.row];
    self.block(poi);
    [self.navigationController popViewControllerAnimated:NO];
}

@end
