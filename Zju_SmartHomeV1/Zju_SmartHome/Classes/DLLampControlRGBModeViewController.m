//
//  DLLampControlRGBModeViewController.m
//  Zju_SmartHome
//
//  Created by TooWalker on 15/12/2.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "DLLampControlRGBModeViewController.h"
//#import "ZQSlider.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "YSRGBPatternViewController.h"
#import "AppDelegate.h"
#import "HttpRequest.h"
#import "PhotoViewController.h"
#import "STNewSceneView.h"
#import "JYPattern.h"
#import "JYPatternSqlite.h"
#import "STNewSceneController.h"

#define SCREEN_WIDTH self.view.frame.size.width
#define SCREEN_HEIGHT self.view.frame.size.height
@interface DLLampControlRGBModeViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate,STSaveNewSceneDelegate>
//RGB三个颜色值
@property (weak, nonatomic) IBOutlet UILabel *rValue;
@property (weak, nonatomic) IBOutlet UILabel *gValue;
@property (weak, nonatomic) IBOutlet UILabel *bValue;
@property (weak, nonatomic) IBOutlet UIView *panelView;
//上方显示选中颜色的View
@property (weak, nonatomic) IBOutlet UIView *colorPreview;


@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, assign) CGPoint *touchPoint;
//滑动条
@property (nonatomic, weak) UISlider *mySlider;
//存储滑动值的临时变量
@property(nonatomic,assign)int temp;

@property(nonatomic,strong)UISlider *mySlider2;
@property(nonatomic,assign)int tag;
//开关标记
@property(nonatomic,assign)int switchTag;

//有关照片取色的属性；
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (nonatomic,strong) UIAlertController *alert;

@property(nonatomic,strong)STNewSceneView *sceneView;
@end

@implementation DLLampControlRGBModeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
    NSLog(@"看看区域有没有从模式界面传到自定义界面: %@",self.area);
    
    self.view.backgroundColor=[UIColor blackColor];
   //设置导航条
  [self setNavigationBar];
   //进行初始化
  [self initView];
}

/**
 *  判断点触位置，如果点触位置在颜色区域内的话，才返回点触的控件为UIImageView *imgView
 *  除此之外，点触位置落在小圆内部或者大圆外部，都返回nil
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  UIView *hitView = nil;
  
  UIImageView *imgView = (UIImageView *)[self.view viewWithTag:10086];
  NSLog(@"%@", NSStringFromCGRect(imgView.frame));
  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.40
                                       targetPoint:point];
  
  if (pointInRound) {
    hitView = imgView;
  }
  return hitView;
}

/**
 *  判断点触位置是否落在了颜色区域内
 */
- (BOOL)touchPointInsideCircle:(CGPoint)center bigRadius:(CGFloat)bigRadius smallRadius:(CGFloat)smallRadius targetPoint:(CGPoint)point
{
  CGFloat dist = sqrtf((point.x - center.x) * (point.x - center.x) +
                       (point.y - center.y) * (point.y - center.y));
  if (dist >= bigRadius || dist <= smallRadius){
    return NO;
  }else{
    return YES;
  }
}

