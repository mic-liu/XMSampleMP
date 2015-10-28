//
//  XMSongPlayerViewController.m
//  XMSampleMP
//
//  Created by LiuMingchuan on 15/10/27.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "XMSongPlayerViewController.h"
#import <MediaPlayer/MPMediaItemCollection.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAudioSession.h>
#import "XMPlayerSlider.h"
#define MP3 @"mp3"
#define PlayingInfoCenter @"MPNowPlayingInfoCenter"
@interface XMSongPlayerViewController (){
    NSTimer *seekTimer;
    int seekTime;
    AVAudioPlayer *audioPlayer;
    NSTimer *sliderTimer;
    CABasicAnimation *rollingAni;
}

@end


@implementation XMSongPlayerViewController

- (void)viewDidLoad {
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [super viewDidLoad];
    [self setTitle:@"音乐欣赏"];
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(self.imgvSongAlbumCover.bounds.size.width/2, self.imgvSongAlbumCover.bounds.size.width/2) radius:self.imgvSongAlbumCover.bounds.size.width/3.5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor brownColor].CGColor;
    layer.lineWidth = self.imgvSongAlbumCover.frame.size.width/2.5;
    layer.path = bezierPath.CGPath;
    self.imgvSongAlbumCover.layer.mask = layer;
    
    rollingAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rollingAni.toValue = [NSNumber numberWithFloat:2*M_PI];
    rollingAni.duration = 30;
    rollingAni.removedOnCompletion = NO;//切换tab后动画可以继续
    rollingAni.repeatCount = HUGE_VALF;
    [self.imgvSongAlbumCover.layer addAnimation:rollingAni forKey:@"rotationAnimation"];
    self.imgvSongAlbumCover.layer.speed = 0.0;
    
    self.imgvSongAlbumCover.image = [UIImage imageNamed:self.song.songAlbumCover]?[UIImage imageNamed:self.song.songAlbumCover]:[UIImage imageNamed:@"empty"];
    self.lblSongName.text = self.song.songName?self.song.songName:@"No Song";
    self.lblSongAuthor.text = self.song.songAuthor?[NSString stringWithFormat:@"Singer:%@",self.song.songAuthor]:@"No Singer";
    self.lblSongAlbum.text = self.song.songAlbum?[NSString stringWithFormat:@"Album:%@",self.song.songAlbum]:@"No Album";
    
    if(self.song.songName){
        NSError *err;
        if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&err]) {
            NSLog(@"ERR:%@",[err localizedFailureReason]);
        }else {
            [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
        }
        NSString *path = [[NSBundle mainBundle]pathForResource:self.song.songName ofType:MP3];
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:nil];
        audioPlayer.delegate = self;
        audioPlayer.currentTime = 0.0;
        [audioPlayer prepareToPlay];
        [_sliderView setMaxValue:audioPlayer.duration];
        [_sliderView setPassedValue:audioPlayer.currentTime];
        if (!sliderTimer) {
            sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sliderTimerEvent) userInfo:nil repeats:YES];
        }
        [self.btnCtrl setImage:[UIImage imageNamed:@"play"]] ;
        [sliderTimer setFireDate:[NSDate date]];
        [audioPlayer play];
        [self resumeLayer:self.imgvSongAlbumCover.layer];
        ChangeSlide changeSlider = ^(NSTimeInterval passed){
            audioPlayer.currentTime = passed;
        };
        [_sliderView setChangeSlide:changeSlider];
    }
}

/**
 *  定时器刷新播放时间剩余时间
 */
- (void)sliderTimerEvent {
    if (audioPlayer) {
        [_sliderView setPassedValue:audioPlayer.currentTime];
        [_sliderView setLeaveValue:audioPlayer.duration];
        NSString *key = [_sliderView formatTimeIntervalToStr:audioPlayer.currentTime];
        NSString *lyric = [self.song.songLyrics objectForKey:key];
        if (lyric) {
            [self refreshCenterInfo:lyric];
            self.lblLyric.text = lyric;
        }
        if (!audioPlayer.playing && _sliderView.leaveValue == _sliderView.maxValue) {
            [sliderTimer setFireDate:[NSDate distantFuture]];
            self.btnCtrl.image = [UIImage imageNamed:@"pause"];
            [self pauseLayer:self.imgvSongAlbumCover.layer];
            return;
        }
    }
}

/**
 *  暂停播放
 *
 *  @param sender
 */
- (IBAction)btnPlayOrPause:(id)sender {
    if (audioPlayer) {
        if (audioPlayer.isPlaying) {
            [self pauseLayer:self.imgvSongAlbumCover.layer];
            [audioPlayer pause];
            [sliderTimer setFireDate:[NSDate distantFuture]];
            [self.btnCtrl setImage:[UIImage imageNamed:@"pause"]];
        } else {
            [audioPlayer play];
            [self resumeLayer:self.imgvSongAlbumCover.layer];
            [sliderTimer setFireDate:[NSDate date]];
            [self.btnCtrl setImage:[UIImage imageNamed:@"play"]];
        }
    }
}

