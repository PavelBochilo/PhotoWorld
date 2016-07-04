//
//  UserFolloweByViewController.m
//  PhotoWorld
//
//  Created by Paul on 04.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "UserFolloweByViewController.h"
#import "UserInfoViewController.h"
#import "WebServiceManager.h"

static NSString *followedByCell = @"commonTableCell";
@interface UserFolloweByViewController ()

@end

@implementation UserFolloweByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self loadTableView];
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
    _userFollowedByTableView.delegate = self;
    _userFollowedByTableView.dataSource = self;
    [_userFollowedByTableView registerNib:[UINib nibWithNibName:@"commonTableCell" bundle:nil] forCellReuseIdentifier:followedByCell];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    commonTableCell *cell = [_userFollowedByTableView dequeueReusableCellWithIdentifier:followedByCell];
    
    return cell;
}

-(void)setNavigationBar {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"BillabongW00-Regular" size:30]}];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [self.navigationItem setTitle:@"followed by"];
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
