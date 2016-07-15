//
//  UserActionsViewController.m
//  PhotoWorld
//
//  Created by Paul on 15.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "UserActionsViewController.h"

static NSString *cellID = @"actionCell";
static NSString *headerID = @"actionHeader";
@interface UserActionsViewController ()

@end

@implementation UserActionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadTableView {
    // _homeTableView
    _actionTableView.dataSource = self;
    _actionTableView.delegate = self;
    _actionTableView.backgroundColor = [UIColor whiteColor];
    [_actionTableView registerNib:[UINib nibWithNibName:@"ActionHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:headerID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 44;
    }
    else
        return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ActionHeaderTableViewCell *header =[tableView dequeueReusableCellWithIdentifier:headerID];
    return  header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    return cell;
}
@end
