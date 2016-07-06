//
//  UserFollowsViewController.m
//  PhotoWorld
//
//  Created by Paul on 04.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "UserFollowsViewController.h"
#import "UserInfoViewController.h"
#import "WebServiceManager.h"
#import "SearchBarTableViewHeader.h"

static NSString *followsCell = @"commonTableCell";
static NSString *searchheader = @"SearchBarTableViewHeader";
@interface UserFollowsViewController ()


@end

@implementation UserFollowsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self loadTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [WebServiceManager sharedInstance].followsIDArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)loadTableView {
    _userFollowsTableView.delegate = self;
    _userFollowsTableView.dataSource = self;
[_userFollowsTableView registerNib:[UINib nibWithNibName:@"commonTableCell" bundle:nil] forCellReuseIdentifier:followsCell];
[_userFollowsTableView registerNib:[UINib nibWithNibName:@"SearchBarTableViewHeader" bundle:nil] forCellReuseIdentifier:searchheader];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    commonTableCell *cell = [_userFollowsTableView dequeueReusableCellWithIdentifier:followsCell];
    cell.userName.text = [WebServiceManager sharedInstance].followsUserNameArray[indexPath.row];
    [cell dowloadAvatarWithUrl:[WebServiceManager sharedInstance].followsAvatarUrlArray[indexPath.row]];
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SearchBarTableViewHeader *header = [tableView dequeueReusableCellWithIdentifier:searchheader];
    header.separatorInset = UIEdgeInsetsZero;
    return header;
}

-(void)setNavigationBar {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"BillabongW00-Regular" size:30]}];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [self.navigationItem setTitle:@"follows"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@""
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(lastViewController)];
    item.image = [UIImage imageNamed:@"back"];
    item.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
}
- (void)lastViewController {
[self.navigationController popViewControllerAnimated:YES];
}


@end