/**
 *  上一首
 *
 *  @param sender
 */
- (IBAction)btnPrevious:(id)sender {
}

/**
 *  下一首
 *
 *  @param sender
 */
- (IBAction)btnNex:(id)sender {
}

/**
 *  刷新锁屏信息
 */
- (void)refreshCenterInfo:(NSString *)lyric {
    Class playerInfoCenter = NSClassFromString(PlayingInfoCenter);
    if (playerInfoCenter) {
        //准备图片，歌曲显示信息
        NSMutableDictionary *info = [[NSMutableDictionary alloc]init];
        MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc]initWithImage:[self drawLyrics:lyric]];
        [info setValue:artWork forKey:MPMediaItemPropertyArtwork];
        [info setObject:[NSNumber numberWithDouble:audioPlayer.duration] forKey:MPMediaItemPropertyPlaybackDuration];
        [info setObject:[NSNumber numberWithDouble:audioPlayer.currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        [info setObject:self.song.songName forKey:MPMediaItemPropertyTitle ];
        [info setObject:self.song.songAuthor forKey:MPMediaItemPropertyArtist ];
        [info setObject:self.song.songAlbum forKey:MPMediaItemPropertyAlbumTitle ];
        [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];
    }
}

/**
 *  控制
 *
 *  @param event 事件
 */
-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause://暂停
            {
                [audioPlayer pause];
                [self pauseLayer:self.imgvSongAlbumCover.layer];
                self.btnCtrl.image = [UIImage imageNamed:@"pause"];
                [sliderTimer setFireDate:[NSDate distantFuture]];
                break;
            }
            case UIEventSubtypeRemoteControlPlay://播放
            {
                [self btnPlayOrPause:nil];
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack://下一首
            {
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack://上一首
            {
                break;
            }
            case UIEventSubtypeRemoteControlBeginSeekingForward://快进开始
            {
                seekTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(seek:) userInfo:[NSNumber numberWithInt:0] repeats:YES];
                //开始计算前进时间
                [seekTimer fire];
                break;
            }
            case UIEventSubtypeRemoteControlEndSeekingForward://快进结束
            {
                audioPlayer.currentTime = audioPlayer.currentTime+seekTime;
                //滑动条更新
                [_sliderView setPassedValue:audioPlayer.currentTime];
                [_sliderView setLeaveValue:audioPlayer.duration];
                seekTime = 0;
                [seekTimer invalidate];
                seekTimer = nil;
                break;
            }
            case UIEventSubtypeRemoteControlBeginSeekingBackward://后退开始
            {
                seekTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(seek:) userInfo:[NSNumber numberWithInt:1] repeats:YES];
                //开始计算后退时间
                [seekTimer fire];
                break;
            }
            case UIEventSubtypeRemoteControlEndSeekingBackward://后退结束
            {
                audioPlayer.currentTime = audioPlayer.currentTime+seekTime;
                //滑动条更新
                [_sliderView setPassedValue:audioPlayer.currentTime];
                [_sliderView setLeaveValue:audioPlayer.duration];
                seekTime = 0;
                [seekTimer invalidate];
                seekTimer = nil;
                break;
            }
            case UIEventSubtypeRemoteControlStop://停止
            {
                [audioPlayer stop];
                break;
            }
            default:
                break;
        }
    }
}

/**
 *  前进后退响应
 *
 *  @param timer 时间控制器
 */
- (void)seek:(NSTimer *)timer{
    //每次响应前进后退3S
    if ([[timer userInfo] integerValue]==0) {
        seekTime = seekTime + 3;
    }else{
        seekTime = seekTime - 3;
    }
}

/**
 *  绘制歌词
 *
 *  @param lyrics 歌词
 *
 *  @return 图片
 */
- (UIImage *)drawLyrics:(NSString *)lyrics {
    //获取获取专辑封面,没有则使用预置图片
    UIImage *img = nil;
    if (self.song.songAlbumCover) {
        img= [UIImage imageNamed:self.song.songAlbumCover];
    } else {
        img = [UIImage imageNamed:@"empty"];
    }
    CGSize size = img.size;
    //创建绘制区域
    UIGraphicsBeginImageContext(size);
    //图片绘制
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    CGRect rect = CGRectMake(0, size.height-110, size.width, 50);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle]mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *dicLight = @{NSFontAttributeName:[UIFont systemFontOfSize:30],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor orangeColor]};
    //歌词绘制
    [lyrics drawInRect:rect withAttributes:dicLight];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //返回绘制合成图片
    return image;
}

/**
 *  暂停图层动画
 *
 *  @param layer 图层
 */
- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

/**
 *  继续图层动画
 *
 *  @param layer 图层
 */
- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
