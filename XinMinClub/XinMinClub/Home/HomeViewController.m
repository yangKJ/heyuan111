//
//  HomeViewController.m
//  XinMinClub
//
//  Created by yangkejun on 16/3/19.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "HomeViewController.h"
#import "MyViewController.h"
#import "HeyuanViewController.h"

@interface HomeViewController () <SetViewDelegate, MyDelegate> {
    SetViewController *setVC;
    MyViewController *myViewController;
    UserViewController *userController;
    UIButton *button2;
    UIImageView *image2;
    UIImageView *image22;
    UILabel *label2;
    UILabel *label1;
    UIImageView *image1;
    playerViewController *p;
    NSArray *songsMenu;  // 歌单
}

@end

@implementation HomeViewController

- (NSArray<NSString *> *)titles {
    return @[@"个人",@"和源",@"发现"];
}

- (instancetype)init{
    if (self = [super init]) {
        // 设置第三方库的WMPageController的一些属性
        self.menuItemWidth = 60;
        self.titleSizeSelected = 15.0;
        self.showOnNavigationBar = YES;
        self.pageAnimatable = YES;
        self.titleSizeSelected = 19;
        self.titleSizeNormal = 18;
        self.menuBGColor = [UIColor clearColor];
        self.titleColorNormal = RGB255_COLOR(88, 88, 88, 1);
        self.titleColorSelected = RGB255_COLOR(1, 0, 0, 1);
        self.selectIndex=1;
        self.preloadPolicy = 1;
    }
    p = [playerViewController defaultDataModel];
    [p addObserver:self forKeyPath:@"songTimes" options:NSKeyValueObservingOptionNew context:nil];
    [p addObserver:self forKeyPath:@"isPlay" options:NSKeyValueObservingOptionNew context:nil];
    [p addObserver:self forKeyPath:@"currentSongs" options:NSKeyValueObservingOptionNew context:nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarButtonItems];
    if (!userController) userController = [[UserViewController alloc] init];
    [DataModel defaultDataModel].activityPlayer=0;
}

- (void)didReceiveMemoryWarning {
    p = [playerViewController defaultDataModel];
    [p removeObserver:self forKeyPath:@"songTimes"];
    [p removeObserver:self forKeyPath:@"currentSongs"];
    [p removeObserver:self forKeyPath:@"isPlay"];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.toolbarHidden = YES;
}

// 设置按钮
- (void)setBarButtonItems {
    // 左侧消息按钮
    UIImage *rightImage = [[UIImage imageNamed:@"shezhi"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(SetAction:)];
    self.navigationItem.leftBarButtonItem = rightButtonItem;
    
    // 右侧消息按钮
    UIImage *leftImage = [[UIImage imageNamed:@"toumingtu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(PlayAction:)];
    self.navigationItem.rightBarButtonItem = leftButtonItem;
    
    // 设置最下面的toolBar
    self.navigationController.toolbarHidden = NO;
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    //    self.navigationController.toolbar.backgroundColor = RGB255_COLOR(255, 255, 255, 1);
    
    UIBarButtonItem *barButtonItem=[[UIBarButtonItem alloc]init];
    UIView *toolBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    toolBarView.backgroundColor = [UIColor clearColor];
    
    CGFloat tw = toolBarView.frame.size.width;
    CGFloat th = toolBarView.frame.size.height;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button1.backgroundColor = [UIColor colorWithWhite:0.826 alpha:0.200];
    button1.frame = CGRectMake(0, 0, tw*6/8, th);
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button2.backgroundColor = [UIColor colorWithWhite:0.826 alpha:0.200];
    button2.frame = CGRectMake(tw*4/5, 0, tw/8, th);
    button2.enabled = NO;
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
//        button3.backgroundColor = [UIColor colorWithWhite:0.826 alpha:0.200];
    button3.frame = CGRectMake(tw*4/5, 0, tw/8, th);
    
    [button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(button3Action:) forControlEvents:UIControlEventTouchUpInside];
    
    image1 = [[UIImageView alloc]initWithFrame:CGRectMake(-10, 2.5, th-5, th-5)];
    image1.layer.masksToBounds = YES;
    image1.layer.cornerRadius =  (th-5)/2.0;
    image1.image = cachePicture_100x100;
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(th-8, 0, tw-tw/4-th-2, th/2)];
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(th-4, th/2, tw-tw/4-th-6, th/2)];
    label1.font = [UIFont systemFontOfSize:13];
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor colorWithWhite:0.573 alpha:0.800];
    label1.text = @"未播放";
    label2.text = @"未播放";
    UIImage *im2 = [UIImage imageNamed:@"bofang"];
    UIImage *im22 = [UIImage imageNamed:@"bofang"];
    image2 = [[UIImageView alloc]initWithImage:im2 highlightedImage:im22];
    image2.frame = CGRectMake(-5, 0, th-5, th-5);
    image2.center = CGPointMake(button2.frame.size.width/2, button2.frame.size.height/2);
    
    UIImage *im2222 = [UIImage imageNamed:@"zanting"];
    UIImage *im222 = [UIImage imageNamed:@"zanting"];
    image22 = [[UIImageView alloc]initWithImage:im2222 highlightedImage:im222];
    image22.frame = CGRectMake(-5, 0, th-5, th-5);
    image22.center = CGPointMake(button2.frame.size.width/2, button2.frame.size.height/2);
    
    UIImage *im3 = [UIImage imageNamed:@"bofangliebiao"];
    UIImageView *image3 = [[UIImageView alloc]initWithImage:im3];
    image3.frame = CGRectMake(5, 0, th-5, th-5);
    image3.center = CGPointMake(button3.frame.size.width/2, button3.frame.size.height/2);
    
    [button1 addSubview:label1];
    [button1 addSubview:label2];
    [button1 addSubview:image1];
    [button2 addSubview:image22];
    image22.alpha=0;
    [button2 addSubview:image2];
    [button3 addSubview:image3];
    [toolBarView addSubview:button1];
    [toolBarView addSubview:button2];
//    [toolBarView addSubview:button3];
    barButtonItem.customView = toolBarView;
    toolBarView.backgroundColor = RGB255_COLOR(255, 255, 255, 1);
    
    NSArray *barButtonItemArray = [[NSArray alloc]initWithObjects:barButtonItem, nil];
    self.toolbarItems = barButtonItemArray;
}

