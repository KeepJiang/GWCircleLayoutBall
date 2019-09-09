//
//  ViewController.m
//  CircleLayoutBall
//
//  Created by JZW on 2019/9/6.
//  Copyright © 2019 GW. All rights reserved.
//

#import "ViewController.h"
#import "CircleButtonModel.h"
#import "BMRoundButton.h"

#define XSV(_x_)  ((_x_) * ([[UIScreen mainScreen] bounds].size.width * 1.0 / 375.0))
static const CGFloat kLargeButtonWidth = 114;
static const CGFloat kBigButtonWidth = 94;
static const CGFloat kMidButtonWidth = 84;
static const CGFloat kSmallButtonWidth = 66;
static const CGFloat kLitButtonWidth = 56;
static const int kMaxLevel = 3;


@interface ViewController (){
    CGFloat radiusArray[4];//圆形轨道半径数组
    CGSize  buttonSizeArray[5];//圆形按钮宽度取值数组
}
/*! @brief 播放按钮 */
@property(nonatomic, weak) UIButton *playButton;
/*! @brief button数组 */
@property(nonatomic, strong) NSArray *buttonsArray;
/*! @brief 圆心中点 */
@property(nonatomic, assign) CGPoint center;
/*! @brief 最大的层级 */
@property(nonatomic, assign) int maxLevel;
/*! @brief 当前的层级 */
@property(nonatomic, assign) int currentLevel;
/*! @brief 当前点击的button */
@property(nonatomic, strong) BMRoundButton *clickedButton;
/*! @brief 重置按钮 */
@property(nonatomic, weak) UIButton *resetButton;
@end

@implementation ViewController

#pragma mark -- lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self _initDatas];
    [self _initViews];
}

#pragma mark -- initUI
- (void)_initViews{
    [self _initRoundButtons];
    [self _initResetButton];
}

- (void)_initResetButton{
    CGFloat height = 100;
    CGFloat y = CGRectGetHeight(self.view.frame) - height;
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.frame), 100)];
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetButtonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetButton];
    self.resetButton = resetButton;
}

- (void)_initRoundButtons{
    [self addButtonsToArray:[self createButtons]];
}

- (void)_initDatas{
    //最大的层数
    self.maxLevel = kMaxLevel;
    //1.根据self.view初始化圆心中点
    self.center = CGPointMake(CGRectGetWidth(self.view.frame) * 0.5, CGRectGetHeight(self.view.frame) * 0.5);
    //2.初始化圆形按钮半径数组
    CGFloat width[5] = {XSV(kLargeButtonWidth), XSV(kBigButtonWidth), XSV(kMidButtonWidth), XSV(kSmallButtonWidth), XSV(kLitButtonWidth)};
    for (int i = 0 ; i < 5; i++) {
        buttonSizeArray[i] = CGSizeMake(width[i], width[i]);
    }
    //3.初始化圆形轨道圆形半径数组
    radiusArray[0] = 15;
    radiusArray[1] = XSV(kBigButtonWidth);
    radiusArray[2] = XSV(kSmallButtonWidth) * 2 - 5;
    radiusArray[3] = XSV(kSmallButtonWidth) * 3;
    
    
     //4.画出圆方便调试
//     for (NSInteger j = 0; j < 4; j++) {
//         CAShapeLayer *layer = [CAShapeLayer new];
//         layer.lineWidth = 1;
//         //圆环的颜色
//         layer.strokeColor = [UIColor redColor].CGColor;
//         //背景填充色
//         layer.fillColor = [UIColor clearColor].CGColor;
//         //设置半径为10
//         CGFloat radius = radiusArray[j];
//         //按照顺时针方向
//         BOOL clockWise = true;
//         //初始化一个路径
//         UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:radius startAngle:0 endAngle:2.0f*M_PI clockwise:clockWise];
//         layer.path = [path CGPath];
//         [self.view.layer addSublayer:layer];
//     }
    
}