/**
 *  开始点击的方法
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  UITouch *touch = touches.anyObject;
  
  CGPoint touchLocation = [touch locationInView:self.imgView];
  //UIView *hitView = nil;
  
  UIImageView *imgView = (UIImageView *)[self.view viewWithTag:10086];

  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.40
                                       targetPoint:touchLocation];
  if (pointInRound) {
    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(colorImageView.frame.size.width / 2, colorImageView.frame.size.height / 2)
                           bigRadius:colorImageView.frame.size.width * 0.48
                         smallRadius:colorImageView.frame.size.width * 0.40        //0.39
                         targetPoint:touchLocation]) {
     
      self.rValue.text = [NSString stringWithFormat:@"%d", (int)(components[0] * 255)];
      self.gValue.text = [NSString stringWithFormat:@"%d", (int)(components[1] * 255)];
      self.bValue.text = [NSString stringWithFormat:@"%d", (int)(components[2] * 255)];
      
      NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.rValue.text intValue]]];
      NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.gValue.text intValue]]];
      
      NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.bValue.text intValue]]];
      
      self.colorPreview.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      self.mySlider.backgroundColor=[self getPixelColorAtLocation:touchLocation];
      self.mySlider2.backgroundColor=[self getPixelColorAtLocation:touchLocation];
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
        
      //在这里把rgb（self.rValue.text, self.gValue.text, self.bValue.text）值传给服务器
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
  }
}

/**
 *  手指在屏幕上移动的方法
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = touches.anyObject;
  
  CGPoint touchLocation = [touch locationInView:self.imgView];
 // UIView *hitView = nil;
  
  UIImageView *imgView = (UIImageView *)[self.view viewWithTag:10086];
  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.40
                                       targetPoint:touchLocation];
  if (pointInRound) {
    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(colorImageView.frame.size.width / 2, colorImageView.frame.size.height / 2)
                           bigRadius:colorImageView.frame.size.width * 0.48
                         smallRadius:colorImageView.frame.size.width * 0.40        //0.39
                         targetPoint:touchLocation]) {
      
      self.rValue.text = [NSString stringWithFormat:@"%d", (int)(components[0] * 255)];
      self.gValue.text = [NSString stringWithFormat:@"%d", (int)(components[1] * 255)];
      self.bValue.text = [NSString stringWithFormat:@"%d", (int)(components[2] * 255)];
      
      NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.rValue.text intValue]]];
      NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.gValue.text intValue]]];
      
      NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.bValue.text intValue]]];
      
      self.colorPreview.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      self.mySlider.backgroundColor=[self getPixelColorAtLocation:touchLocation];
      self.mySlider2.backgroundColor=[self getPixelColorAtLocation:touchLocation];
        
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
    
      int i, j, k;
      if ((i = arc4random() % 2)) {
        if ((j = arc4random() % 2)) {
          if ((k = arc4random() % 2)) {
            //在这里把rgb（self.rValue.text, self.gValue.text, self.bValue.text）值传给服务器
            
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
        }
      }
    }
  }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  NSLog(@"滑动结束");
  UITouch *touch = touches.anyObject;
  
  CGPoint touchLocation = [touch locationInView:self.imgView];
  //UIView *hitView = nil;
  
  UIImageView *imgView = (UIImageView *)[self.view viewWithTag:10086];
  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.40
                                       targetPoint:touchLocation];
  if (pointInRound) {
    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(colorImageView.frame.size.width / 2, colorImageView.frame.size.height / 2)
                           bigRadius:colorImageView.frame.size.width * 0.48
                         smallRadius:colorImageView.frame.size.width * 0.40        //0.39
                         targetPoint:touchLocation]) {
      
      self.rValue.text = [NSString stringWithFormat:@"%d", (int)(components[0] * 255)];
      self.gValue.text = [NSString stringWithFormat:@"%d", (int)(components[1] * 255)];
      self.bValue.text = [NSString stringWithFormat:@"%d", (int)(components[2] * 255)];
      NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.rValue.text intValue]]];
      NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.gValue.text intValue]]];
      NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.bValue.text intValue]]];
        
      self.mySlider2.backgroundColor=[self getPixelColorAtLocation:touchLocation];
      self.colorPreview.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      self.mySlider.backgroundColor=[self getPixelColorAtLocation:touchLocation];
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      
      //在这里把rgb（self.rValue.text, self.gValue.text, self.bValue.text）值传给服务器
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
  }
  
}

//*****************************获取屏幕点触位置的RGB值的方法************************************//
- (UIColor *) getPixelColorAtLocation:(CGPoint)point {
  UIColor* color = nil;
  
  UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
  
  CGImageRef inImage = colorImageView.image.CGImage;
  
  CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
  if (cgctx == NULL) {
    return nil;
  }
  size_t w = CGImageGetWidth(inImage);
  size_t h = CGImageGetHeight(inImage);
  CGRect rect = {{0,0},{w,h}};
  
  CGContextDrawImage(cgctx, rect, inImage);
  
  unsigned char* data = CGBitmapContextGetData (cgctx);
  if (data != NULL) {
    int offset = 4*((w*round(point.y))+round(point.x));
    int alpha =  data[offset];
    int red = data[offset+1];
    int green = data[offset+2];
    int blue = data[offset+3];
    
    color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
  }
  
  CGContextRelease(cgctx);
  
  if (data) { free(data); }
  return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
  
  CGContextRef    context = NULL;
  CGColorSpaceRef colorSpace;
  void *          bitmapData;
  int             bitmapByteCount;
  int             bitmapBytesPerRow;
  
  size_t pixelsWide = CGImageGetWidth(inImage);
  size_t pixelsHigh = CGImageGetHeight(inImage);
  
  bitmapBytesPerRow   = (int)(pixelsWide * 4);
  bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
  
  colorSpace = CGColorSpaceCreateDeviceRGB();
  
  if (colorSpace == NULL)
  {
    fprintf(stderr, "Error allocating color space\n");
    return NULL;
  }
  
  bitmapData = malloc( bitmapByteCount );
  if (bitmapData == NULL)
  {
    fprintf (stderr, "Memory not allocated!");
    CGColorSpaceRelease( colorSpace );
    return NULL;
  }
  context = CGBitmapContextCreate (bitmapData,
                                   pixelsWide,
                                   pixelsHigh,
                                   8,
                                   bitmapBytesPerRow,
                                   colorSpace,
                                   kCGImageAlphaPremultipliedFirst);
  if (context == NULL)
  {
    free (bitmapData);
    fprintf (stderr, "Context not created!");
  }
  CGColorSpaceRelease( colorSpace );
  return context;
}

