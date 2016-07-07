//
//  myAnnotationView.h
//  高德地图
//
//  Created by mac on 16/6/25.
//  Copyright © 2016年 Mr.wu. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "empty.h"


@class myAnnotationView;

@protocol myAnnotationViewDelegate <NSObject>

@optional

-(void)myAnnotationClicked:(myAnnotationView*)view;
@end




@interface myAnnotationView : MAAnnotationView

@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) empty *emp;


-(instancetype)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)rect Info:(empty*)empty;


@property (nonatomic,assign) id<myAnnotationViewDelegate>delegated;
//@property (weak) id<myAnnotationViewDelegate>delegated;// 和上边效果是一样的
@end
