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
#import "UserCollectionReusableViewCommonFooter.h"

static NSString *commonFooter = @"UserCollectionReusableViewCommonFooter";
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
    [self setCollectionViewData];
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
- (void)setCollectionViewData {
    _standartFlowlayout = true;
    [_userCollectionView setDataSource:self];
    [_userCollectionView setDelegate:self];
    _userCollectionView.backgroundColor = [UIColor whiteColor];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"userPhotodetail"]) {
        NSIndexPath *indexPath = [[_userCollectionView indexPathsForSelectedItems] lastObject];
        if (_standartFlowlayout == false) {
            NSInteger pathTwo = indexPath.section - 1;
            NSString *stringTwo = [WebServiceManager sharedInstance].userStandartPhotoUrlArray[pathTwo];
            if ([segue.destinationViewController isKindOfClass:[UserPhotoDetailViewController class]]) {
                UserPhotoDetailViewController * imageVC = [[UserPhotoDetailViewController alloc] init];
                imageVC = segue.destinationViewController;
                imageVC.detailUrl = stringTwo;
            }
        } else {
        NSInteger path = indexPath.row;
        NSString *string = [WebServiceManager sharedInstance].userStandartPhotoUrlArray[path];        
        if ([segue.destinationViewController isKindOfClass:[UserPhotoDetailViewController class]]) {
            UserPhotoDetailViewController * imageVC = [[UserPhotoDetailViewController alloc] init];
            imageVC = segue.destinationViewController;
            imageVC.detailUrl = string;
        }
    }
}
}
- (void) registerNibForHeader {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([UserHeaderCollectionReusableView class]) bundle:[NSBundle mainBundle]];
    [_userCollectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    UINib *nib1 = [UINib nibWithNibName:NSStringFromClass([UserCollectionViewCommonHeader class]) bundle:[NSBundle mainBundle]];
    [_userCollectionView registerNib:nib1 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:commonHeader];
    UINib * nib2 = [UINib nibWithNibName:NSStringFromClass([UserCollectionReusableViewCommonFooter class]) bundle:[NSBundle mainBundle]];
    [_userCollectionView registerNib:nib2 forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:commonFooter];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *reuseID = headerIdentifier;
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
            [header.thirdButton addTarget:nil action:@selector(moveToGeoLocation) forControlEvents:UIControlEventTouchUpInside];
            [header.secondButton addTarget:nil action:@selector(changeStyle) forControlEvents:UIControlEventTouchUpInside];
            [self addTapToLabel:header.media withLabelIndex:1];
            [self addTapToLabel:header.followedBy withLabelIndex:3]; //follows
            [self addTapToLabel:header.follows withLabelIndex:2]; //followed_by
        }
        return view;
    }
    }
    if (indexPath.section > 0 && _standartFlowlayout == false) {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section > 0) {
        UICollectionReusableView * viewCommon = [_userCollectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:commonHeader forIndexPath:indexPath];
        UserCollectionViewCommonHeader *commonHeader = (UserCollectionViewCommonHeader *)viewCommon;
        [commonHeader avatarAppear];
        [commonHeader setUserNameLabelWithName:[[WebServiceManager sharedInstance].userDataDictionary valueForKeyPath:@"data.username"]];
        return viewCommon;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && _standartFlowlayout == false && indexPath.section > 0) {
        UICollectionReusableView *simpleFooter = [_userCollectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:commonFooter forIndexPath:indexPath];
    //    UserCollectionReusableViewCommonFooter *footer = (UserCollectionReusableViewCommonFooter *)commonFooter;
        return simpleFooter;
    }
    }

    return  nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_standartFlowlayout == false) {
        if (indexPath.section == 0) {
            return  CGSizeZero;
        } else
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width);
    } else {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 3.0 - 1;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
    }
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (_standartFlowlayout == false) {
        if (section == 0) {
            return CGSizeZero;
        } else
        return CGSizeMake(self.view.frame.size.width, 44);
    } else
        return CGSizeZero;
}
- (void)changeStyleToStandart {
        _standartFlowlayout = true;
[_userCollectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [_userCollectionView reloadData];
}
- (BOOL) scrollViewShouldScrollToTop:(UIScrollView*) scrollView {
    if (scrollView == _userCollectionView) {
        return YES;
    }
    return NO;
}
- (void)changeStyle {
    _standartFlowlayout = false;
    [_userCollectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [_userCollectionView reloadData];
    [_userCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]];
    [_userCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]]];
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
- (void)moveToGeoLocation {
    [self performSegueWithIdentifier:@"userGeo" sender:nil];
}

//-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSMutableArray* elementsInRect = [NSMutableArray array];
//    
//    //iterate over all cells in this collection
//    for(NSUInteger i = 0; i < [_userCollectionView numberOfSections]; i++)
//    {
//        for(NSUInteger j = 0; j < [_userCollectionView numberOfItemsInSection:i]; j++)
//        {
//            
//            //this is the cell at row j in section i
//            CGRect cellFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
//            
//            //see if the collection view needs this cell
//            if(CGRectIntersectsRect(cellFrame, rect))
//            {
//                //create the attributes object
//                NSIndexPath* indexPath = [NSIndexPath indexPathForRow:j inSection:i];
//                UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//                
//                //set the frame for this attributes object
//                attr.frame = cellFrame;
//                [elementsInRect addObject:attr];
//            }
//        }
//    }
//    
//    return elementsInRect;
//}
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
        return [WebServiceManager sharedInstance].userPhotoUrlArray.count + 1;
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
        if (indexPath.section == 0) {
            return nil;
        }
        if (indexPath.section >= 1) {
            [cell dowloadUserStandartResolutionPhotoWithUrl:[WebServiceManager sharedInstance].userStandartPhotoUrlArray[indexPath.section - 1]];
            //            NSLog(@"%@, %lu",cell, indexPath.section);
            return cell;
        }
    } else
    [cell setMyImageForKey:indexPath.row];
     return cell;
}
@end
