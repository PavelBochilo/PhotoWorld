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
    _standartFlowlayout = true;
    [_userCollectionView setDataSource:self];
    [_userCollectionView setDelegate:self];
    [self registerNibForHeader];
    [self indicatorStartLoading];
    [[WebServiceManager sharedInstance] sendRequestForUserMedia:[WebServiceManager sharedInstance].myAccessToken andMyID:[WebServiceManager sharedInstance].mySessionID];    
    [self startNoticicationProcess];
    [self collectionViewLayout];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
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
            [header.redactionButton addTarget:nil action:@selector(editProfile) forControlEvents:UIControlEventTouchUpInside];
            [header.firstButton addTarget:nil action:@selector(changeStyleToStandart) forControlEvents:UIControlEventTouchUpInside];
            [header.secondButton addTarget:nil action:@selector(changeStyle) forControlEvents:UIControlEventTouchUpInside];
            [self addTapToLabel:header.media withLabelIndex:1];
            [self addTapToLabel:header.followedBy withLabelIndex:3]; //follows
            [self addTapToLabel:header.follows withLabelIndex:2]; //followed_by
        }
    }
    return view;
}
- (void)changeStyleToStandart {
        _standartFlowlayout = true;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.0 - 1;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    flowLayout.itemSize = size;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 240);
    flowLayout.sectionInset = UIEdgeInsetsZero; // after headerReferenceSize always
    _userCollectionView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _userCollectionView.backgroundColor = [UIColor whiteColor];
    [_userCollectionView setCollectionViewLayout:flowLayout];
    [_userCollectionView reloadData];
}
- (void)changeStyle {
    _standartFlowlayout = false;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGSize size = CGSizeMake(screenWidth, screenWidth);
    flowLayout.itemSize = size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 240);
    flowLayout.sectionInset = UIEdgeInsetsZero; // after headerReferenceSize always
    _userCollectionView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _userCollectionView.backgroundColor = [UIColor whiteColor];
    [_userCollectionView setCollectionViewLayout:flowLayout];
    UIScrollView* v = (UIScrollView*) _userCollectionView ;
    float width = CGRectGetWidth(_userCollectionView.frame);
    CGRect toVisible = CGRectMake(0, 0, width, self.view.frame.size.height);
    [v scrollRectToVisible:toVisible animated:NO];
    [_userCollectionView reloadData];
}
- (void)addTapToLabel: (UILabel *)label withLabelIndex: (int)index {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer setNumberOfTapsRequired:1];
    [label addGestureRecognizer:tapRecognizer];
    label.userInteractionEnabled = YES;
    switch (index) {
        case 1: {
            [tapRecognizer addTarget:self action:@selector(scrollToPosition)];
            break;}
        case 2: {
            [tapRecognizer addTarget:self action:@selector(moveTouserFollowedBy)];
            break;}
        case 3: {
            [tapRecognizer addTarget:self action:@selector(moveToUserFollows)];
            break;}
    }
}

- (IBAction)paramButton:(id)sender {
}

- (void)scrollToPosition {
    UIScrollView* v = (UIScrollView*) _userCollectionView ;
    float width = CGRectGetWidth(_userCollectionView.frame);
    float height = 200;
    float newPosition = _userCollectionView.contentOffset.y+height;
    CGRect toVisible = CGRectMake(0, newPosition, width, self.view.frame.size.height);
    [v scrollRectToVisible:toVisible animated:YES];

}
- (void)moveTouserFollowedBy {
    [self performSegueWithIdentifier:@"userFollowedBy" sender:nil];
}
- (void)moveToUserFollows {
[self performSegueWithIdentifier:@"userFollows" sender:nil];
}
- (void)editProfile {
    [self performSegueWithIdentifier:@"edit" sender:nil];
    
}

- (void) collectionViewLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        float cellWidth = screenWidth / 3.0 - 1;
        CGSize size = CGSizeMake(cellWidth, cellWidth);
        flowLayout.itemSize = size;
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 240);
        flowLayout.sectionInset = UIEdgeInsetsZero; // after headerReferenceSize always
        _userCollectionView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        _userCollectionView.backgroundColor = [UIColor whiteColor];
        [_userCollectionView setCollectionViewLayout:flowLayout];
}
- (void)startNoticicationProcess {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationStartLoadingMedia)
                                                 name:@"userMediaNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) indicatorStartLoading {
    _activityIndicator.hidden = NO;
    _userLoadingScreen.hidden = NO;
[_activityIndicator startAnimating];
}

- (void) indicatorStopLoading {
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
    _userLoadingScreen.hidden = YES;
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
NSLog(@"standartUrlarray== %@", [WebServiceManager sharedInstance].userStandartPhotoUrlArray);
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
    if (_standartFlowlayout == false) {
        [cell dowloadUserStandartResolutionPhotoWithUrl:[WebServiceManager sharedInstance].userStandartPhotoUrlArray[indexPath.row]];
        return cell;
    } else {
    [cell setMyImageForKey:indexPath.row];
     return cell;
    }
}

@end
