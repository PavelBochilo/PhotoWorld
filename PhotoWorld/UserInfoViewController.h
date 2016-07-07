//
//  UserInfoViewController.h
//  PhotoWorld
//
//  Created by Paul on 20.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserHeaderCollectionReusableView.h"



@interface UserInfoViewController : UIViewController <NSURLSessionDelegate, NSURLSessionDataDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (strong, nonatomic) NSDictionary *userDataDictionary;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UICollectionView *userCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *userLoadingScreen;
@property (nonatomic) BOOL standartFlowlayout;
- (void)scrollToPosition;
- (void)addTapToLabel: (UILabel *)label withLabelIndex: (int)index;
- (IBAction)paramButton:(id)sender;
@end
