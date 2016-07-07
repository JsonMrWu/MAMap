//
//  myAnnotationView.m
//  高德地图
//
//  Created by mac on 16/6/25.
//  Copyright © 2016年 Mr.wu. All rights reserved.
//

#import "myAnnotationView.h"

#define  Arror_height 10 //箭头高度

@implementation myAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(instancetype)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)rect Info:(empty*)empty
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        self.frame = rect;
        self.emp = empty;
        [self initSubview:empty];
    }
    return  self;
}


-(void)initSubview:(empty *)emp
{
    self.centerOffset = CGPointMake(0, -50);//设置中心点偏移量
    self.canShowCallout = NO;///不显示气泡
    self.backgroundColor = [UIColor clearColor];///透明色
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) *2/3, CGRectGetHeight(self.bounds)-10)];
    self.label.font = [UIFont systemFontOfSize:12];
    self.label.text = emp.address;
    self.label.numberOfLines = 0;
    [self addSubview:self.label];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame =CGRectMake(CGRectGetWidth(self.bounds) *2/3, 0, CGRectGetWidth(self.bounds) *1/3, CGRectGetHeight(self.bounds)-10);
    [button setTitle:@"切换" forState: UIControlStateNormal];
    [button setTitle:@"变" forState: UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}
-(void)buttonClicked{
    
    if (self.delegated  && [self.delegated respondsToSelector:@selector(myAnnotationClicked:)])
    {
        [self.delegated myAnnotationClicked:self];
    }
}





//绘制文本上下文
-(void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}

//设置画线路径并画线
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

//重载父类的方法，用于视图绘制(此方法会自动调用，绘制当前视图内容)
- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

















@end
