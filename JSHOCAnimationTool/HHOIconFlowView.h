//
//  HHOIconFlowView.h
//  HHOLive
//
//  Created by JSH on 2024/4/25.
//

#import <UIKit/UIKit.h>
#define kLiveLikeFlowSizeW 46  // LikeFlowView 的宽度
#define kLiveLikeFlowSizeH 240 // LikeFlowView 的高度

NS_ASSUME_NONNULL_BEGIN

@interface HHOIconFlowView : UIView
- (void)playAnimationWithCount:(NSUInteger)count;
@end

NS_ASSUME_NONNULL_END