//****************************************结束

- (void)leftBtnClicked
{
  if(self.sceneTag==40)
  {
      for (UIViewController *controller in self.navigationController.viewControllers) {
          
          if ([controller isKindOfClass:[STNewSceneController class]]) {
              
              [self.navigationController popToViewController:controller animated:YES];
              
          }
          
      }
      
  }
  else
  {
      for (UIViewController *controller in self.navigationController.viewControllers) {
          
          if ([controller isKindOfClass:[YSRGBPatternViewController class]]) {
              
              [self.navigationController popToViewController:controller animated:YES];
              
          }
          
      }
  }
}

-(void)rightBtnClicked
{
    if(self.sceneTag==40)
    {
        NSLog(@"场景中电器自定义只需要返回参数值就行吧");
        if([self.delegate respondsToSelector:@selector(backParam:andParam2:andParam3:andLogic_Id:)])
        {
            [self.delegate backParam:self.rValue.text andParam2:self.gValue.text andParam3:self.bValue.text andLogic_Id:self.logic_id];
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                
                if ([controller isKindOfClass:[STNewSceneController class]]) {
                    
                    [self.navigationController popToViewController:controller animated:YES];
                    
                }
                
            }
        }
    }
    else
    {
        NSLog(@"rgb的模式保存吧?");
        NSLog(@"===%@ %@ %@ %@ %@",self.logic_id,self.patternName,self.rValue.text,self.gValue.text,self.bValue.text);
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
}

#pragma mark - 左上角按钮点击，照片取色
- (IBAction)photoColorButtonPressed:(id)sender
{

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


  /**
   *  应该在这里让用户选择是打开摄像头还是图库；
   */
  //初始化提示框；
  self.alert = [UIAlertController alertControllerWithTitle:@"请选择打开方式" message:nil preferredStyle:  UIAlertControllerStyleActionSheet];

  [self.alert addAction:[UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

    //创建UIPopoverController对象前先检查当前设备是不是ipad
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
      self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
      self.imagePickerPopover.delegate = self;
      [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                                      animated:YES];
    }
    else{

      //跳到ShowPhoto页面；
      PhotoViewController *showPhoto = [[PhotoViewController alloc] init];
      showPhoto.logic_id=self.logic_id;
      showPhoto.furnitureName=self.furnitureName;
      showPhoto.tableName=self.tableName;
      showPhoto.openType = UIImagePickerControllerSourceTypeCamera;//从照相机打开；
      [self.navigationController pushViewController:showPhoto animated:true];
    }
  }]];

  [self.alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    //创建UIPopoverController对象前先检查当前设备是不是ipad
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
      self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
      self.imagePickerPopover.delegate = self;
      [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                      permittedArrowDirections:UIPopoverArrowDirectionAny
                                                      animated:YES];
    }
    else{
      //跳到ShowPhoto页面；
      PhotoViewController *showPhoto = [[PhotoViewController alloc] init];
      showPhoto.logic_id=self.logic_id;
        showPhoto.furnitureName=self.furnitureName;
        showPhoto.tableName=self.tableName;
      showPhoto.openType = UIImagePickerControllerSourceTypePhotoLibrary;//从图库打开；
      [self.navigationController pushViewController:showPhoto animated:true];
    }
  }]];

  [self.alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    //取消；
  }]];

  //弹出提示框；
  [self presentViewController:self.alert animated:true completion:nil];

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
    [titleView setText:@"RGB灯"];
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

