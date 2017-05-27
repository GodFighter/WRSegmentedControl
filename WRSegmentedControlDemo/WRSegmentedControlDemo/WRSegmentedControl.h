//
//  WRSegmentedControl.h
//  WRSegmentedControlDemo
//
//  Created by xianghui on 2017/5/27.
//  Copyright © 2017年 xianghui. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief 分段控制器
 *
 * @attention backgroundColor 不能为透明，默认白色
 * @attention frame会被设置为正方形
 */
@interface WRSegmentedControl : UIControl
#pragma mark - property
/**
 * @brief 选项个数
 */
@property (assign, nonatomic, readonly) NSUInteger numberOfSegments;
/**
 * @brief 选中索引
 */
@property (assign, nonatomic) NSInteger selectedIndex;
/**
 * @brief 线宽
 */
@property (assign, nonatomic, readonly) CGFloat lineWidth;
/**
 * @brief 间隔线宽,default 2px
 */
@property (assign, nonatomic, readonly) CGFloat spaceLineWidth;
/**
 * @brief 凸起部分高度,default 0px
 */
@property (assign, nonatomic, readonly) CGFloat raisedHeight;
/**
 * @brief 正常颜色, default orangeColor
 */
@property (strong, nonatomic, readonly) UIColor *normalColor;
/**
 * @brief 选中颜色, default blueColor
 */
@property (strong, nonatomic, readonly) UIColor *selectedColor;
/**
 * @brief 正常文本颜色, default whiteColor
 */
@property (strong, nonatomic, readonly) UIColor *normalTitleColor;
/**
 * @brief 选中文本颜色, default whiteColor
 */
@property (strong, nonatomic, readonly) UIColor *selectedTitleColor;
/**
 * @brief 开始角度, default -M_PI_2
 */
@property (assign, nonatomic, readonly) CGFloat startAngle;
/**
 * @brief 结束角度, default M_PI_2
 */
@property (assign, nonatomic, readonly) CGFloat endAngle;
#pragma mark - function
/**
 * @brief 初始化方法
 *
 * @param items 标题<字符串>数组
 *
 * @retrun WRSegmentedControl 实例
 */
- (instancetype)initWithItems:(NSArray <NSString *> *)items;
/**
 * @brief 设置线宽
 *
 * @param lineWidth 线宽
 */
- (void)setLineWidth:(CGFloat)lineWidth;
/**
 * @brief 间隔线宽
 *
 * @param spaceLineWidth 线宽
 */
- (void)setSpaceLineWidth:(CGFloat)spaceLineWidth;
/**
 * @brief 凸起部分高度
 *
 * @param raisedHeight 高度
 */
- (void)setRaisedHeight:(CGFloat)raisedHeight;
/**
 * @brief 设置颜色
 *
 * @param color 颜色
 * @param highlight 是否高亮
 */
- (void)setColor:(UIColor *)color forState:(BOOL)highlight;
/**
 * @brief 设置标题颜色
 *
 * @param color 颜色
 * @param highlight 是否高亮
 */
- (void)setTitleColor:(UIColor *)color forState:(BOOL)highlight;
/**
 * @brief 设置开始角度
 *
 * @param startAngle 开始角度
 */
- (void)setStartAngle:(CGFloat)startAngle;
/**
 * @brief 设置结束角度
 *
 * @param endAngle 结束角度
 */
- (void)setEndAngle:(CGFloat)endAngle;
@end
