

//
//  PhotoViewController.m
//  Zju_SmartHome
//
//  Created by chenyufeng on 15/12/12.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "PhotoViewController.h"
#import "HttpRequest.h"
#import "MBProgressHUD+MJ.h"
#import "STNewSceneView.h"
#import "JYPatternSqlite.h"
#import "YSRGBPatternViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface PhotoViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate,STSaveNewSceneDelegate>


@property(nonatomic,strong)UIImageView *imageView;
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (nonatomic,assign) BOOL isOpenCameraOrAlbum;

@property(nonatomic,strong)STNewSceneView *sceneView;

@property(nonatomic,copy)NSString *patternName;
@property(nonatomic,copy)NSString *rValue;
@property(nonatomic,copy)NSString *gValue;
@property(nonatomic,copy)NSString *bValue;

//显示当前选择颜色的UIView
@property(nonatomic,strong)UIView *viewCircle;
@property(nonatomic,strong)UIImageView *backgroundImageV;
@property(nonatomic,assign)CGFloat scale;
@end

@implementation PhotoViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
    
    NSLog(@"/.... %@",self.tableName);
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
    [titleView setText:@"照片取色"];
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
-(void)rightBtnClicked
{
    NSLog(@"===%@ %@ %@ %@ %@",self.logic_id,self.patternName,self.rValue,self.gValue,self.bValue);
    STNewSceneView *stView=[STNewSceneView saveNewSceneView];
    stView.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UIView animateWithDuration:0.5 animations:^{
        [stView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
    }completion:^(BOOL finished) {
        self.navigationController.navigationBar.hidden=YES;
    }];
    
    stView.delegate=self;
    self.sceneView=stView;
    [self.view addSubview:stView];
    self.navigationItem.rightBarButtonItem.enabled=NO;
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
//计算imageView的frame
-(CGRect)getImageByScaleFromImage:(UIImage *)image
{
    CGFloat widthScale = image.size.width / SCREEN_WIDTH;
    CGFloat heightScale = image.size.height / SCREEN_HEIGHT;
    self.scale = MAX(widthScale, heightScale);
    return CGRectMake(0, (SCREEN_HEIGHT - (image.size.height - 64) / self.scale) / 2.0, image.size.width / self.scale, image.size.height / self.scale);
}
//修正图片的旋转方向
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;  
    }  
    
    // And now we just create a new UIImage from the drawing context  
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);  
    UIImage *img = [UIImage imageWithCGImage:cgimg];  
    CGContextRelease(ctx);  
    CGImageRelease(cgimg);  
    return img;  
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{

    UIImage *firstImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *image = [self fixOrientation:firstImage];
    NSLog(@"123  %f %f",image.size.width,image.size.height);
    
        //将照片放入UIImageView对象中；
    self.imageView=[[UIImageView alloc]init];

    self.imageView.frame=[self getImageByScaleFromImage:image];
    self.imageView.image = image;
    self.backgroundImageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.imageView.frame.origin.y, image.size.width, image.size.height)];
    self.backgroundImageV.image = image;
    UIView *coverView = [[UIView alloc]initWithFrame:self.backgroundImageV.frame];
    coverView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundImageV];
    [self.view addSubview:coverView];
    [self.view addSubview:self.imageView];
   // self.imageView=imageView;
    
    UIView *viewCircle=[[UIView alloc]init];
    viewCircle.backgroundColor=[UIColor clearColor];
    viewCircle.layer.borderColor=[[UIColor blackColor]CGColor];
    viewCircle.layer.borderWidth=1.5;
    viewCircle.frame=CGRectMake(0,64, 25, 25);
    [viewCircle.layer setCornerRadius:CGRectGetHeight([viewCircle bounds]) / 2];
    viewCircle.layer.masksToBounds=YES;
    self.viewCircle=viewCircle;
    [self.imageView addSubview:self.viewCircle];

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
    CGRect newRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    
    float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
    
    //创建透明位图上下文
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    //创建圆角矩形的对象
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:0.0];
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
    
    NSLog(@"8888 %f %f",smallImage.size.width,smallImage.size.height);
    
    return smallImage;
}

#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf
{
  
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"不管怎样都会来到这里吧");
    //触点对象
    UITouch *touch=touches.anyObject;
    //触点位置
    CGPoint touchLocation=[touch locationInView:self.imageView];
    NSLog(@"%f %f",touchLocation.x,touchLocation.y);
    //触点颜色
    UIColor *positionColor=[self getPixelColorAtLocation:touchLocation];
    
    const CGFloat *components=CGColorGetComponents(positionColor.CGColor);
    
    NSString *rValue=[NSString stringWithFormat:@"%d",(int)(components[0]*255)];
    NSString *gValue=[NSString stringWithFormat:@"%d",(int)(components[1]*255)];
    NSString *bValue=[NSString stringWithFormat:@"%d",(int)(components[2]*255)];
    NSLog(@"我看看结果:%@ %@ %@",rValue,gValue,bValue);
    
    self.viewCircle.center = CGPointMake(touchLocation.x, touchLocation.y);
    self.viewCircle.backgroundColor = [self getPixelColorAtLocation:touchLocation];
    
    self.rValue=rValue;
    self.gValue=gValue;
    self.bValue=bValue;

  NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[rValue intValue]]];
  NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[gValue intValue]]];

  NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[bValue intValue]]];

  [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
                            success:^(AFHTTPRequestOperation *operation, id responseObject) {

                              NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                              NSLog(@"成功: %@", string);


                            }
                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                              NSLog(@"失败: %@", error);
                              [MBProgressHUD showError:@"请检查网关"];

                            }];


}

