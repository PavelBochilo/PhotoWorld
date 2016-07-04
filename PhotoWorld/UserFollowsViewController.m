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

static NSString *followsCell = @"commonTableCell";
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

- (void)loadTableView {
    _userFollowsTableView.delegate = self;
    _userFollowsTableView.dataSource = self;
[_userFollowsTableView registerNib:[UINib nibWithNibName:@"commonTableCell" bundle:nil] forCellReuseIdentifier:followsCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    commonTableCell *cell = [_userFollowsTableView dequeueReusableCellWithIdentifier:followsCell];
    
    return cell;
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
