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
#import "UserCollectionViewCommonHeader.h"

static NSString *commonHeader = @"UserCollectionViewCommonHeader";
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
    _userCollectionView.backgroundColor = [UIColor whiteColor];
    [self registerNibForHeader];
    [self indicatorStartLoading];
    [[WebServiceManager sharedInstance] sendRequestForUserMedia:[WebServiceManager sharedInstance].myAccessToken andMyID:[WebServiceManager sharedInstance].mySessionID];    
    [self startNoticicationProcess];
  // [self collectionViewLayout];
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
    UINib *nib1 = [UINib nibWithNibName:NSStringFromClass([UserCollectionViewCommonHeader class]) bundle:[NSBundle mainBundle]];
    [_userCollectionView registerNib:nib1 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:commonHeader];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseID = headerIdentifier;
    if (indexPath.section == 0) {
    UICollectionReusableView *view = [_userCollectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseID forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section == 0) {
        UserHeaderCollectionReusableView *header = (UserHeaderCollectionReusableView *)view;
        if ([WebServiceManager sharedInstance].userDataDictionary != 0) {
            [header avatarAppear];
            header.backgroundColor = [UIColor whiteColor];
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
        return view;
    }
    }
 UICollectionReusableView * viewCommon = [_userCollectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:commonHeader forIndexPath:indexPath];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UserCollectionViewCommonHeader *commonHeader = (UserCollectionViewCommonHeader *)viewCommon;
        [commonHeader avatarAppear];
        [commonHeader setUserNameLabelWithName:[[WebServiceManager sharedInstance].userDataDictionary valueForKeyPath:@"data.username"]];
    }
    return viewCommon;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_standartFlowlayout == false) {
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.0 - 1;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
     if (_standartFlowlayout == false) {
         if (section == 0) {
             return CGSizeMake(self.view.frame.size.width, 240);
         } else {
         return CGSizeMake(self.view.frame.size.width, 44);
         }
     }
         return CGSizeMake(self.view.frame.size.width, 240);
 }
- (void)changeStyleToStandart {
        _standartFlowlayout = true;
    [_userCollectionView reloadData];
}
- (void)changeStyle {
    _standartFlowlayout = false;
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

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* elementsInRect = [NSMutableArray array];
    
    //iterate over all cells in this collection
    for(NSUInteger i = 0; i < [_userCollectionView numberOfSections]; i++)
    {
        for(NSUInteger j = 0; j < [_userCollectionView numberOfItemsInSection:i]; j++)
        {
            
            //this is the cell at row j in section i
            CGRect cellFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
            
            //see if the collection view needs this cell
            if(CGRectIntersectsRect(cellFrame, rect))
            {
                //create the attributes object
                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                //set the frame for this attributes object
                attr.frame = cellFrame;
                [elementsInRect addObject:attr];
            }
        }
    }
    
    return elementsInRect;
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
}

- (void) viewWillDisappear:(BOOL)animated {
[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([WebServiceManager sharedInstance].userPhotoUrlArray && _standartFlowlayout == false) {
        return [WebServiceManager sharedInstance].userPhotoUrlArray.count;
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([WebServiceManager sharedInstance].userPhotoUrlArray && _standartFlowlayout == true) {
        return [WebServiceManager sharedInstance].userPhotoUrlArray.count;
    } else
        return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
UserCollectionViewCell *cell = (UserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (_standartFlowlayout == false) {
        [cell dowloadUserStandartResolutionPhotoWithUrl:[WebServiceManager sharedInstance].userStandartPhotoUrlArray[indexPath.section]];
        return cell;
    } else {
    [cell setMyImageForKey:indexPath.row];
     return cell;
    }
}

@end
