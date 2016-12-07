//
//  CustomAnnotationView.h
//  IMDemo
//
//  Created by 51jk on 2016/12/2.
//  Copyright © 2016年 田耀琦. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"
@interface CustomAnnotationView : MAAnnotationView
@property (nonatomic, readonly) CustomCalloutView *calloutView;
@property (nonatomic, strong)UIImage *imageP;
@end
