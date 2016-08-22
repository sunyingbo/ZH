//
//  LagerImageViewController.m
//  StoryBoard助手
//
//  Created by mac on 16/4/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "LagerImageViewController.h"

@interface LagerImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *lagerImage;

@end

@implementation LagerImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.imagePath.length>0) {
        self.lagerImage.image=[UIImage imageNamed:self.imagePath];
    }
    [self.lagerImage cornerRadiusWithFloat:20];
    [self.lagerImage addUITapGestureRecognizerWithTarget:self withAction:@selector(clickImage)];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.lagerImage.alpha=0.0;
    [UIView animateWithDuration:0.2 animations:^{
        self.lagerImage.alpha=1.0;
    }];
}
- (void)clickImage{
    [UIView animateWithDuration:0.2 animations:^{
        self.lagerImage.alpha=0.2;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
//    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
