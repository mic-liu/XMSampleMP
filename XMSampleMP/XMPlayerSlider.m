//
//  XMPlayerSlider.m
//  XMControl
//
//  Created by LiuMingchuan on 15/10/28.
//  Copyright © 2015年 LMC. All rights reserved.
//

#import "XMPlayerSlider.h"

@implementation XMPlayerSlider {
    CAGradientLayer *passedLayer;
    CAGradientLayer *leaveLayer;
    UILabel *lblPassed;
    UILabel *lblLeaved;
    CGSize size;
    NSDateFormatter *dateFormatter;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
/**
 *  初始化
 */
- (void)initView{
    size = self.bounds.size;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    }
    if (!passedLayer) {
        passedLayer = [CAGradientLayer layer];
        passedLayer.frame = CGRectMake(0, (size.height-size.height/4)/2, 0, size.height/4);
        [passedLayer setColors:@[(id)[UIColor orangeColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor orangeColor].CGColor]];
        [self.layer addSublayer:passedLayer];
    }
    if (!leaveLayer) {
        leaveLayer = [CAGradientLayer layer];
        leaveLayer.frame = CGRectMake(passedLayer.frame.size.width, (size.height-size.height/4)/2, size.width, size.height/4);
        [leaveLayer setColors:@[(id)[UIColor blueColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor blueColor].CGColor]];
        [self.layer addSublayer:leaveLayer];
    }
    if (!lblPassed) {
        lblPassed = [[UILabel alloc]initWithFrame:CGRectMake(0, size.height*3/4, size.width/2, 20)];
        lblPassed.font = [UIFont systemFontOfSize:13];
        [self addSubview:lblPassed];
    }
    if (!lblLeaved) {
        lblLeaved = [[UILabel alloc]initWithFrame:CGRectMake(size.width/2, size.height*3/4, size.width/2, 20)];
        lblLeaved.font = [UIFont systemFontOfSize:13];
        lblLeaved.textAlignment = NSTextAlignmentRight;
        [self addSubview:lblLeaved];
    }
    lblPassed.text = @"--:--";
    lblLeaved.text = @"--:--";
}
/**
 *  设定播放值
 *
 *  @param passedValue 播放值
 */
-(void)setPassedValue:(NSTimeInterval)passedValue{
    _passedValue = passedValue;
    
    passedLayer.frame = CGRectMake(0, (size.height-size.height/4)/2, size.width*(passedValue/self.maxValue), size.height/4);
    leaveLayer.frame = CGRectMake(passedLayer.frame.size.width, (size.height-size.height/4)/2, size.width-passedLayer.frame.size.width, size.height/4);
    lblPassed.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:passedValue]];
    lblLeaved.text = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.maxValue-passedValue]];
    self.leaveValue = self.maxValue-passedValue;
    
}

/**
 *  格式化时间
 *
 *  @param timeInterval 时间
 *
 *  @return 格式化的时间
 */
- (NSString *)formatTimeIntervalToStr:(NSTimeInterval)timeInterval {
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

/**
 *  触摸开始
 *
 *  @param touches 触摸
 *  @param event   事件
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if (location.x<=size.width && location.x>=0 && _maxValue>0){
        [self setPassedValue:(location.x/size.width)*_maxValue];
        if (self.changeSlide) {
            self.changeSlide(self.passedValue);
        }
    }
}

/**
 *  触摸拖动
 *
 *  @param touches 触摸
 *  @param event   事件
 */
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if (location.x<=size.width && location.x>=0 && _maxValue>0){
        [self setPassedValue:(location.x/size.width)*_maxValue];
        //
        if (self.changeSlide) {
            self.changeSlide(self.passedValue);
        }
    }
}
@end
