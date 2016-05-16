//
//  RunMapViewController.m
//  colorRun
//
//  Created by engine on 15/11/17.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "RunMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "RDVTabBarController.h"
@interface RunMapViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@end

@implementation RunMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    self.navigationItem.title=@"准备跑步";
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor] ;
    self.navigationController.navigationItem.leftBarButtonItem.title=@"" ;
    [self.view addSubview:_mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [[self rdv_tabBarController] setTabBarHidden:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
