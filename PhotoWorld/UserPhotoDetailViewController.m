//
//  UserPhotoDetailViewController.m
//  PhotoWorld
//
//  Created by Paul on 28.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "UserPhotoDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MainTableHeaderReusableView.h"
#import "MainTableFooterReusableView.h"

static NSString *userCellPhotoDetailIdentifier = @"userDetailPhoto";
static NSString *userHeaderPhotoDetailIdentifier = @"tableHeaderCell";
static NSString *userFooterPhotoDetailIdentifier = @"tableFooterCell";
@interface UserPhotoDetailViewController ()

@end

@implementation UserPhotoDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self dowloadDetailPhoto];
    [self loadTableView];
    [self setNavigationBar];
    [self indicatorStartLoading];
    NSLog(@"%@", [WebServiceManager sharedInstance].allFollowsUserUrlArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) indicatorStartLoading {
    _ind.hidden = NO;
    [_ind startAnimating];
}
- (void) indicatorStopLoading {
    [_ind stopAnimating];
    _ind.hidden = YES;
    _ind.hidden = YES;
    
}

-(void)setNavigationBar {
  //  [UINavigationBar appearance].backIndicatorImage.
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"BillabongW00-Regular" size:20]}];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [self.navigationItem setTitle:@"Фото"];
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
- (void)loadTableView {
    _userDetailPhotoTableView.dataSource = self;
    _userDetailPhotoTableView.delegate = self;
    [_userDetailPhotoTableView registerNib:[UINib nibWithNibName:@"MainTableHeaderReusableView" bundle:nil] forCellReuseIdentifier:userHeaderPhotoDetailIdentifier];
    [_userDetailPhotoTableView registerNib:[UINib nibWithNibName:@"MainTableFooterReusableView" bundle:nil] forCellReuseIdentifier:userFooterPhotoDetailIdentifier];
}
- (void)dowloadDetailPhoto {
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    NSURL *url = [NSURL URLWithString:_detailUrl];
    [downloader downloadImageWithURL: url
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if (image && finished) {
                                   [self setDetailedPhoto:image];
                                  // NSLog(@"Detailed CACHED!!!");
                               }
                           }];
}
- (void) setDetailedPhoto: (UIImage *)photo {
dispatch_async(dispatch_get_main_queue(), ^{
     _photo = photo;
    [self indicatorStopLoading];
    [_userDetailPhotoTableView reloadData];
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  self.view.frame.size.width;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellPhotoDetailIdentifier];
    if (_photo != nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:_photo];
        cell.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);

        cell.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        cell.contentView.layer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.imageView.clipsToBounds = YES;
        [cell.contentView addSubview:imageView];
        // must make method of good recizing image
    }
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
    header.userNameLabel.text = [[WebServiceManager sharedInstance].userDataDictionary valueForKeyPath:@"data.username"];
    [header avatarAppear];
    return  header;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MainTableFooterReusableView *footer = [tableView dequeueReusableCellWithIdentifier:userFooterPhotoDetailIdentifier];
    return footer;
}
@end
