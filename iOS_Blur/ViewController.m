//
//  ViewController.m
//  iOS_Blur
//
//  Created by 王若风 on 1/31/16.
//  Copyright © 2016 王若风. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+ImageEffects.h"

@interface ViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self blurUseCoreImage];
//    [self blurUseImageCategoary];
//    [self blurUseUIVisualEffectView];
    
}

- (void)blurUseCoreImage {
    
    //
    UIImage *avatar = [UIImage imageNamed:@"avatar"];
    
    /********** CoreImage ************/
    
    // CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:avatar];
    
    // CIFilter
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    
    // 设置模糊滤镜半径
    [blurFilter setValue:@(20) forKey:@"inputRadius"];
    
    // 将图片输入到滤镜
    [blurFilter setValue:ciImage forKey:kCIInputImageKey];
    
    // 将处理好的图片输出
    CIImage *outCiImage = [blurFilter valueForKey:kCIOutputImageKey];
    
    // 查询可以设置的参数和一些信息
    NSLog(@"%@",[blurFilter attributes]);
    
    // CIContext
    CIContext *contex = [CIContext contextWithOptions:nil];
    
    // 获取CGImage句柄
    CGImageRef outCGImage = [contex createCGImage:outCiImage fromRect:[outCiImage extent]];
    
    // 最终获取到图片
    UIImage *blurImage = [UIImage imageWithCGImage:outCGImage];
    
    // 释放CGImage句柄
    CGImageRelease(outCGImage);
    
    
    /************** end *****************/
    
    // 初始化UIImageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 500/2.f, 500/2.f)];
    imageView.image = blurImage;
    imageView.center = self.view.center;
    
    [self.view addSubview:imageView];
}

- (void)blurUseImageCategoary {
    
    // 原始图片
    UIImage *sourceImage = [UIImage imageNamed:@"IMG_2070_new"];
    
    // 部分区域模糊
    UIImage *blurImage = [sourceImage blurImageAtFrame:CGRectMake(0, 0, 200, 200)];
//    UIImage *blurImage = [sourceImage blurImage];
    
    //
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    imageView.image = blurImage;
    imageView.center = self.view.center;
    
    [self.view addSubview:imageView];
    
}


- (void)blurUseUIVisualEffectView {

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cafeHouse.jpg"]];
    self.scrollView.contentSize = imageView.image.size;
    self.scrollView.bounces = NO;
    [self.scrollView addSubview:imageView];
    [self.view addSubview:self.scrollView];
    
    
   
    
    // 1.创建模糊view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    
    // 2.设置尺寸
    effectView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200);
    
    // 3.添加到view当中
    [self.view addSubview:effectView];
    
    
    // 添加一个文本标签
    UILabel *label = [[UILabel alloc] initWithFrame:effectView.bounds];
    label.text = @"www.blog.wangruofeng007";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:30];
    [effectView.contentView addSubview:label];
    
    /***************** 添加模糊效果 *****************/
    
    // 1.创建子模糊view
    UIVisualEffectView *subEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)effectView.effect]];
    
    // 2.设定尺寸
    subEffectView.frame = effectView.bounds;
    
    // 3.将子模糊view添加到effectView的contenView才能生效
    [effectView.contentView addSubview:subEffectView];
    
    // 4.添加要显示的view来达到特殊的效果
    [subEffectView.contentView addSubview:label];
}

@end
