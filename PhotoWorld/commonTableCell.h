//
//  commonTableCell.h
//  PhotoWorld
//
//  Created by Paul on 04.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface commonTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIButton *followsButton;
- (void)dowloadAvatarWithUrl: (NSString *)url;

@end
