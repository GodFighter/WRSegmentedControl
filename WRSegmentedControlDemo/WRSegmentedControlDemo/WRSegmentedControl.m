//
//  WRSegmentedControl.m
//  WRSegmentedControlDemo
//
//  Created by xianghui on 2017/5/27.
//  Copyright © 2017年 xianghui. All rights reserved.
//

#import "WRSegmentedControl.h"

@interface WRSegmentedControl ()

@property (strong, nonatomic) NSArray *itemsArray; // item数组
@property (strong, nonatomic) NSArray *pathsArray; // 路径数组


@end

@implementation WRSegmentedControl

#pragma mark -
#pragma mark init
- (instancetype)initWithItems:(NSArray <NSString *> *)items {
    if (self = [self initWithFrame:CGRectZero]) {
        self.itemsArray = [NSArray arrayWithArray:items];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _selectedIndex      = 0;
        _lineWidth          = 30;
        _spaceLineWidth     = 2;
        _raisedHeight       = 0;
        
        _normalColor        = [UIColor orangeColor];
        _selectedColor      = [UIColor blueColor];
        _normalTitleColor   = [UIColor whiteColor];
        _selectedTitleColor = [UIColor whiteColor];
        
        _startAngle     = -M_PI_2;
        _endAngle       = M_PI_2;
        
    }
    return self;
}
#pragma mark -
#pragma mark draw
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawItemsWithRect:rect];
}
// 绘制items
- (void)drawItemsWithRect:(CGRect)rect {
    // 每个扇形角度
    CGFloat angle = (self.endAngle - self.startAngle) / self.itemsArray.count;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.itemsArray.count];
    
    for (NSInteger i = 0; i < self.itemsArray.count; i++) {
        BOOL selected = self.selectedIndex == i;
        CGFloat radius = CGRectGetWidth(rect) / 2 - self.lineWidth / 2 - self.raisedHeight;
        CGFloat drawRadius = selected ? radius + self.raisedHeight / 2 : radius;
        CGFloat start = self.startAngle + i * angle;
        CGFloat end = start + angle;
        
        CGContextSaveGState(context); {
            // 设置线宽
            CGContextSetLineWidth(context, selected ? self.lineWidth + self.raisedHeight : self.lineWidth);
            // 设置画笔的颜色
            CGContextSetStrokeColorWithColor(context, selected ? self.selectedColor.CGColor : self.normalColor.CGColor);
            // 绘制
            CGMutablePathRef pathRef  = CGPathCreateMutable();
            CGPathAddArc(pathRef,
                         &CGAffineTransformIdentity,
                         CGRectGetWidth(rect) / 2,
                         CGRectGetHeight(rect) / 2,
                         drawRadius,
                         start,
                         end,
                         NO);
            CGContextAddPath(context, pathRef);
            CGContextStrokePath(context);
            //            CGPathCloseSubpath(pathRef);
            
            // 保存扇形，用于判断
            NSValue *angleValue = [NSValue valueWithCGPoint:CGPointMake(start, end)];
            [array addObject:angleValue];
            
            // 画间隔线
            CGContextSaveGState(context); {
                CGPoint point = CGPointMake(CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2);
                CGPoint point1 = CGPathGetCurrentPoint(pathRef);
                CGFloat y = (point.y - point1.y) / (point.x - point1.x) * CGRectGetWidth(rect) + (point1.x * point.y - point.x * point1.y) / (point1.x - point.x);
                CGPoint point2 = CGPointMake(CGRectGetWidth(rect), y);

                CGContextSetStrokeColorWithColor(context, self.backgroundColor.CGColor);
                UIBezierPath *bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint:point];
                [bezierPath addLineToPoint:point2];
                bezierPath.lineWidth = self.spaceLineWidth;
                [bezierPath stroke];
            }
            CGContextRestoreGState(context);

            // 查找弧线中点,添加标题
            CGContextSaveGState(context); {
                CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
                CGMutablePathRef middlePathRef  = CGPathCreateMutable();
                CGPathAddArc(middlePathRef, &CGAffineTransformIdentity, CGRectGetWidth(rect) / 2, CGRectGetHeight(rect) / 2, drawRadius, start, end - angle / 2, NO);
                CGPoint middlePoint = CGPathGetCurrentPoint(middlePathRef);

                NSString *string = self.itemsArray[i];
                NSDictionary *attributesDictionary = @{NSFontAttributeName : [UIFont systemFontOfSize:11], NSForegroundColorAttributeName : selected ? self.selectedTitleColor : self.normalTitleColor};
                CGSize stringSize = [string sizeWithAttributes:attributesDictionary];

                [string drawAtPoint:CGPointMake(middlePoint.x - stringSize.width / 2, middlePoint.y - stringSize.height / 2) withAttributes:attributesDictionary];
                CGPathRelease(middlePathRef);
                CGPathRelease(pathRef);
            }
            CGContextRestoreGState(context);
        }
        CGContextRestoreGState(context);
    }
    self.pathsArray = [NSArray arrayWithArray:array];
}
#pragma mark -
#pragma mark 响应手势
- (float)radiansToDegreesFromPointX:(CGPoint)start toPointY:(CGPoint)end toCenter:(CGPoint)center {
    float rads;
    CGFloat a = (end.x - center.x);
    CGFloat b = (end.y - center.y);
    CGFloat c = (start.x - center.x);
    CGFloat d = (start.y - center.y);
    rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    if (end.y < center.y) {
        rads = - rads;
    }
    return rads;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
    double angle = [self radiansToDegreesFromPointX:CGPointMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2) toPointY:location toCenter:center];
    
    NSInteger oldIndex = self.selectedIndex;
    for (NSInteger i = 0; i < self.pathsArray.count; i++) {
        CGPoint angleRange = [self.pathsArray[i] CGPointValue];
        if (angle >= angleRange.x && angle <= angleRange.y) {
            self.selectedIndex = i;
            if (self.selectedIndex != oldIndex) {
                [self setNeedsDisplay];
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
            return;
        }
    }
}
#pragma mark -
#pragma mark settings
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if ([backgroundColor isEqual:[UIColor clearColor]]) {
        backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    }
    [super setBackgroundColor:backgroundColor];
}
- (NSUInteger)numberOfSegments {
    return self.itemsArray.count;
}
- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
}
- (void)setRaisedHeight:(CGFloat)raisedHeight {
    _raisedHeight = raisedHeight;
}
- (void)setColor:(UIColor *)color forState:(BOOL)highlight {
    if (highlight) {
        _selectedColor = color;
    } else {
        _normalColor = color;
    }
}
- (void)setTitleColor:(UIColor *)color forState:(BOOL)highlight {
    if (highlight) {
        _selectedTitleColor = color;
    } else {
        _normalTitleColor = color;
    }
}
- (void)setStartAngle:(CGFloat)startAngle {
    _startAngle = startAngle;
}
- (void)setEndAngle:(CGFloat)endAngle {
    _endAngle = endAngle;
}
- (void)setSpaceLineWidth:(CGFloat)spaceLineWidth {
    _spaceLineWidth = spaceLineWidth;
}
@end
