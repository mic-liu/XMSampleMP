//
//  XMSongPlayerViewController.h
//  XMSampleMP
//
//  Created by LiuMingchuan on 15/10/27.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMSong.h"
#import <AVFoundation/AVAudioPlayer.h>
@class XMPlayerSlider;
@interface XMSongPlayerViewController : UIViewController<AVAudioPlayerDelegate>
@property (nonatomic,strong) XMSong *song;

@property (strong, nonatomic) IBOutlet UILabel *lblSongName;
@property (strong, nonatomic) IBOutlet UILabel *lblSongAuthor;
@property (strong, nonatomic) IBOutlet UILabel *lblSongAlbum;
@property (strong, nonatomic) IBOutlet UIImageView *imgvSongAlbumCover;
- (IBAction)btnPrevious:(id)sender;
- (IBAction)btnPlayOrPause:(id)sender;
- (IBAction)btnNex:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnCtrl;
@property (strong, nonatomic) IBOutlet XMPlayerSlider *sliderView;

@property (strong, nonatomic) IBOutlet UILabel *lblLyric;

@end
