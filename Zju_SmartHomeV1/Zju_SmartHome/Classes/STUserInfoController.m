//
//  STUserInfoController.m
//  个人信息demo
//
//  Created by 123 on 16/1/8.
//  Copyright © 2016年 HST. All rights reserved.
//

#import "STUserInfoController.h"
#import "STUserInfoView.h"
#import "STUserInfoCell.h"
#import "UIImage+ST.h"
#import "CYFChangeMailViewController.h"
#import "JYChangePwdViewController.h"
#import "CYFMainViewController.h"
#import "AppDelegate.h"
#import "JYLoginViewController.h"
#import "YSChangeUserPhotoViewController.h"
#import "SDWebImageManager.h"
#import "LYSImageStore.h"
#import "AFNetworking.h"

@interface STUserInfoController ()<UITableViewDataSource,UITableViewDelegate,STUserInfoViewDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate, YSChangeUserPhotoViewController>

@property(nonatomic,strong)STUserInfoView *userView;
@property(nonatomic,strong)NSArray *optionArray;
//有关照片切换背景图的属性；
@property (nonatomic,strong) UIPopoverController *imagePickerPopover;
@property (nonatomic,strong) UIAlertController *alert;

@end

@implementation STUserInfoController

-(NSArray *)optionArray
{
    if (_optionArray==nil) {
        NSArray *optArr=[NSArray arrayWithObjects:@"修改头像", @"修改邮箱",@"修改密码",nil];
        _optionArray=optArr;
    }
    return _optionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarItemButton];
    
    STUserInfoView *userView=[STUserInfoView initWithUserView];
    userView.frame=self.view.bounds;
    
    //用户名
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [userView.userName setTitle:appDelegate.username forState:UIControlStateNormal];
    
    //头像
    
    [userView.portraitBtn.layer setCornerRadius:CGRectGetHeight([userView.portraitBtn bounds])*0.5];
    userView.portraitBtn.layer.masksToBounds=YES;
    [userView.portraitBtn setBackgroundImage:[[LYSImageStore sharedStore] imageForKey:@"YSUserPhoto"] forState:UIControlStateNormal];
    
    //userView的代理
    userView.delegate=self;
    //tableView的代理
    userView.userActTableView.delegate=self;
    userView.userActTableView.dataSource=self;
    self.userView=userView;
    [self.view addSubview:userView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.optionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID=@"infoCell";
    STUserInfoCell *infoCell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (infoCell==nil) {
        infoCell=[STUserInfoCell initWithUserInfoCell];
        [infoCell.descBtn setTitle:self.optionArray[indexPath.row] forState:UIControlStateNormal];
        
        UIColor *color=[[UIColor alloc]initWithRed:(0/255.0f) green:(0/255.0f) blue:(0/255.0f) alpha:1.0];
        infoCell.selectedBackgroundView=[[UIView alloc]initWithFrame:infoCell.frame];
        infoCell.selectedBackgroundView.backgroundColor=color;
    }
    return infoCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat originH=45;
    CGFloat originW=320;
    CGFloat newH=(self.view.frame.size.width*originH)/originW;
    return newH;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        NSLog(@"修改头像");
        //从图库或者拍照取照片
        if ([self.imagePickerPopover isPopoverVisible]) {
            [self.imagePickerPopover dismissPopoverAnimated:YES];
            self.imagePickerPopover = nil;
            return;
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.editing = YES;
        //imagePicker.delegate = self;
        //这里可以设置是否允许编辑图片；
        imagePicker.allowsEditing = false;
        
        /**
         *  应该在这里让用户选择是打开摄像头还是图库；
         */
        //初始化提示框；
        self.alert = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
        
        [self.alert addAction:[UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //跳到ShowPhoto页面；
            YSChangeUserPhotoViewController *showPhoto = [[YSChangeUserPhotoViewController alloc] init];
            showPhoto.openType = UIImagePickerControllerSourceTypeCamera;//从照相机打开；
            showPhoto.delegate=self;
            [self.navigationController pushViewController:showPhoto animated:true];
        }]];
        
        [self.alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //跳到ShowPhoto页面；
            YSChangeUserPhotoViewController *showPhoto = [[YSChangeUserPhotoViewController alloc] init];
            showPhoto.openType = UIImagePickerControllerSourceTypePhotoLibrary;
            showPhoto.delegate=self;
            [self.navigationController pushViewController:showPhoto animated:true];
        }]];
        
        [self.alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil]];
        
        //弹出提示框；
        [self presentViewController:self.alert animated:true completion:nil];
    }
    else if (indexPath.row==1)
    {
        CYFChangeMailViewController *changEmailVc=[[CYFChangeMailViewController alloc]init];
        [self.navigationController pushViewController:changEmailVc animated:YES];
    }
    else
    {
        JYChangePwdViewController *changPwdVc=[[JYChangePwdViewController alloc]init];
        [self.navigationController pushViewController:changPwdVc animated:YES];
    }
}
#pragma mark-STUserInfoView的代理方法
-(void)goBack
{
    //沙盒路径
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *file=[doc stringByAppendingPathComponent:@"account.data"];
    
    //清空沙盒内容
    NSFileManager * fileManager = [[NSFileManager alloc]init];
    [fileManager removeItemAtPath:file error:nil];
    
    self.view.window.rootViewController=[[JYLoginViewController alloc]init];
}

-(void)changeUserPhoto:(UIImage *)image
{
    //为新图片创建一个标示文件名的值
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *imageName = [uuid UUIDString];
    
    [[LYSImageStore sharedStore] setImage:image forKey:@"YSUserPhoto"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    
    params[@"is_app"]=@"1";
    params[@"image_name"] = imageName;
    
    NSString *string=[[LYSImageStore sharedStore]imagePathForKey:@"YSUserPhoto"];
    NSURL *filePath = [NSURL fileURLWithPath:string];
    NSLog(@"发送图片%@", filePath);
    
    [manager POST:@"http://60.12.220.16:8888/paladin/portrait" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileURL:filePath name:@"file" error:nil];
     }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success: %@ %@", responseObject,responseObject[@"msg"]);
         NSLog(@"这里发送完图片了");
         
         if ([responseObject[@"msg"] isEqualToString:@"success"])
         {
             NSLog(@"缓存图片");
             //[[LYSImageStore sharedStore] setImage:image forKey:@"YSUserPhoto"];
             [self.userView.portraitBtn setBackgroundImage:[[LYSImageStore sharedStore] imageForKey:@"YSUserPhoto"] forState:UIControlStateNormal];
         }
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];

}

- (void)setNaviBarItemButton
{
    UILabel *titleView=[[UILabel alloc]init];
    [titleView setText:@"个人信息"];
    titleView.frame=CGRectMake(0, 0, 100, 16);
    titleView.font=[UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleView;
    
    
    UIButton *leftButton=[[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame=CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];

    self.navigationItem.leftBarButtonItem = leftItem;
}
-(void)leftBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
//    for (UIViewController *controller in self.navigationController.viewControllers)
//    {
//        
//        [self.navigationController popViewControllerAnimated:YES];
////        if ([controller isKindOfClass:[CYFMainViewController
////                                       class]])
////        {
////            [self.navigationController popToViewController:controller animated:YES];
////            
////        }
//        
//    }
}

@end