- (UIColor*) getPixelColorAtLocation:(CGPoint)point
{
    UIColor* color = [UIColor whiteColor];
    if (point.x < self.imageView.frame.size.width && point.x > 0 && point.y < self.imageView.frame.size.height && point.y > 0) {
        UIImageView *colorImageView=self.backgroundImageV;
        CGImageRef inImage = colorImageView.image.CGImage;
        // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
        CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
        if (cgctx == NULL)
        {
            return nil;
        }
        size_t w = CGImageGetWidth(inImage);
        size_t h = CGImageGetHeight(inImage);
        CGRect rect = {{0,0},{w,h}};
        
        // Draw the image to the bitmap context. Once we draw, the memory
        // allocated for the context for rendering will then contain the
        // raw image data in the specified color space.
        CGContextDrawImage(cgctx, rect, inImage);
        
        // Now we can get a pointer to the image data associated with the bitmap
        // context.
        unsigned char* data = CGBitmapContextGetData (cgctx);
        if (data != NULL)
        {
            //offset locates the pixel in the data from x,y.
            //4 for 4 bytes of data per pixel, w is width of one row of data.
            @try
            {
                int offset = 4*((w*round(point.y * self.scale))+round(point.x * self.scale));
                //NSLog(@"offset: %d", offset);
                int alpha =  data[offset];
                int red = data[offset+1];
                int green = data[offset+2];
                int blue = data[offset+3];
                //            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
                color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
            }
            @catch (NSException * e)
            {
                NSLog(@"%@",[e reason]);
            }
            @finally
            {
                
            }
            
        }
        
        // When finished, release the context
        CGContextRelease(cgctx);
        // Free image data memory for the context
        if (data)
        {
            free(data);
        }

    }
    
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage
{
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     =(int)(bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}



//实现STNewSceneView的代理方法
-(void)cancelSaveScene
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.sceneView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    } completion:^(BOOL finished) {
        [self.sceneView removeFromSuperview];
    }];
    self.navigationItem.rightBarButtonItem.enabled=YES;
    self.navigationController.navigationBar.hidden=NO;
}
-(void)noSave
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.sceneView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    } completion:^(BOOL finished) {
        [self.sceneView removeFromSuperview];
    }];
    self.navigationItem.rightBarButtonItem.enabled=YES;
    self.navigationController.navigationBar.hidden=NO;
}
-(void)saveNewScene:(NSString *)sceneName
{
    self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.rightBarButtonItem.enabled=YES;
    NSLog(@"－－－－%@",sceneName);
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    
    //2.说明服务器返回的是json参数
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    
    //3.封装请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"is_app"]=@"1";
    params[@"sceneconfig.room_name"]=@"-1";
    params[@"sceneconfig.equipment_logic_id"]=self.logic_id;
    params[@"sceneconfig.scene_name"]=sceneName;
    params[@"sceneconfig.param1"]=self.rValue;
    params[@"sceneconfig.param2"]=self.gValue;
    params[@"sceneconfig.param3"]=self.bValue;
    params[@"sceneconfig.image"]=@"rouhe_bg";
    NSLog(@"---%@ %@ %@",self.rValue,self.gValue,self.bValue);
    
    //4.发送请求
    [mgr POST:@"http://60.12.220.16:8888/paladin/Sceneconfig/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"看看返回的数据是啥呢？%@",responseObject);
         if([responseObject[@"code"] isEqualToString:@"0"])
         {
             JYPatternSqlite *jySqlite=[[JYPatternSqlite alloc]init];
             jySqlite.patterns=[[NSMutableArray alloc]init];
             
             //打开数据库
             [jySqlite openDB];
             
             [jySqlite insertRecordIntoTableName:self.tableName withField1:@"logic_id" field1Value:self.logic_id andField2:@"name" field2Value:sceneName andField3:@"bkgName" field3Value:@"rouhe_bg" andField4:@"param1" field4Value:self.rValue andField5:@"param2" field5Value:self.gValue andField6:@"param3" field6Value:self.bValue];
             
             for (UIViewController *controller in self.navigationController.viewControllers)
             {
                 if ([controller isKindOfClass:[YSRGBPatternViewController class]])
                 {
                     YSRGBPatternViewController *vc=(YSRGBPatternViewController *)controller;
                     vc.tag_Back=2;
                     [self.navigationController popToViewController:controller animated:YES];
                 }
             }
         }
         else
         {
             [MBProgressHUD showError:@"增加模式失败"];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD showError:@"增加模式失败"];
     }];

}

-(void)leftBtnClicked
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[YSRGBPatternViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
@end
