//
//  MainTableHeaderReusableView.h
//  PhotoWorld
//
//  Created by Paul on 29.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MainTableHeaderReusableView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *optionButton;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
- (void)dowloadAvatarWithUrl: (NSString *)url;
-(void)setUserNameLabelWithName: (NSString *)name;
- (void)avatarAppear;
@end
