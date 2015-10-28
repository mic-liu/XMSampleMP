//
//  XMSongListViewController.h
//  XMSampleMP
//
//  Created by LiuMingchuan on 15/10/27.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMSongListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *songList;

@end
