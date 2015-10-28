//
//  DropdownMenuView.h
//  DropdownMenuView
//
//  Created by OrangeLife on 15/10/27.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropdownMenuView : UIView
@property (strong, nonatomic) UIColor *cellColor;
@property (strong, nonatomic) UIColor *cellSeparatorColor;
@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) NSTimeInterval animationDuration;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *textFont;
@property (assign, nonatomic) CGFloat backgroundAlpha;
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end
