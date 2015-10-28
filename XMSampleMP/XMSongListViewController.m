//
//  XMSongListViewController.m
//  XMSampleMP
//
//  Created by LiuMingchuan on 15/10/27.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "XMSongListViewController.h"
#import "AppDelegate.h"
#import "XMSong.h"
#import "XMSongPlayerViewController.h"

@interface XMSongListViewController (){
    NSMutableArray *songListArray;
    
}

@end

@implementation XMSongListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [super viewDidLoad];
    XMSong *song = [[XMSong alloc]init];
    song.songName = @"NotReadyToMakeNice";
    song.songAuthor = @"Dixie Chicks";
    song.songAlbum = @"The Essential Dixie Chicks";
    song.songAlbumCover = @"AlbumCover";
    song.songLyrics = [self makeLyric];
    songListArray = [[NSMutableArray alloc]initWithObjects:song, nil];
    
    self.songList.delegate = self;
    self.songList.dataSource = self;
    
    // Do any additional setup after loading the view from its nib.
}

/**
 *  读取歌词文件
 *
 *  @return 歌词词典
 */
- (NSMutableDictionary *)makeLyric {
    NSMutableDictionary *lyricDic = [[NSMutableDictionary alloc]init];
    //读取歌词
    NSString *lyric = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"lyric" ofType:@""] encoding:NSUTF8StringEncoding error:nil];
    NSArray *lyricArray = [lyric componentsSeparatedByString:@"\n"];
    for (NSString *ly in lyricArray) {
        NSArray *oneLineStr = [ly componentsSeparatedByString:@"]"];
        if ([oneLineStr count]>1) {
            NSString *key = [oneLineStr[0] substringWithRange:NSMakeRange(1, 5)];//时间Key
            NSString *value = oneLineStr[1];//歌词
            [lyricDic setValue:value forKey:key];
        }
    }
    return lyricDic;
}

/**
 *  单元格选择事件
 *
 *  @param tableView 表视图
 *  @param indexPath 索引路径
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UITabBarController *mainVC = delegate.mainVC;
    mainVC.selectedIndex = 1;
    XMSongPlayerViewController *player = (XMSongPlayerViewController*)delegate.mySongNav.topViewController;
    player.song = [songListArray objectAtIndex:indexPath.row];
    [player viewDidLoad];

    
}

/**
 *  表单元格
 *
 *  @param tableView 表视图
 *  @param indexPath 索引路径
 *
 *  @return 单元格视图
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    XMSong *song = [songListArray objectAtIndex:indexPath.row];
    cell.imageView.layer.cornerRadius = 25;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.image = [UIImage imageNamed:song.songAlbumCover];
    cell.textLabel.text = song.songName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"作者：%@，专辑：%@",song.songAuthor,song.songAlbum];
    
    return cell;
}

/**
 *  行高度
 *
 *  @param tableView 表视图
 *  @param indexPath 索引路径
 *
 *  @return 高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
/**
 *  数据条数
 *
 *  @param tableView 表视图
 *  @param section   分节
 *
 *  @return 行数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [songListArray count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
