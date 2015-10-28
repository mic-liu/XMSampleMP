//
//  AppDelegate.h
//  XMSampleMP
//
//  Created by LiuMingchuan on 15/10/26.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
/**
 *  歌曲列表根视图
 */
@property (strong,nonatomic)UINavigationController *songListNav;
/**
 *  歌曲播放根视图
 */
@property (strong,nonatomic)UINavigationController *mySongNav;
/**
 *  主tab页
 */
@property (strong,nonatomic)UITabBarController *mainVC;

@end

