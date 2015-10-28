//
//  DropdownMenuView.m
//  DropdownMenuView
//
//  Created by OrangeLife on 15/10/27.
//  Copyright (c) 2015年 Shenme Studio. All rights reserved.
//

#import "DropdownMenuView.h"
#import "Masonry.h"

@implementation UIViewController (TopestViewController)
- (UIViewController *)topestViewController
{
    if (self.presentedViewController)
    {
        return [self.presentedViewController topestViewController];
    }
    if ([self isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tab = (UITabBarController *)self;
        return [[tab selectedViewController] topestViewController];
    }
    if ([self isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *nav = (UINavigationController *)self;
        return [[nav visibleViewController] topestViewController];
    }
    return self;
}
@end

@interface DropdownMenuView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSArray *titles;
@property (assign, nonatomic) NSUInteger selectedIndex;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *wrapperView;
@property (nonatomic, assign) BOOL isMenuShow;
@end

@implementation DropdownMenuView
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    if (self = [super initWithFrame:frame])
    {
        _animationDuration = 0.4f;
        _backgroundAlpha = 0.3f;
        _cellHeight = 44.f;
        _selectedIndex = 0;
        _titles = titles;
        _cellColor = [UIColor brownColor];
        _cellSeparatorColor = [UIColor whiteColor];
        _textColor = [UIColor whiteColor];
        _textFont = [UIFont systemFontOfSize:17.f];
        
        
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setTitle:[_titles objectAtIndex:0] forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(handleTapOnTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [_titleButton.titleLabel setFont:_textFont];
        [_titleButton setTitleColor:_textColor forState:UIControlStateNormal];
        
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdownmenuview.bundle/arrow_down_icon"]];
        
        [self addSubview:_titleButton];
        [self addSubview:_arrowImageView];
        
        [_titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleButton.mas_right).offset(5);
            make.centerY.equalTo(self.titleButton.mas_centerY);
        }];
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        UINavigationBar *navBar = [keyWindow.rootViewController topestViewController].navigationController.navigationBar;
        
        [keyWindow addSubview:self.wrapperView];
        [self.wrapperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(keyWindow);
            make.top.equalTo(navBar.mas_bottom);
        }];
        
        [self.wrapperView addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.wrapperView);
        }];
        
        CGFloat tableHeight = _cellHeight * _titles.count;
        [self.wrapperView addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.wrapperView);
            make.top.equalTo(self.wrapperView.mas_top).offset(-tableHeight);
            make.bottom.equalTo(self.wrapperView.mas_bottom).offset(tableHeight);
        }];
        [self.tableView layoutIfNeeded];
        [self.wrapperView setHidden:YES];
        
    }
    return self;
}

- (UIView *)wrapperView
{
    if (!_wrapperView)
    {
        _wrapperView = [[UIView alloc] init];
        [_wrapperView setClipsToBounds:YES];
    }
    return _wrapperView;
}

- (UIView *)backgroundView
{
    if (!_backgroundView)
    {
        _backgroundView = [[UIView alloc] init];
        [_backgroundView setBackgroundColor:[UIColor blackColor]];
        [_backgroundView setAlpha:_backgroundAlpha];
    }
    return _backgroundView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setTableFooterView:[UIView new]];
        [_tableView setSeparatorColor:_cellSeparatorColor];
        [_tableView setRowHeight:_cellHeight];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DropdowmMenuCell"];
        [_tableView setBounces:NO];
    }
    return _tableView;
}

- (void)setIsMenuShow:(BOOL)isMenuShow
{
    if (_isMenuShow != isMenuShow)
    {
        _isMenuShow = isMenuShow;
        if (isMenuShow)
        {
            [self showMenu];
        }
        else
        {
            [self hideMenu];
        }
    }
}

#pragma mark 设置选择
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex)
    {
        _selectedIndex = selectedIndex;
        [_titleButton setTitle:[_titles objectAtIndex:selectedIndex] forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
    self.isMenuShow = NO;
}

#pragma mark 显示菜单
- (void)showMenu
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.wrapperView);
        make.left.equalTo(self.wrapperView.mas_left).offset(100);
        make.right.equalTo(self.wrapperView.mas_right).offset(-100);
    }];
    [self.wrapperView setHidden:NO];
    [self.backgroundView setAlpha:0];
    [UIView animateWithDuration:_animationDuration animations:^{
        [self.arrowImageView setTransform:CGAffineTransformRotate(self.arrowImageView.transform, M_PI)];
    }];
    
    [UIView animateWithDuration:_animationDuration * 1.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.tableView layoutIfNeeded];
        [self.backgroundView setAlpha:_backgroundAlpha];
    } completion:nil];
}

#pragma mark 隐藏菜单
- (void)hideMenu
{
    CGFloat tableHeight = _cellHeight * _titles.count;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.wrapperView);
        make.top.equalTo(self.wrapperView.mas_top).offset(-tableHeight);
        make.bottom.equalTo(self.wrapperView.mas_bottom).offset(tableHeight);
    }];
    
    [UIView animateWithDuration:_animationDuration animations:^{
        [self.arrowImageView setTransform:CGAffineTransformRotate(self.arrowImageView.transform, M_PI)];
    }];
    
    [UIView animateWithDuration:_animationDuration*1.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.tableView layoutIfNeeded];
        [self.backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        [self.wrapperView setHidden:YES];
    }];
}

#pragma mark 标题按钮点击
- (void)handleTapOnTitleButton:(UIButton *)senger
{
    self.isMenuShow = !self.isMenuShow;
}

#pragma mark - TableView代理方法
#pragma mark 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

#pragma mark cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DropdowmMenuCell" forIndexPath:indexPath];
    [cell.textLabel setText:[_titles objectAtIndex:indexPath.row]];
    [cell setAccessoryType:(indexPath.row==_selectedIndex)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone];
    [cell setBackgroundColor:_cellColor];
    [cell.textLabel setFont:_textFont];
    [cell.textLabel setTextColor:_textColor];
    return cell;
}

#pragma mark tableCell点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
