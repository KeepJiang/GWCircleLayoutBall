//
//  BMRoundButton.m
//  TingIPhone
//
//  Created by 江宗武 on 2018/1/6.
//  Copyright © 2018年 Baidu. All rights reserved.
//

#import "BMRoundButton.h"

@interface BMRoundButton()
/*! @brief button圆形路径 */
@property(nonatomic, strong) UIBezierPath *path;
/*! @brief 圆半径 */
@property(nonatomic, assign) CGFloat radius;
/*! @brief 遮罩View */
@property(nonatomic, weak) UIView *coverView;
/*! @brief 选中状态显示勾勾 */
@property(nonatomic, weak) UIImageView *checkImageView;
@end


@implementation BMRoundButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    BMRoundButton *roundButton = [super buttonWithType:buttonType];
    if (roundButton) {
        roundButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [roundButton addCoverView];
        [roundButton addcheckImageView];
        [roundButton bringSubviewToFront:roundButton.imageView];
        
    }
    return roundButton;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addCoverView];
        [self addcheckImageView];
        [self bringSubviewToFront:self.imageView];
    }
    return self;
}

- (void)addCoverView{
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.25;
    coverView.hidden = YES;
    coverView.userInteractionEnabled = NO;
    self.coverView = coverView;
    [self addSubview:coverView];
}

- (void)addcheckImageView{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tagok"]];
    imageView.hidden = YES;
    self.checkImageView = imageView;
    [self addSubview:imageView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.checkImageView.frame = [self checkImageViewRect];
    self.coverView.frame = CGRectMake(0, 0, self.radius * 2, self.radius * 2);
    self.coverView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.coverView.center radius:self.radius startAngle:0.0f endAngle:M_PI * 2 clockwise:YES];
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.frame];
    [path closePath];
    
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.path = self.path.CGPath;
    self.coverView.layer.mask = shapLayer;
    
    
}

// 返回titleLable边界
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    // 这contentRect就是button的frame
    CGPoint center = CGPointMake(contentRect.size.width * 0.5, contentRect.size.height * 0.5);
    CGFloat x = center.x - self.radius * 0.9;
    CGFloat y = center.y - self.radius * 0.6;
    CGFloat width = self.radius * 1.8;
    CGFloat height = self.radius * 1.2;
    return CGRectMake(x, y, width, height);
}

// 返回imageView边界
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGPoint center = CGPointMake(contentRect.size.width * 0.5, contentRect.size.height * 0.5);
    CGFloat x = center.x - self.radius * 0.15;
    CGFloat y = center.y + self.radius * 0.6;
    CGFloat width = self.radius * 0.3;
    CGFloat height = self.radius * 0.3;
    return CGRectMake(x, y, width, height);
}

- (CGRect)checkImageViewRect{
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5);
    CGFloat x = center.x - self.radius * 0.15;
    CGFloat y = center.y + self.radius * 0.6;
    CGFloat width = self.radius * 0.3;
    CGFloat height = self.radius * 0.3;
    return CGRectMake(x, y, width, height);
}

#pragma mark -lazyLoad
- (CGFloat)radius{
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat radius = width < height ? width : height;
    return radius * 0.5;
}

- (UIBezierPath *)path{
//    VLog(@"圆形按钮中心点：%@", NSStringFromCGPoint(self.center));
    CGPoint center = CGPointMake(self.radius, self.radius);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:self.radius startAngle:0.0f endAngle:M_PI * 2 clockwise:YES];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.frame];
    [path closePath];
    return path;
}

- (UIBezierPath *)coverViewPath{
    //    VLog(@"圆形按钮中心点：%@", NSStringFromCGPoint(self.center));
    CGPoint center = CGPointMake(self.radius, self.radius);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:self.radius startAngle:0.0f endAngle:M_PI * 2 clockwise:YES];
    //    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.frame];
    [path closePath];
    return path;
}

//绘制按钮时添加path遮罩
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CAShapeLayer *shapLayer = [CAShapeLayer layer];
    shapLayer.path = self.path.CGPath;
    self.layer.mask = shapLayer;

}

//覆盖方法，点击时判断点是否在path内，YES则响应，NO则不响应
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL res = [super pointInside:point withEvent:event];
    if (res)
    {
        if ([self.path containsPoint:point])
        {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.coverView.hidden = !selected;
    self.checkImageView.hidden = !selected;
    [UIView animateWithDuration:1.0 animations:^{
        if (selected) {
            self.titleLabel.alpha = 0.4;
        }else{
            self.titleLabel.alpha = 1;
        }
    }];
}
@end
