//
//  XMSong.h
//  XMSampleMP
//
//  Created by LiuMingchuan on 15/10/27.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMSong : NSObject
/**
 *  歌曲名
 */
@property (nonatomic,strong)NSString *songName;
/**
 *  作者
 */
@property (nonatomic,strong)NSString *songAuthor;
/**
 *  专辑
 */
@property (nonatomic,strong)NSString *songAlbum;
/**
 *  歌词
 */
@property (nonatomic,strong)NSMutableDictionary *songLyrics;
/**
 *  封面
 */
@property (nonatomic,strong)NSString *songAlbumCover;
@end
