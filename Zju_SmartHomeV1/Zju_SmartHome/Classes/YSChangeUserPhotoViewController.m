//
//  YSChangeUserPhotoViewController.m
//  Zju_SmartHome
//
//  Created by lysongzi on 16/1/21.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import "YSChangeUserPhotoViewController.h"
#import "STUserInfoController.h"

#define SCREEN_WIDTH self.view.frame.size.width
#define SCREEN_HEIGHT self.view.frame.size.height

@interface YSChangeUserPhotoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIImage *image;
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (nonatomic,assign) BOOL isOpenCameraOrAlbum;
@end

@implementation YSChangeUserPhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBar];
    
}
-(void)setNavigationBar
{
    UIButton *leftButton=[[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame=CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    UILabel *titleView=[[UILabel alloc]init];
    [titleView setText:@"修改头像"];
    titleView.frame=CGRectMake(0, 0, 100, 16);
    titleView.font=[UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleView;
    
    //保存按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                  style:UIBarButtonItemStyleDone
                                                                 target:self
                                                                 action:@selector(rightBtnClicked)];
    self.navigationItem.rightBarButtonItem=rightItem;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!self.isOpenCameraOrAlbum) {
        if ([self.imagePickerPopover isPopoverVisible]) {
            [self.imagePickerPopover dismissPopoverAnimated:YES];
            self.imagePickerPopover = nil;
            return;
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.editing = YES;
        imagePicker.delegate = self;
        //这里可以设置是否允许编辑图片；
        imagePicker.allowsEditing = false;
        
        imagePicker.sourceType = self.openType;
        
        //创建UIPopoverController对象前先检查当前设备是不是ipad
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            self.imagePickerPopover.delegate = self;
        }
        else{
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        self.isOpenCameraOrAlbum = !self.isOpenCameraOrAlbum;
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    self.image=[self getThumbailFromImage:image];
    
    NSLog(@"%f  %f",self.image.size.width,self.image.size.height);
    //将照片放入UIImageView对象中；
    // self.imageView.image = image;
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
    [imageView setImage:self.image];
    [self.view addSubview:imageView];
    self.imageView=imageView;
    
    if (self.openType == UIImagePickerControllerSourceTypeCamera) {
        
        //将图片保存到图库
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
    }else if(self.openType == UIImagePickerControllerSourceTypePhotoLibrary){
        
        //本身是从图库打开的，就不用保存到图库了；
        
    }
    
    //判断UIPopoverController对象是否存在
    if (self.imagePickerPopover) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    }
    else
    {
        //关闭以模态形式显示的UIImagePickerController
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (UIImage *)getThumbailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    CGRect newRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    //创建透明位图上下文
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    //创建圆角矩形的对象
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    //裁剪图形上下文
    [path addClip];
    
    //让图片在缩略图绘制范围内居中
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    //在上下文中绘制图片
    [image drawInRect:projectRect];
    
    //从上下文获取图片，并复制给item
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //清理图形上下文
    UIGraphicsEndImageContext();
    
    return smallImage;
}

#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf
{
    
}

-(void)leftBtnClicked
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[STUserInfoController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
-(void)rightBtnClicked
{
    NSLog(@"点击保存了");
    if([self.delegate respondsToSelector:@selector(changeUserPhoto:)])
    {
        [self.delegate changeUserPhoto:self.image];
        for (UIViewController *controller in self.navigationController.viewControllers)
        {
            if ([controller isKindOfClass:[STUserInfoController class]])
            {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}

@end