#pragma mark SetViewDelegate

- (void)pushUserDataView {
    [self.navigationController pushViewController:userController animated:YES];
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:userController_];
    //    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark MyDelegate

- (void)pushUserController {
    [self.navigationController pushViewController:userController animated:YES];
}

#pragma mark ButtonAction
// 点击设置按钮
- (void)SetAction:(UIButton *)button {
    NSLog(@"点击了设置按钮");
    if (!setVC) {
        setVC = [[SetViewController alloc] init];
        setVC.delegate = self;
    }
    // 弹出新的视图控制器
    [self.navigationController pushViewController:setVC animated:YES];
}

// 点击播放按钮
- (void)PlayAction:(UIButton *)button {
    NSLog(@"点击了商城按钮");
//    [[LoadAnimation defaultDataModel] startLoadAnimation];
}

// toolBar上面的按钮
- (void)button1Action:(UIButton *)button {
    //    NSLog(@"点击了播放头像和歌曲");
    if([p.lastPlayGJID isEqualToString:@"ykj_luandayixieshuju"]) {
        // 第一次进入
        button2.enabled = NO;
        return;
    }
    button2.enabled = YES;
    [self.navigationController pushViewController:p  animated:YES];
}
- (void)button2Action:(UIButton *)button {
    NSLog(@"点击了播放按钮");

    p = [playerViewController defaultDataModel];
    p.isPrepare ? [p instancePlay:@"play"]: nil;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //监听,发生变化调用
    p = [playerViewController defaultDataModel];

    if ([[p.dic valueForKey:@"GJ_USER"] isEqualToString:@""]) {
        label2.text = @"和源";
    }else{
        label2.text = [p.dic valueForKey:@"GJ_USER"];
    }
    
    if ([keyPath isEqualToString:@"isPlay"]) {
        if (p.isPlay) {
            image2.alpha=0;
            image22.alpha=1;
        }else{
            image2.alpha=1;
            image22.alpha=0;
        }
    }
    
    if ([keyPath isEqualToString:@"songTimes"]) {
        label1.text = [p.dic valueForKey:@"GJ_NAME"];
//        label2.text = p.lrcArray[p.currentLyricNum];
        image1.image = p.authorImageView.image;
        if (p.isPlay) {
            image2.alpha=0;
            image22.alpha=1;
        }else{
            image2.alpha=1;
            image22.alpha=0;
        }
    }
    
    if ([keyPath isEqualToString:@"currentSongs"]) {
//       NSLog(@"歌单:%@", [change valueForKey:@"new"]  );
    }
}

- (void)button3Action:(UIButton *)button {
    NSLog(@"点击了歌曲列表");
//    [self.navigationController pushViewController:[PalyerViewController shareObject]  animated:YES];
    
}

#pragma mark - WMPageController DataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index == 0) {
        myViewController = [[MyViewController alloc] init];
        myViewController.view.backgroundColor = [UIColor colorWithWhite:0.8777 alpha:1.0];
        myViewController.userController = userController;
        myViewController.delegate = self;
//        [myViewController.view addSubview:_beijing];
        return myViewController;
    }else if (index==1) {
        HeyuanViewController *libraryViewController = [[HeyuanViewController alloc] init];
        libraryViewController.view.backgroundColor = [UIColor colorWithWhite:0.940 alpha:1.000];
        return libraryViewController;
    }else{
        courseViewController *cvc = [[courseViewController alloc]init];
        return cvc;
    }
    
}

- (void)pageController:(WMPageController *)pageController lazyLoadViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
//    if ([viewController isKindOfClass:[courseViewController class] ]) {
//        
//    }
}

- (void)pageController:(WMPageController *)pageController willCachedViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
//    NSLog(@"******************************************");
////    NSLog(@"******************************************");
//    NSLog(@"aaaaaaa%@,",info);
}

@end