- (NSArray *)createButtons{
    //一屏球的个数限定最大为7，最小为4, 随机一个数
    NSInteger num = [self getRandomNumber:4 to:7];
    CGPoint center = self.center;
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:num];
    NSMutableArray *circles = [NSMutableArray arrayWithCapacity:num];
    //用来记录第一个球是大球还是中球
    int maxIndex = 0;
    int maxCount[3] = {1, 3, 3};
    int currentCount[3] = {0, 0, 0};
    for (NSInteger j = 0; j < num; j++) {
        //1.处理球的颜色
        CircleButtonModel *circleButtonModel = [CircleButtonModel new];
        [circles addObject:circleButtonModel];
        //1.1随机一个颜色
        int R = (arc4random() % 256);
        int G = (arc4random() % 256);
        int B = (arc4random() % 256);
        UIColor *color = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
        circleButtonModel.color = color;
        //2.处理球的大小
        //2.1第一个默认大球，第二个默认中球，之后随机大小
        if (0 == j) {
            circleButtonModel.size = buttonSizeArray[1];
        }else if(1 == j){
            circleButtonModel.size = buttonSizeArray[2];
        }else{
            int sizeIndex = [self getRandomNumber:2 to:4];
            circleButtonModel.size = buttonSizeArray[sizeIndex];
        }
        //2.处理球的位置
        //2.1随机球圆心在圆弧上的一个偏移量
        int offset = [self getRandomNumber:-10 to:10];
        //2.2随机一个角度偏移量
        int angleOffset = [self getRandomNumber:-10 to:10];
        //        offset = 0;
        //            CGPoint newCenter = CGPointMake(center.x - offset, center.y - offset);
        CGPoint newCenter = center;
        if (0 == maxIndex) {
            int angle = [self getRandomNumber:0 to:360];
            circleButtonModel.angle = angle;
            circleButtonModel.center = [self calcCircleCoordinateWithCenter:newCenter andWithAngle:angle andWithRadius:(radiusArray[maxIndex] + offset)];
        }else if(1 == maxIndex){
            if (0 == currentCount[maxIndex]) {
                int angle = [self getRandomNumber:0 to:360];
                circleButtonModel.angle = angle;
                circleButtonModel.center = [self calcCircleCoordinateWithCenter:newCenter andWithAngle:angle andWithRadius:(radiusArray[maxIndex] + offset)];
            }else{
                CircleButtonModel *preCircleButtonModel = circles[j - 1];
                int angle = 360 / maxCount[maxIndex] + angleOffset + preCircleButtonModel.angle;
                angle = angle > 360 ? (angle - 360) : angle;
                circleButtonModel.angle = angle;
                circleButtonModel.center = [self calcCircleCoordinateWithCenter:newCenter andWithAngle:angle andWithRadius:(radiusArray[maxIndex] + offset)];
            }
        }else{
            if (0 == currentCount[maxIndex]) {
                int index = (int)(j - maxCount[maxIndex -1]);
                CircleButtonModel *preCircleButtonModel = circles[index];
                int angle = [self getRandomNumber:60 to:90] + preCircleButtonModel.angle;
                angle = angle > 360 ? (angle - 360) : angle;
                circleButtonModel.angle = angle;
                circleButtonModel.center = [self calcCircleCoordinateWithCenter:newCenter andWithAngle:angle andWithRadius:(radiusArray[maxIndex] + offset)];
            }else{
                CircleButtonModel *preCircleButtonModel = circles[j - 1];
                int angle = 360 / maxCount[maxIndex] + angleOffset + preCircleButtonModel.angle;
                angle = angle > 360 ? (angle - 360) : angle;
                circleButtonModel.angle = angle;
                circleButtonModel.center = [self calcCircleCoordinateWithCenter:newCenter andWithAngle:angle andWithRadius:(radiusArray[maxIndex] + offset)];
            }
        }
        int currentNum  = currentCount[maxIndex] + 1;
        if (currentNum >= maxCount[maxIndex]) {
            maxIndex++;
        }else{
            currentCount[maxIndex] = currentNum;
        }
        //3.处理球的离开屏幕动画的位置
        int quadrant = ceil((circleButtonModel.angle / 90) % 4);
        int toX = 0;
        int toY = 0;
        int toOffset = [self getRandomNumber:60 to:120];
        switch (quadrant) {
            case 0:
                toX = self.view.frame.size.width + circleButtonModel.size.width * 0.5;
                toY = circleButtonModel.center.y - toOffset;
                break;
            case 1:
                toX = -circleButtonModel.size.width * 0.5;
                toY = circleButtonModel.center.y - toOffset;
                break;
            case 2:
                toX = -circleButtonModel.size.width * 0.5;
                toY = circleButtonModel.center.y + toOffset;
                break;
            case 3:
                toX = self.view.frame.size.width + circleButtonModel.size.width * 0.5;
                toY = circleButtonModel.center.y + toOffset;
                break;
            default:
                toX = self.view.frame.size.width + circleButtonModel.size.width * 0.5;
                toY = circleButtonModel.center.y - toOffset;
                break;
        }
        circleButtonModel.toCenter = CGPointMake(toX, toY);
        //4.创建按钮
        CGRect frame = CGRectZero;
        frame.size = circleButtonModel.size;
        BMRoundButton *button = [[BMRoundButton alloc] initWithFrame:frame];
        [button setTitle:[NSString stringWithFormat:@"按钮%ld", j] forState:UIControlStateNormal];
        button.backgroundColor = circleButtonModel.color;
        button.center = circleButtonModel.center;
        button.buttonModel = circleButtonModel;
        //            [self.view addSubview:button];
        
        //            int cornerRadius = frame.size.width * 0.5;
        //            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        //            CAShapeLayer *layer = CAShapeLayer.new;
        //            layer.path = path.CGPath;
        //            layer.frame = button.bounds;
        //            button.layer.mask = layer;
        //        [self animationScaleOnceWithView:button];
        //            [self animationUpDownWithView:button];
        
        [button addTarget:self action:@selector(buttonOnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
    }
    return [buttons copy];
}
#pragma mark -- events
- (void)resetButtonOnClicked:(UIButton *)button{
    [self resetButtonsArray];
    [self _initRoundButtons];
}

- (void)buttonOnClicked:(BMRoundButton *)currentButton{
    self.clickedButton = currentButton;
    if (currentButton.selected) {
        [self showPreButtons];
    }else if (self.currentLevel < self.maxLevel) {
        NSArray *currentButtons =  self.buttonsArray[self.currentLevel];
        for (BMRoundButton *button in currentButtons) {
            button.selected = NO;
            button.buttonModel.clicked = NO;
        }
        currentButton.buttonModel.clicked = YES;
        [self showNextButtons];
    }else{
        //只允许同时一个选中状态
        NSArray *currentButtons =  self.buttonsArray[self.currentLevel];
        for (BMRoundButton *button in currentButtons) {
            button.selected = NO;
            button.buttonModel.clicked = NO;
        }
        currentButton.buttonModel.clicked = YES;
        currentButton.selected = YES;
    }
}

- (void)showNextButtons{
    NSArray *currentButtons =  self.buttonsArray[self.currentLevel];
    NSArray *nextButtons = [self createButtons];
    //移出屏幕动画
    for (BMRoundButton *button in currentButtons) {
        CircleButtonModel *circleButtonModel = button.buttonModel;
        if (!circleButtonModel.clicked) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            animation.fromValue = [NSValue valueWithCGPoint:button.center];
            animation.toValue = [NSValue valueWithCGPoint:circleButtonModel.toCenter];
            animation.duration = 1.0;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            [button.layer addAnimation:animation forKey:@"moveOut"];
            //            [button removeFromSuperview];
        }else{
            //点击button的动画
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.fromValue = @(1.0);
            scaleAnimation.toValue = @(0.3);
            //        positionAnimation.duration = 1.0;
            scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            scaleAnimation.fillMode = kCAFillModeForwards;
            scaleAnimation.removedOnCompletion = NO;
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.fromValue = @(1.0);
            opacityAnimation.toValue = @(0.0);
            //        opacityAnimation.duration = 1.0;
            opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            opacityAnimation.fillMode = kCAFillModeForwards;
            opacityAnimation.removedOnCompletion = NO;
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            animationGroup.animations = @[scaleAnimation, opacityAnimation];
            animationGroup.duration = 1.0;
            animationGroup.fillMode = kCAFillModeForwards;
            animationGroup.removedOnCompletion = NO;
            [button.layer addAnimation:animationGroup forKey:@"clicked"];
            //    self.clickedButton.transform = CGAffineTransformIdentity;
            //    [UIView animateWithDuration:1.0 animations:^{
            //        self.clickedButton.transform = CGAffineTransformMakeScale(0.3, 0.3);
            //        self.clickedButton.alpha = 0.0;
            //    } completion:^(BOOL finished) {
            //        self.clickedButton.alpha = 0.0;
            //    }];
        }
    }
    //保存新创建的buttons
    self.currentLevel++;
    [self addButtonsToArray:nextButtons];
    //出现动画
    for (BMRoundButton *button in nextButtons) {
        CircleButtonModel *circleButtonModel = button.buttonModel;
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:self.clickedButton.center];
        positionAnimation.toValue = [NSValue valueWithCGPoint:circleButtonModel.center];
        //        positionAnimation.duration = 1.0;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @(0.0);
        opacityAnimation.toValue = @(1.0);
        //        opacityAnimation.duration = 1.0;
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        opacityAnimation.fillMode = kCAFillModeForwards;
        opacityAnimation.removedOnCompletion = NO;
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[positionAnimation, opacityAnimation];
        animationGroup.duration = 1.0;
        [button.layer addAnimation:animationGroup forKey:@"moveIn"];
    }
    
}

