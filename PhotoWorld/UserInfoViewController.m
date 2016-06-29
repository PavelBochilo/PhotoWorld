//
//  UserInfoViewController.m
//  PhotoWorld
//
//  Created by Paul on 20.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "UserInfoViewController.h"
#import "WebServiceManager.h"
#import "UserCollectionViewCell.h"
#import "UserPhotoDetailViewController.h"




static NSString *CellIdentifier = @"userView";
static NSString *headerIdentifier = @"userHeader";

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_userCollectionView setDataSource:self];
    [_userCollectionView setDelegate:self];
    [self registerNibForHeader];
    [self indicatorStartLoading];
    [[WebServiceManager sharedInstance] sendPOSTRequestUserInfo:[WebServiceManager sharedInstance].myAccessToken andMyID:[WebServiceManager sharedInstance].mySessionID];
    [self startNoticicationProcess];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self collectionViewLayout];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"userPhotodetail"]) {
        NSIndexPath *indexPath = [[_userCollectionView indexPathsForSelectedItems] lastObject];
        NSInteger path = indexPath.row;
        NSString *string = [WebServiceManager sharedInstance].userStandartPhotoUrlArray[path];
        
        if ([segue.destinationViewController isKindOfClass:[UserPhotoDetailViewController class]]) {
            UserPhotoDetailViewController * imageVC = [[UserPhotoDetailViewController alloc] init];
            imageVC = segue.destinationViewController;
            imageVC.detailUrl = string;
        }
    }
}

- (void) registerNibForHeader {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([UserHeaderCollectionReusableView class]) bundle:[NSBundle mainBundle]];
    [_userCollectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseID = headerIdentifier;
    
    UICollectionReusableView *view = [_userCollectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseID forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UserHeaderCollectionReusableView *header = (UserHeaderCollectionReusableView *)view;
        if ([WebServiceManager sharedInstance].userDataDictionary != 0) {
            [header avatarAppear];
            NSDictionary *dict = [[WebServiceManager sharedInstance].userDataDictionary valueForKeyPath:@"data.counts"];
            [header setDataBio:[[WebServiceManager sharedInstance].userDataDictionary valueForKeyPath:@"data.bio"] setFullName:[[WebServiceManager sharedInstance].userDataDictionary valueForKeyPath:@"data.full_name"] setMedia:[[dict valueForKey:@"media"]intValue] setFollows:[[dict valueForKey:@"follows"]intValue] setFoolowedBy:[[dict valueForKey:@"followed_by"]intValue] ];
            [header setButtonCorners];
        }
    }
    return view;
}

- (void) collectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        float cellWidth = screenWidth / 3.0;
        CGSize size = CGSizeMake(cellWidth, cellWidth);
    flowLayout.itemSize = size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 240);
    flowLayout.sectionInset = UIEdgeInsetsZero; // after headerReferenceSize always
    
    _userCollectionView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _userCollectionView.backgroundColor = [UIColor whiteColor];
    [_userCollectionView setCollectionViewLayout:flowLayout];
    [_userCollectionView reloadData];
    
}

- (void)startNoticicationProcess {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationStartLoadingUserData)
                                                 name:@"userNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationStartLoadingMedia)
                                                 name:@"userMediaNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setUserData {

}

- (void) indicatorStartLoading {
    _activityIndicator.hidden = NO;
[_activityIndicator startAnimating];
}

- (void) indicatorStopLoading {
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
    _userLoadingScreen.hidden = YES;

}

- (void)notificationStartLoadingUserData {
    [[WebServiceManager sharedInstance] sendRequestForUserMedia:[WebServiceManager sharedInstance].myAccessToken andMyID:[WebServiceManager sharedInstance].mySessionID];
}

- (void) notificationStartLoadingMedia {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.navigationItem.title = [[WebServiceManager sharedInstance].userDataDictionary valueForKeyPath:@"data.username"];
        [self performSelector:@selector(reloadAllDataCell) withObject:nil afterDelay:1];
    
    });
}

- (void) reloadAllDataCell {
[_userCollectionView reloadData];
    [self indicatorStopLoading];
}

- (void) viewWillDisappear:(BOOL)animated {
[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([WebServiceManager sharedInstance].userPhotoUrlArray != 0) {
        return [WebServiceManager sharedInstance].userPhotoUrlArray.count;
    } else
    return 1;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
UserCollectionViewCell *cell = (UserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell setMyImageForKey:indexPath.row];
//    NSLog(@"Cell------- %@", cell);
    return cell;
}


@end
