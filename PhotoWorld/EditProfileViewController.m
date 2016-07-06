//
//  EditProfileViewController.m
//  PhotoWorld
//
//  Created by Paul on 01.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "EditProfileViewController.h"
#import "WebServiceManager.h"

static NSString *cellId = @"EditTableViewCell";
@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self loadTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)loadTableView {
    _editTableView.delegate = self;
    _editTableView.dataSource = self;
    [_editTableView registerNib:[UINib nibWithNibName:@"EditTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
    _editTableView.backgroundColor = [UIColor whiteColor];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIImageView *image = [[UIImageView alloc] init];
    image.backgroundColor = [UIColor whiteColor];
    return image;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 355;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    [cell setUseravatar];
    [cell setUserDataWithName];
    return cell;
}
-(void)setNavigationBar {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"BillabongW00-Regular" size:30]}];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [self.navigationItem setTitle:@"Edit"];
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
