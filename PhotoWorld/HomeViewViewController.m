//
//  HomeViewViewController.m
//  PhotoWorld
//
//  Created by Paul on 22.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "HomeViewViewController.h"
#import "MainTableHeaderReusableView.h"
#import "MainTableFooterReusableView.h"

static NSString *homeCellPhotoDetailIdentifier = @"homeCell";
static NSString *userHeaderPhotoDetailIdentifier = @"tableHeaderCell";
static NSString *userFooterPhotoDetailIdentifier = @"tableFooterCell";
@interface HomeViewViewController ()

@end

@implementation HomeViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTableView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"BillabongW00-Regular" size:30]}];
}
- (void)loadTableView {
    _homeTableView.dataSource = self;
    _homeTableView.delegate = self;
    [_homeTableView registerNib:[UINib nibWithNibName:@"MainTableHeaderReusableView" bundle:nil] forCellReuseIdentifier:userHeaderPhotoDetailIdentifier];
    [_homeTableView registerNib:[UINib nibWithNibName:@"MainTableFooterReusableView" bundle:nil] forCellReuseIdentifier:userFooterPhotoDetailIdentifier];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellPhotoDetailIdentifier];
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MainTableHeaderReusableView *header =[tableView dequeueReusableCellWithIdentifier:userHeaderPhotoDetailIdentifier];
    return  header;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MainTableFooterReusableView *footer = [tableView dequeueReusableCellWithIdentifier:userFooterPhotoDetailIdentifier];
    return footer;
}

@end