- (void)showPreButtons{
    NSInteger preLevel = self.currentLevel - 1;
    if (preLevel < 0) return;
    NSArray *currentButtons =  self.buttonsArray[self.currentLevel];
    NSArray *preButtons = self.buttonsArray[preLevel];
    //移除动画
    for (BMRoundButton *button in currentButtons) {
        button.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.5 animations:^{
            button.transform = CGAffineTransformMakeScale(0.3, 0.3);
            button.alpha = 0.0;
        } completion:^(BOOL finished) {
            [button removeFromSuperview];
        }];
    }
    //移回屏幕动画
    for (BMRoundButton *button in preButtons) {
        CircleButtonModel *circleButtonModel = button.buttonModel;
        //如果按钮是之前点选的，则说明只用做形变动画
        if (!circleButtonModel.clicked) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            animation.fromValue = [NSValue valueWithCGPoint:circleButtonModel.toCenter];
            animation.toValue = [NSValue valueWithCGPoint:button.center];
            animation.duration = 1.0;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            [button.layer addAnimation:animation forKey:@"moveBack"];
        }else{
            //点击button的动画
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.fromValue = @(0.0);
            scaleAnimation.toValue = @(1.0);
            //        positionAnimation.duration = 1.0;
            scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            scaleAnimation.fillMode = kCAFillModeForwards;
            scaleAnimation.removedOnCompletion = NO;
            CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            opacityAnimation.fromValue = @(0.0);
            opacityAnimation.toValue = @(1.0);
            //        opacityAnimation.duration = 1.0;
            opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            opacityAnimation.fillMode = kCAFillModeForwards;
            opacityAnimation.removedOnCompletion = NO;
            CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
            animationGroup.animations = @[scaleAnimation, opacityAnimation];
            animationGroup.duration = 1.0;
            animationGroup.fillMode = kCAFillModeForwards;
            animationGroup.removedOnCompletion = NO;
            [button.layer addAnimation:animationGroup forKey:@"clicked"];
//            button.transform = CGAffineTransformMakeScale(0.3, 0.3);
//            [UIView animateWithDuration:1.0 animations:^{
//                self.clickedButton.transform = CGAffineTransformIdentity;
//                self.clickedButton.alpha = 1.0;
//            } completion:^(BOOL finished) {
//                self.clickedButton.alpha = 1.0;
//            }];
        }
    }
    //移除操作

    [self deleteButtons];
}