-(void)initView
{
    self.switchTag=1;
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.tag = 10086;
    UIView *viewColorPickerPositionIndicator = [[UIView alloc]init];
    viewColorPickerPositionIndicator.tag = 10087;
    UIImageView *btnPlay = [[UIImageView alloc] init];
    [btnPlay setImage:[UIImage imageNamed:@"logo1"]];
    
    UISlider *mySlider=[[UISlider alloc]init];
    self.mySlider=mySlider;
    UIColor *newColor=[UIColor colorWithRed:125/255.0f green:120/255.0f blue:86/255.0f alpha:1];
    self.mySlider.backgroundColor=newColor;
    // 设置UISlider的最小值和最大值
    self.mySlider.minimumValue = 0;
    self.mySlider.maximumValue = 100;
    
    // 为UISlider添加事件方法
    [self.mySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _mySlider.minimumTrackTintColor = [UIColor clearColor];
    _mySlider.maximumTrackTintColor = [UIColor clearColor];
    [_mySlider setThumbImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    //设置圆角
    _mySlider.layer.cornerRadius=4;
    _mySlider.layer.masksToBounds=YES;
    [self.view addSubview:self.mySlider];
    
    UISlider *mySlider2=[[UISlider alloc]init];
    self.mySlider2=mySlider2;
    UIColor *newColor2=[UIColor colorWithRed:125/255.0f green:120/255.0f blue:86/255.0f alpha:1];
    self.mySlider2.backgroundColor=newColor2;
    // 设置UISlider的最小值和最大值
    self.mySlider2.minimumValue = 0;
    self.mySlider2.maximumValue = 100;
    
    // 为UISlider添加事件方法
    [self.mySlider2 addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    _mySlider2.minimumTrackTintColor = [UIColor clearColor];
    _mySlider2.maximumTrackTintColor = [UIColor clearColor];
    [_mySlider2 setThumbImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    //设置圆角
    _mySlider2.layer.cornerRadius=4;
    _mySlider2.layer.masksToBounds=YES;
    [self.view addSubview:self.mySlider2];
    
    
    if (fabs(([[UIScreen mainScreen] bounds].size.height - 480)) < 1) {
        // 4 & 4s
    }
    if (fabs(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
        // 5 & 5s & 5c
        imgView.image = [UIImage imageNamed:@"circle_55"];
        viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
        viewColorPickerPositionIndicator.layer.cornerRadius = 8;
        viewColorPickerPositionIndicator.layer.borderWidth = 2;
        btnPlay.frame = CGRectMake(111, 111, 60, 60);
        self.mySlider.frame=CGRectMake(50, 440, 220, 10);
        self.mySlider2.frame=CGRectMake(50, 483, 220, 10);
        
    }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
        // 6 & 6s
        imgView.image = [UIImage imageNamed:@"circle_66"];
        viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
        viewColorPickerPositionIndicator.layer.cornerRadius = 10;
        viewColorPickerPositionIndicator.layer.borderWidth = 2;
        btnPlay.frame = CGRectMake(135, 135, 60, 60);
        self.mySlider.frame=CGRectMake(55, 516, 265, 12);
        self.mySlider2.frame=CGRectMake(55, 565, 265, 12);
        
    }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
        // 6p & 6sp
        imgView.image = [UIImage imageNamed:@"circle_6pp"];
        viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
        viewColorPickerPositionIndicator.layer.cornerRadius = 12;
        viewColorPickerPositionIndicator.layer.borderWidth = 2;
        btnPlay.frame = CGRectMake(150, 150, 60, 60);
        self.mySlider.frame=CGRectMake(60, 571, 295, 13);
        self.mySlider2.frame=CGRectMake(60, 624, 295, 13);
        
    }
    
    if (fabs(([[UIScreen mainScreen] bounds].size.height - 480)) < 1) {
        //4 & 4s 的时候特判
        //        imgView.frame = CGRectMake(30.0f, 30.0f, imgView.image.size.width, imgView.image.size.height);
    }else {
        imgView.frame = CGRectMake(35.0f, 35.0f, imgView.image.size.width, imgView.image.size.height);
    }
    
    imgView.userInteractionEnabled = YES;
    _imgView = imgView;
    
    //  viewColorPickerPositionIndicator.backgroundColor = [UIColor colorWithRed:0.588 green:0.882 blue:0.380 alpha:1.000];
    viewColorPickerPositionIndicator.backgroundColor = [UIColor clearColor];
    
    
    [btnPlay setImage:[UIImage imageNamed:@"logo1"]];
    
    [self.panelView addSubview:imgView];
    [self.panelView addSubview:viewColorPickerPositionIndicator];
    [self.panelView addSubview:btnPlay];

}
#pragma mark-STNewSceneView的代理方法
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
    //self.navigationController.navigationBar.hidden=NO;
    self.navigationItem.rightBarButtonItem.enabled=YES;
    NSLog(@"－－－－%@",sceneName);
    
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    
    //2.说明服务器返回的是json参数
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    
    //3.封装请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"is_app"]=@"1";
    params[@"sceneconfig.room_name"]=self.area;
    params[@"sceneconfig.tag"]=@"0";
    params[@"sceneconfig.equipment_logic_id"]=self.logic_id;
    params[@"sceneconfig.scene_name"]=sceneName;
    params[@"sceneconfig.param1"]=self.rValue.text;
    params[@"sceneconfig.param2"]=self.gValue.text;
    params[@"sceneconfig.param3"]=self.bValue.text;
    params[@"sceneconfig.image"]=@"rouhe_bg";
    NSLog(@"---%@ %@ %@ %@",self.rValue.text,self.gValue.text,self.bValue.text,params[@"sceneconfig.tag"]);
    
    //4.发送请求
    [mgr POST:@"http://60.12.220.16:8888/paladin/Sceneconfig/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"看看返回的数据是啥呢？%@",responseObject);
         self.navigationController.navigationBar.hidden=NO;
         if([responseObject[@"code"] isEqualToString:@"0"])
         {
             JYPatternSqlite *jySqlite=[[JYPatternSqlite alloc]init];
             jySqlite.patterns=[[NSMutableArray alloc]init];
             
             //打开数据库
             [jySqlite openDB];
             
             [jySqlite insertRecordIntoTableName:self.tableName withField1:@"logic_id" field1Value:self.logic_id andField2:@"name" field2Value:sceneName andField3:@"bkgName" field3Value:@"rouhe_bg" andField4:@"param1" field4Value:self.rValue.text andField5:@"param2" field5Value:self.gValue.text andField6:@"param3" field6Value:self.bValue.text];
             
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
         [MBProgressHUD showError:@"增加模式失败,请检查服务器"];
     }];
}


- (void)sliderValueChanged:(id)sender
{
    if ([sender isKindOfClass:[UISlider class]])
    {
        UISlider * slider = (UISlider *)sender;
        if(fabs(slider.value-self.temp)>=8)
        {
            if(slider.value<=8)
            {
                slider.value=0;
            }
            else if(slider.value>=92)
            {
                slider.value=100;
            }
            self.temp=(int)slider.value;
            
            [HttpRequest sendRGBBrightnessToServer:self.logic_id brightnessValue:[NSString stringWithFormat:@"%d", (int)slider.value]
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               
                                               NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                               NSLog(@"成功: %@", string);
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               NSLog(@"失败: %@", error);
                                               [MBProgressHUD showError:@"请检查网关"];
                                           }];
        }
        
    }
}

@end
