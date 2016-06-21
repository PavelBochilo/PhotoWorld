//
//  AppDelegate.h
//  PhotoWorld
//
//  Created by Paul on 16.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INSTAGRAM_AUTHURL                               @"https://api.instagram.com/oauth/authorize/"
#define INSTAGRAM_APIURl                                @"https://api.instagram.com/v1/users/"
#define INSTAGRAM_CLIENT_ID                             @"f2350bca52ec4aef9f0019a55119942f"
#define INSTAGRAM_CLIENTSERCRET                         @"00e28302f5bf41ceb5288379c41b74e1"
#define INSTAGRAM_REDIRECT_URI                          @"https://instagram.com/"
#define INSTAGRAM_ACCESS_TOKEN                          @"access_token"
#define INSTAGRAM_SCOPE                                 @"likes+comments+relationships"
#define INSTAGRAM_API_USER                              @"https://api.instagram.com/v1/users/{user-id}/?access_token=ACCESS-TOKEN"
#define INSTAGRAM_MEDIA                                 @"https://api.instagram.com/v1/media/{media-id}?access_token=ACCESS-TOKEN"
#define INSTAGRAM_API_SELF                              @"https://api.instagram.com/v1/users/self/?access_token=ACCESS-TOKEN"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

