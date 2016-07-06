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
static NSString *searchheader = @"SearchBarTableViewHeader";
@interface UserFolloweByViewController ()

@end

@implementation UserFolloweByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self loadTableView];
    [self sendRequestForUserFollows:[WebServiceManager sharedInstance].myAccessToken andMyID:[WebServiceManager sharedInstance].mySessionID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) sendRequestForUserFollows: (NSString *) myToken andMyID: (NSString *) myID {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/followed-by?access_token=%@", myToken]]];
    [requestData setHTTPMethod:@"GET"];
    NSURLSessionDataTask *getDataTask = [session dataTaskWithRequest:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *followsDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        dispatch_sync(dispatch_get_main_queue(), ^{
            _followedByIDArray = [followsDict valueForKeyPath:@"data.id"];
            _followedByAvatarUrlArray = [followsDict valueForKeyPath:@"data.profile_picture"];
            _followedByUserNameArray = [followsDict valueForKeyPath:@"data.username"];
            _followedByFullName = [followsDict valueForKeyPath:@"data.full_name"];
            //        NSLog(@"ID== %@", followsDict);
            [self reloadDataTableView];
        });
    }];
    
    [getDataTask resume];
}

- (void)reloadDataTableView {
    [_userFollowedByTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _followedByIDArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SearchBarTableViewHeader *header = [tableView dequeueReusableCellWithIdentifier:searchheader];
    header.separatorInset = UIEdgeInsetsZero;
    return header;
}
- (void)loadTableView {
    _userFollowedByTableView.delegate = self;
    _userFollowedByTableView.dataSource = self;
    [_userFollowedByTableView registerNib:[UINib nibWithNibName:@"commonTableCell" bundle:nil] forCellReuseIdentifier:followedByCell];
    [_userFollowedByTableView registerNib:[UINib nibWithNibName:@"SearchBarTableViewHeader" bundle:nil] forCellReuseIdentifier:searchheader];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    commonTableCell *cell = [_userFollowedByTableView dequeueReusableCellWithIdentifier:followedByCell];
    cell.userName.text = _followedByUserNameArray[indexPath.row];
    [cell dowloadAvatarWithUrl:_followedByAvatarUrlArray[indexPath.row]];
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
