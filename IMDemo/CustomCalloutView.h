//
//  CustomCalloutView.h
//  IMDemo
//
//  Created by 51jk on 2016/12/2.
//  Copyright © 2016年 田耀琦. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 *    自定义气泡
 *
 */

@interface CustomCalloutView : UIView

@property (nonatomic, strong) UIImage *image; //商户图
@property (nonatomic, copy) NSString *title; //商户名
@property (nonatomic, copy) NSString *subtitle; //地址

@end
