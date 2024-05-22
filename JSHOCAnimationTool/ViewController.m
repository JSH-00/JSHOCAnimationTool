//
//  ViewController.m
//  JSHOCAnimationTool
//
//  Created by JSH on 2024/5/22.
//

#import "ViewController.h"
#import "HHOIconFlowView.h"

@interface ViewController ()
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) UIBezierPath *path1;
@property (nonatomic, strong) UIBezierPath *path2;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) HHOIconFlowView *iconFlowView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.path = [UIBezierPath bezierPath];
    self.path1 = [UIBezierPath bezierPath];
    self.path2 = [UIBezierPath bezierPath];
    self.shapeLayer = [CAShapeLayer layer];
    
    // 设置路径属性
    self.shapeLayer.path = self.path.CGPath;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    self.shapeLayer.lineWidth = 2.0;
    
    // 添加到视图的layer中
    [self.view.layer addSublayer:self.shapeLayer];
    
    self.iconFlowView = [[HHOIconFlowView alloc] init];
    self.iconFlowView.frame = CGRectMake(15, 15, kLiveLikeFlowSizeW, kLiveLikeFlowSizeH);
    [self.view addSubview:self.iconFlowView];
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self animatePath];
    
    [self.iconFlowView playAnimationWithCount:5];

}

- (void)animatePath {
    // 根据用户的选择绘制不同类型的曲线
    [self drawQuadCurve];
    [self drawCubicCurve];
    [self drawComplexCubicCurve];
}

- (void)drawQuadCurve {
    [self.path removeAllPoints];
    [self.path moveToPoint:CGPointMake(50, 200)];
    [self.path addQuadCurveToPoint:CGPointMake(300, 200) controlPoint:CGPointMake(175, 100)];
    [self updateShapeLayer];
}

- (void)drawCubicCurve {
    [self.path removeAllPoints];
    [self.path moveToPoint:CGPointMake(50, 300)];
    [self.path addCurveToPoint:CGPointMake(300, 300) controlPoint1:CGPointMake(100, 200) controlPoint2:CGPointMake(200, 400)];
    [self updateShapeLayer];
}

- (void)drawComplexCubicCurve {
    [self.path removeAllPoints];
    [self.path moveToPoint:CGPointMake(50, 400)];
    [self.path addCurveToPoint:CGPointMake(300, 400) controlPoint1:CGPointMake(100, 300) controlPoint2:CGPointMake(200, 500)];
    [self updateShapeLayer];
}

- (void)updateShapeLayer {
    self.shapeLayer.path = self.path.CGPath;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

@end

