//
//  SearchViewController.h
//  IMDemo
//
//  Created by 51jk on 2016/12/6.
//  Copyright © 2016年 田耀琦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
typedef void(^Block)(AMapPOI *);
@interface SearchViewController : UIViewController
@property (nonatomic ,copy)Block block;
@end
