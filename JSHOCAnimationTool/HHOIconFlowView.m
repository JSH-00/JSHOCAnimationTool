//
//  HHOIconFlowView.m
//  HHOLive
//
//  Created by JSH on 2024/4/25.
//

#import "HHOIconFlowView.h"
#import <UIKit/UIKit.h>

#define kLiveLikeFlowImageSize 30      // 每个图片的大小
#define kLiveLikeFlowStaggerDelay 0.26 // 动画间隔时间

@interface HHOIconFlowView ()

@property (nonatomic, strong) NSMutableArray<UIImage *> *imageDrawables;
@property (nonatomic, assign) BOOL animating;

@end

@implementation HHOIconFlowView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageDrawables = [NSMutableArray array];
        for (int i = 1; i <= 6; i++) {
            NSString *imageName = [NSString stringWithFormat:@"icon_%d", i];
            UIImage *image = [UIImage imageNamed:imageName];
            if (image) {
                [self.imageDrawables addObject:image];
            }
        }
    }
    return self;
}

- (void)playAnimationWithCount:(NSUInteger)count {
    if (!self.animating) {
        self.animating = YES;
        for (NSUInteger i = 0; i < count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kLiveLikeFlowImageSize, kLiveLikeFlowImageSize)];
            NSUInteger randomIndex = arc4random_uniform((u_int32_t)self.imageDrawables.count);
            imageView.image = [self.imageDrawables objectAtIndex:randomIndex];
            
            CGFloat parentWidth = kLiveLikeFlowSizeW;
            CGFloat parentHeight = kLiveLikeFlowSizeH;
            imageView.center = CGPointMake(parentWidth / 2, parentHeight);
            imageView.alpha = 0.0f;
            
            [self addSubview:imageView];
            
            [self createAnimatorForView:imageView
                                isXAnim:(i != 0 && i!=count-1)  //第一个和最后一个icon 横向不做动画
                             startDelay:i * kLiveLikeFlowStaggerDelay];
        }
    }
}

- (void)createAnimatorForView:(UIView *)view isXAnim:(BOOL)isXAnim startDelay:(NSTimeInterval)delay {
    NSTimeInterval totalDuration = 2.0;
    [self applySpiralAnimationToView:view isXAnim:isXAnim delay:delay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((totalDuration + delay) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view removeFromSuperview];
        if (self.subviews.count == 0) {
            self.animating = NO;
        }
    });
}

// 使用动画
- (void)applySpiralAnimationToView:(UIView *)view isXAnim:(BOOL)isXAnim delay:(CFTimeInterval)delay {
    CAAnimationGroup *animationGroup = [self createSpiralAnimationForView:view isXAnim:isXAnim delay:delay];
    [view.layer addAnimation:animationGroup forKey:@"spiralAnimation"];
}

- (CAAnimationGroup *)createSpiralAnimationForView:(UIView *)view isXAnim:(BOOL)isXAnim delay:(CFTimeInterval)delay {
    CGFloat totalDuration = 2.0;
    // 第一个透明度动画，透明度从0增加到0.8
    CABasicAnimation *opacityIncreaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityIncreaseAnimation.fromValue = @0.0;
    opacityIncreaseAnimation.toValue = @0.8;
    opacityIncreaseAnimation.duration = totalDuration / 8;
    opacityIncreaseAnimation.beginTime = delay;
    opacityIncreaseAnimation.fillMode = kCAFillModeForwards;
    opacityIncreaseAnimation.removedOnCompletion = NO;
    
    // 第二个透明度动画，透明度从0.8降低到0
    CABasicAnimation *opacityDecreaseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityDecreaseAnimation.fromValue = @0.8;
    opacityDecreaseAnimation.toValue = @0.0;
    opacityDecreaseAnimation.duration = totalDuration / 8;
    opacityDecreaseAnimation.beginTime = delay + totalDuration* 7/ 8;
    opacityDecreaseAnimation.fillMode = kCAFillModeForwards;
    opacityDecreaseAnimation.removedOnCompletion = NO;
    
    // Y轴移动动画
    CABasicAnimation *positionYAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionYAnimation.fromValue = @(kLiveLikeFlowSizeH);
    positionYAnimation.toValue = @0;
    positionYAnimation.duration = totalDuration;
    positionYAnimation.beginTime = delay;
    positionYAnimation.fillMode = kCAFillModeForwards;
    positionYAnimation.removedOnCompletion = NO;
    
    // 动画组合
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    if (isXAnim) {
        // X轴移动动画
        CAKeyframeAnimation *positionXAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
        positionXAnimation.values = @[@(view.layer.position.x), @(view.layer.position.x - kLiveLikeFlowSizeW/4), @(view.layer.position.x), @(view.layer.position.x + kLiveLikeFlowSizeW/4), @(view.layer.position.x)];
        positionXAnimation.keyTimes = @[@0.0, @0.25, @0.5, @0.75, @1.0];
        positionXAnimation.beginTime = delay;
        positionXAnimation.repeatCount = 1.5;
        positionXAnimation.duration = totalDuration/1.5;
        positionXAnimation.fillMode = kCAFillModeForwards;
        positionXAnimation.removedOnCompletion = NO;
        animationGroup.animations = @[opacityIncreaseAnimation, opacityDecreaseAnimation, positionXAnimation, positionYAnimation];
    } else {
        animationGroup.animations = @[opacityIncreaseAnimation, opacityDecreaseAnimation, positionYAnimation];
    }
    
    animationGroup.duration = delay + totalDuration;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    return animationGroup;
}
@end
