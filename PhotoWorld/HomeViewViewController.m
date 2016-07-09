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
   // _homeTableView
    _homeTableView.dataSource = self;
    _homeTableView.delegate = self;
    [_homeTableView registerNib:[UINib nibWithNibName:@"MainTableHeaderReusableView" bundle:nil] forCellReuseIdentifier:userHeaderPhotoDetailIdentifier];
    [_homeTableView registerNib:[UINib nibWithNibName:@"MainTableFooterReusableView" bundle:nil] forCellReuseIdentifier:userFooterPhotoDetailIdentifier];
}
- (void)reloadTableView {
    [_homeTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [WebServiceManager sharedInstance].allFollowsUserUrlArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_rowHeights != 0) {
//        NSInteger x = indexPath.row;
//        return  x;
//    }
    return self.view.frame.size.width;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellPhotoDetailIdentifier];
    NSMutableDictionary *indexDict = [WebServiceManager sharedInstance].allFollowsUserUrlArray[indexPath.section];
    if ([[indexDict valueForKey:@"type"] isEqualToString:@"video"]) {
        dispatch_async(dispatch_get_main_queue(),  ^{
        cell.contentView.layer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        _playerCellVideo = [AVPlayer playerWithURL:[NSURL URLWithString:[indexDict valueForKey:@"video_url"]]];
        _playerCellVideoLayer = [AVPlayerLayer playerLayerWithPlayer:_playerCellVideo];
        _playerCellVideoLayer.frame = cell.contentView.layer.bounds;
        [cell.contentView.layer addSublayer:_playerCellVideoLayer];
        [_playerCellVideo play];
        });    
    } else {
    UIImageView *imageView = [[UIImageView alloc] init];
    NSString * urlString = [[[WebServiceManager sharedInstance].allFollowsUserUrlArray objectAtIndex:indexPath.section] objectForKey:@"url"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]
                 placeholderImage:[UIImage imageNamed:@"classic.jpg"]
                          options:0
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self resizeImage:image];

    }];
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    cell.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    cell.contentView.layer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageView];
    }
    return cell;
}

-(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = image.size.height;
    float maxWidth = self.view.frame.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithData:imageData];
    
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MainTableHeaderReusableView *header =[tableView dequeueReusableCellWithIdentifier:userHeaderPhotoDetailIdentifier];
    NSString *stringUrl = [[[WebServiceManager sharedInstance].allFollowsUserUrlArray objectAtIndex:section] objectForKey:@"avatar"];
    NSString *nameString = [[[WebServiceManager sharedInstance].allFollowsUserUrlArray objectAtIndex:section] objectForKey:@"name"];
    [header dowloadAvatarWithUrl:stringUrl];
    [header setUserNameLabelWithName:nameString];
    return  header;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MainTableFooterReusableView *footer = [tableView dequeueReusableCellWithIdentifier:userFooterPhotoDetailIdentifier];
    return footer;
}
- (IBAction)directButton:(id)sender {
}
@end