- (void)deleteButtons{
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.buttonsArray];
    [arrayM removeLastObject];
    self.currentLevel--;
    self.buttonsArray = [arrayM copy];
}
#pragma mark -- public Functions

/**
 在一定范围内生成随机数
 @param from 起始值
 @param to 结束值
 @return 随机数
 */
- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1))); //+1,result is [from to]; else is [from, to)!!!!!!!
}

/**
 --------------------------------------------------------------
 功能说明
 --------------------------------------------------------------
 根据IOS视图中圆组件的中心点(x,y)、半径(r)、圆周上某一点与圆心的角度这3个
 条件来计算出该圆周某一点在IOS中的坐标(x2,y2)。
 
 注意：
 （1）IOS坐标体系与数学坐标体系有差别，因此不能完全采用数学计算公式。
 （2）数学计算公式：
 x2=x+r*cos(角度值*PI/180)
 y2=y+r*sin(角度值*PI/180)
 （3）IOS中计算公式：
 x2=x+r*cos(角度值*PI/180)
 y2=y-r*sin(角度值*PI/180)
 
 --------------------------------------------------------------
 参数说明
 --------------------------------------------------------------
 @param (CGPoint) center
 
 圆圈在IOS视图中的中心坐标，即该圆视图的center属性
 
 @param (CGFloat) angle
 角度值，是0～360之间的值。
 注意：
 （1）请使用下面坐标图形进行理解。
 （2）角度是逆时针转的，从x轴中心(0,0)往右是0度角（或360度角），往左是180度角，往上是90度角，往下是270度角。
 
 (y)
 ^
 |
 |
 |
 |
 -----------------> (x)
 |(0,0)
 |
 |
 |
 
 @param (CGFloat) radius
 圆周半径
 */
