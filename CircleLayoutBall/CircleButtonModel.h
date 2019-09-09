//
//  CircleButtonPosition.h
//  TingIPhone
//
//  Created by JZW on 2019/3/25.
//  Copyright © 2019 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "BMRoundButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CircleButtonModel <NSObject>

@end

@interface CircleButtonModel : NSObject
/*! @brief 颜色 */
@property(nonatomic, strong) UIColor *color;
/*! @brief 大小 */
@property(nonatomic, assign) CGSize size;
/*! @brief 当前的位置 */
@property(nonatomic, assign) CGPoint center;
/*! @brief 出现的位置 */
@property(nonatomic, assign) CGPoint fromCenter;
/*! @brief 移动到的位置 */
@property(nonatomic, assign) CGPoint toCenter;
/*! @brief 角度 */
@property(nonatomic, assign) int angle;
/*! @brief id */
@property(nonatomic, copy) NSString *scene_id;
/*! @brief 是否被点击 */
@property(nonatomic, assign, getter=isClicked) BOOL clicked;
@end

NS_ASSUME_NONNULL_END
