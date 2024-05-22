//
//  ViewController.m
//  JSHOCAnimationTool
//
//  Created by JSH on 2024/5/22.
//

// ViewController.m

#import "ViewController.h"
#import "HHOIconFlowView.h"

@interface ViewController ()
@property (nonatomic, strong) HHOIconFlowView *iconFlowView;

// 为每种曲线定义一个CAShapeLayer
@property (nonatomic, strong) CAShapeLayer *quadCurveLayer;
@property (nonatomic, strong) CAShapeLayer *cubicCurveLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化曲线层
    [self setupCurveLayers];
    
    self.iconFlowView = [[HHOIconFlowView alloc] init];
    self.iconFlowView.frame = CGRectMake(15, 15, kLiveLikeFlowSizeW, kLiveLikeFlowSizeH);
    [self.view addSubview:self.iconFlowView];
}

- (void)setupCurveLayers {
    // 初始化和配置每个曲线的CAShapeLayer
    self.quadCurveLayer = [self createShapeLayerWithStrokeColor:[UIColor redColor].CGColor];
    self.cubicCurveLayer = [self createShapeLayerWithStrokeColor:[UIColor greenColor].CGColor];
}

- (CAShapeLayer *)createShapeLayerWithStrokeColor:(CGColorRef)color {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = color;
    shapeLayer.lineWidth = 2.0;
    [self.view.layer addSublayer:shapeLayer];
    return shapeLayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self animatePaths];
    [self.iconFlowView playAnimationWithCount:5];
}

- (void)animatePaths {
    [self drawQuadCurve];
    [self drawCubicCurve];
}

- (void)drawQuadCurve {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 200)];
    [path addQuadCurveToPoint:CGPointMake(300, 200) controlPoint:CGPointMake(175, 100)];
    self.quadCurveLayer.path = path.CGPath;
    [self addAnimationToLayer:self.quadCurveLayer];
}

- (void)drawCubicCurve {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 300)];
    [path addCurveToPoint:CGPointMake(300, 300) controlPoint1:CGPointMake(100, 200) controlPoint2:CGPointMake(200, 400)];
    self.cubicCurveLayer.path = path.CGPath;
    [self addAnimationToLayer:self.cubicCurveLayer];
}

- (void)addAnimationToLayer:(CAShapeLayer *)layer {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0;
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @1.0f;
    [layer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

@end