#pragma mark 计算圆圈上点在IOS系统中的坐标
- (CGPoint)calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = ceilf(radius*cosf(angle*M_PI/180));
    CGFloat y2 = ceilf(radius*sinf(angle*M_PI/180));
    return CGPointMake(center.x+x2, center.y-y2);
}


#pragma mark - 动画
- (void)animationScaleOnceWithView:(UIView *)view
{
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
        }];
    }];
}

/**
 添加上下漂浮动画
 @param view 要加动画的View
 */
- (void)animationUpDownWithView:(UIView *)view delay:(CGFloat) delayTime
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint fromPoint = CGPointMake(position.x, position.y);
    CGPoint toPoint = CGPointZero;
    
    uint32_t typeInt = arc4random() % 100;
    CGFloat distanceFloat = 0.0;
    //随机0 - 3之前的一个随机数
    while (distanceFloat == 0) {
        distanceFloat = (3 + (int)(arc4random() % (9 - 7 + 1))) * 100.0 / 101.0;
    }
    //随机上或者下
    if (typeInt % 2 == 0) {
        toPoint = CGPointMake(position.x, position.y - distanceFloat);
    } else {
        toPoint = CGPointMake(position.x, position.y + distanceFloat);
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.beginTime = CACurrentMediaTime() + delayTime;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    animation.autoreverses = YES;
    //随机动画的总时长1.2 + x / 31
    CGFloat durationFloat = 0.0;
    while (durationFloat == 0.0) {
        durationFloat = 1.2 + (int)(arc4random() % (100 - 70 + 1)) / 31.0;
    }
    [animation setDuration:durationFloat];
    [animation setRepeatCount:MAXFLOAT];
    
    [viewLayer addAnimation:animation forKey:@"upAndDown"];
    //添加动画围绕圆形轨迹运动，视觉效果不太好
    //    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //    keyFrameAnimation.removedOnCompletion = NO;
    //    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ////    keyFrameAnimation.autoreverses = YES;
    //    UIBezierPath *path = [[UIBezierPath alloc] init];
    //    [path addArcWithCenter:view.center radius:2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    //    keyFrameAnimation.path = path.CGPath;
    //    keyFrameAnimation.beginTime = CACurrentMediaTime() + [self getRandomNumber:0 to:10] * 1.0 / 20.0;
    //    [keyFrameAnimation setDuration:4];
    //    [keyFrameAnimation setRepeatCount:MAXFLOAT];
    //    [viewLayer addAnimation:keyFrameAnimation forKey:@"rotation"];
}

#pragma mark -- button数组操作
- (void)resetButtonsArray{
    if (self.buttonsArray.count > 0) {
        for (NSArray *buttons in self.buttonsArray) {
            for (BMRoundButton *button in buttons) {
                [button removeFromSuperview];
            }
        }
    }
    self.buttonsArray = nil;
    self.currentLevel = 0;
}

- (void)addButtonsToArray:(NSArray *) buttons{
    NSMutableArray *arrayM;
    if (self.buttonsArray.count > 0) {
        arrayM = [NSMutableArray arrayWithArray:self.buttonsArray];
    }else{
        arrayM = [NSMutableArray arrayWithCapacity:self.maxLevel];
    }
    if (buttons.count > 0) {
        CGFloat delayTime = self.currentLevel == 0 ? 0 : 1.0;
        for (BMRoundButton *button in buttons) {
            [self.view addSubview:button];
            [self animationUpDownWithView:button delay:delayTime];
        }
        [arrayM addObject:buttons];
    }
    self.buttonsArray = [arrayM copy];
}
@end
