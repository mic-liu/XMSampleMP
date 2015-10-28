//
//  XMPlayerSlider.h
//  XMControl
//
//  Created by LiuMingchuan on 15/10/28.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChangeSlide)(NSTimeInterval);
@interface XMPlayerSlider : UIView

/**
 *  总值
 */
@property (nonatomic,assign)NSTimeInterval maxValue;

/**
 *  播放值
 */
@property (nonatomic,assign)NSTimeInterval passedValue;
/**
 *  剩余值
 */
@property (nonatomic,assign)NSTimeInterval leaveValue;

/**
 *  改变滑动block
 */
@property (nonatomic,strong)ChangeSlide changeSlide;

/**
 *  获取格式化字符串
 *
 *  @param timeInterval 时间
 *
 *  @return 字符串
 */
- (NSString *)formatTimeIntervalToStr:(NSTimeInterval)timeInterval;
@end
