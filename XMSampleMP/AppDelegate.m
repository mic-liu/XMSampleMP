//
//  AppDelegate.m
//  XMSampleMP
//
//  Created by LiuMingchuan on 15/10/26.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "AppDelegate.h"
#import "XMSongListViewController.h"
#import "XMSongPlayerViewController.h"

@interface AppDelegate (){
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    XMSongListViewController *songListVC = [[XMSongListViewController alloc]init];
    [songListVC setTitle:@"歌曲列表"];
    self.songListNav = [[UINavigationController alloc]initWithRootViewController:songListVC];
    self.songListNav.tabBarItem.title = @"歌曲列表";
    self.songListNav.tabBarItem.image = [UIImage imageNamed:@"list"];
    
    XMSongPlayerViewController *songPlayerVC = [[XMSongPlayerViewController alloc]init];
    self.mySongNav = [[UINavigationController alloc]initWithRootViewController:songPlayerVC];
   self.mySongNav.tabBarItem.title = @"我的音乐";
    self.mySongNav.tabBarItem.image = [UIImage imageNamed:@"mysong"];
    self.mainVC = [[UITabBarController alloc]init];
    self.mainVC.delegate = self;
    self.mainVC.viewControllers = @[self.songListNav,self.mySongNav];
    self.window.rootViewController = self.mainVC;
    [self.window addSubview:self.mainVC.view];
    
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}
/**
 *  tab代理
 *
 *  @param tabBarController tab页控制器
 *  @param viewController   选中的控制器
 */
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    switch (tabBarController.selectedIndex) {
        case 0:
            [((UINavigationController*)viewController).topViewController setTitle:@"歌曲列表"];
            break;
        case 1:
            [((UINavigationController*)viewController).topViewController setTitle:@"音乐欣赏"];
            break;
        default:
            break;
    }}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
