//
//  DLLampControllYWModeViewController.m
//  Zju_SmartHome
//
//  Created by TooWalker on 15/12/1.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "DLLampControllYWModeViewController.h"
#import "ZQSlider.h"
#import "CYFFurnitureViewController.h"
#import "HttpRequest.h"
#import "PhotoViewController.h"
#import "MBProgressHUD+MJ.h"
#import "YSYWPatternViewController.h"


@interface DLLampControllYWModeViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
@property (nonatomic, weak) UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *panelView;
@property (weak, nonatomic) IBOutlet UILabel *LDValue; /**< light-dark-value */
@property (weak, nonatomic) IBOutlet UILabel *CWValue; /**< cold-warm-value */
@property (nonatomic, weak) UISlider *slider;


//YW控制
@property (weak, nonatomic) IBOutlet UIButton *ywAdjust;
//模式选择
@property (weak, nonatomic) IBOutlet UIButton *modeSelect;

@property(nonatomic,assign)int tag;
@property(nonatomic,assign)int switchTag;
//@property(nonatomic,assign)int sliderValueTemp;

@property(nonatomic,assign)int isPhoto;

//滑动条
@property (nonatomic, weak) UISlider *mySlider;
//存储滑动值的临时变量
@property(nonatomic,assign)int temp;
@property(nonatomic,strong)UISlider *mySlider2;

//有关照片取色的属性；
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (nonatomic,strong) UIAlertController *alert;

- (IBAction)photoClick1:(id)sender;

@end

@implementation DLLampControllYWModeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
   NSLog(@"129183892138912  %@ %@",self.logic_id,self.furnitureName);
  
  self.tag=1;
  self.switchTag = 1;
 
    
  //设置导航栏
  [self setNavigationBar];
    
  UIImageView *imgView = [[UIImageView alloc]init];
  imgView.tag = 10086;
  UIView *viewColorPickerPositionIndicator = [[UIView alloc]init];
  viewColorPickerPositionIndicator.tag = 10087;
  UIButton *btnPlay = [[UIButton alloc] init];
    
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
  
  if (fabs(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
    // 5 & 5s & 5c
    imgView.image = [UIImage imageNamed:@"YWCircle_5"];
    viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
    viewColorPickerPositionIndicator.layer.cornerRadius = 8;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    btnPlay.frame = CGRectMake(111, 111, 60, 60);
      self.mySlider.frame=CGRectMake(50, 440, 220, 8);
      self.mySlider2.frame=CGRectMake(50, 483, 220, 8);
    
  }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
    // 6 & 6s
    imgView.image = [UIImage imageNamed:@"YWCircle_6"];
    viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
    viewColorPickerPositionIndicator.layer.cornerRadius = 10;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    btnPlay.frame = CGRectMake(135, 135, 60, 60);
      self.mySlider.frame=CGRectMake(55, 516, 265, 9);
      self.mySlider2.frame=CGRectMake(55, 565, 265, 9);
    
  }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
    // 6p & 6sp
    imgView.image = [UIImage imageNamed:@"YWCircle_6p"];
    viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
    viewColorPickerPositionIndicator.layer.cornerRadius = 12;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    btnPlay.frame = CGRectMake(150, 150, 60, 60);
      self.mySlider.frame=CGRectMake(60, 571, 295, 10);
      self.mySlider2.frame=CGRectMake(60, 624, 295, 10);
    
  }
  
  imgView.frame = CGRectMake(35.0f, 35.0f, imgView.image.size.width, imgView.image.size.height);
  
  
  imgView.userInteractionEnabled = YES;
  _imgView = imgView;
  
  viewColorPickerPositionIndicator.backgroundColor = [UIColor colorWithRed:0.996 green:1.000 blue:0.678 alpha:1.000];
  
  [btnPlay setBackgroundImage:[UIImage imageNamed:@"ct_icon_buttonbreak-off"] forState:UIControlStateNormal];
  
  [self.panelView addSubview:imgView];
  [self.panelView addSubview:viewColorPickerPositionIndicator];
  [self.panelView addSubview:btnPlay];
  
}

//-(void)sliderValueChanged{
//    self.LDValue.text = [NSString stringWithFormat:@"%d", (int)self.slider.value ];
//    NSLog(@"＝＝＝%f",self.slider.value);
//    //在这里把亮暗值   (int)self.slider.value   传给服务器
//    if(fabsf(self.slider.value-self.sliderValueTemp)>9)
//    {
//        if(self.slider.value<=10)
//        {
//            self.slider.value=0;
//        }
//        if(self.slider.value>=90)
//        {
//            self.slider.value=100;
//        }
//        int value = (int)self.slider.value;
//        
//        [HttpRequest sendYWBrightnessToServer:self.logic_id brightnessValue:[NSString stringWithFormat:@"%d", value ] success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            
//            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            NSLog(@"YW亮暗返回成功：%@",result);
//            
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            //NSLog(@"YW亮暗返回失败：%@",error);
//            [MBProgressHUD showError:@"请检查网关"];
//        }];
//    }
//  
//}
//-(void)sliderTouchUpInside
//{
//    NSLog(@"还原");
//    self.sliderValueTemp=0;
//}
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
                                       smallRadius:imgView.frame.size.width * 0.38
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
  //  NSLog(@"%@", NSStringFromCGRect(imgView.frame));
  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.38
                                       targetPoint:touchLocation];
  if (pointInRound) {
    
    //    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    //    UITouch *touch = touches.anyObject;
    //
    //    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                           bigRadius:imgView.frame.size.width * 0.48
                         smallRadius:imgView.frame.size.width * 0.38        //0.39
                         targetPoint:touchLocation]) {
      
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      
      
      int cwValue = (int)(touchLocation.y / 2.5) - 2;
      if (fabs(([[UIScreen mainScreen] bounds].size.height - 480)) < 1) {
        // 4 & 4s
        if (cwValue < 63) {
          cwValue = cwValue + 1;
        }else{
          cwValue = (float)(cwValue) / 81 * 100;
        }
      }
      if (fabs(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
        // 5 & 5s & 5c
        if (cwValue < 63) {
          cwValue = cwValue + 1;
        }else{
          cwValue = (float)(cwValue) / 81 * 100;
        }
        
      }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
        // 6 & 6s
        if (cwValue < 63) {
          cwValue = cwValue;
        }else{
          cwValue += 1;
        }
        
      }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
        // 6p & 6sp
        
        if (cwValue < 63) {
          cwValue = cwValue;
        }else{
          cwValue = (float)(cwValue) / 111 * 100;
        }
      }
      
      self.CWValue.text = [NSString stringWithFormat:@"%d", cwValue];
      //在这里把cwValuevalue值传给服务器
      cwValue = 100 - cwValue;
      [HttpRequest sendYWWarmColdToServer:self.logic_id warmcoldValue:[NSString stringWithFormat:@"%d", cwValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"YW冷暖返回成功：%@",result);
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"YW冷暖返回失败：%@",error);
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
  //UIView *hitView = nil;
  
  UIImageView *imgView = (UIImageView *)[self.view viewWithTag:10086];
  //  NSLog(@"%@", NSStringFromCGRect(imgView.frame));
  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.38
                                       targetPoint:touchLocation];
  if (pointInRound) {
    //    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                           bigRadius:imgView.frame.size.width * 0.48
                         smallRadius:imgView.frame.size.width * 0.38        //0.39
                         targetPoint:touchLocation]) {
    
      //        viewColorPickerPositionIndicator.center = touchLocation;
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
        self.mySlider.backgroundColor=[self getPixelColorAtLocation:touchLocation];
        self.mySlider2.backgroundColor=[self getPixelColorAtLocation:touchLocation];
      
      
      int cwValue = (int)(touchLocation.y / 2.5) - 2;
      if (fabs(([[UIScreen mainScreen] bounds].size.height - 480)) < 1) {
        // 4 & 4s
        if (cwValue < 63) {
          cwValue = cwValue + 1;
        }else{
          cwValue = (float)(cwValue) / 81 * 100;
        }
      }
      if (fabs(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
        // 5 & 5s & 5c
        if (cwValue < 63) {
          cwValue = cwValue + 1;
        }else{
          cwValue = (float)(cwValue) / 81 * 100;
        }
      }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
        // 6 & 6s
        if (cwValue < 63) {
          cwValue = cwValue;
        }else{
          cwValue += 1;
        }
      }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
        // 6p & 6sp
        if (cwValue < 63) {
          cwValue = cwValue;
        }else{
          cwValue = (float)(cwValue) / 111 * 100;
        }
      }
      self.CWValue.text = [NSString stringWithFormat:@"%d", cwValue];
      
      
      
      int i, j;
      if ((i = arc4random() % 2)) {
        if ((j = arc4random() % 2)) {
          //在这里把cwValuevalue值传给服务器
          
          cwValue = 100 - cwValue;
          [HttpRequest sendYWWarmColdToServer:self.logic_id warmcoldValue:[NSString stringWithFormat:@"%d", cwValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"YW冷暖返回成功：%@",result);
            
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"YW冷暖返回失败：%@",error);
          }];
        }
      }
    }}
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  
  UITouch *touch = touches.anyObject;
  
  CGPoint touchLocation = [touch locationInView:self.imgView];
 // UIView *hitView = nil;
  
  UIImageView *imgView = (UIImageView *)[self.view viewWithTag:10086];
  //  NSLog(@"%@", NSStringFromCGRect(imgView.frame));
  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.38
                                       targetPoint:touchLocation];
  if (pointInRound) {
    
    //    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    //    UITouch *touch = touches.anyObject;
    //
    //    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                           bigRadius:imgView.frame.size.width * 0.48
                         smallRadius:imgView.frame.size.width * 0.38        //0.39
                         targetPoint:touchLocation]) {
      
      //        viewColorPickerPositionIndicator.center = touchLocation;
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
        self.mySlider.backgroundColor=[self getPixelColorAtLocation:touchLocation];
        self.mySlider2.backgroundColor=[self getPixelColorAtLocation:touchLocation];
      
      int cwValue = (int)(touchLocation.y / 2.5) - 2;
      if (fabs(([[UIScreen mainScreen] bounds].size.height - 480)) < 1) {
        // 4 & 4s
        if (cwValue < 63) {
          cwValue = cwValue + 1;
        }else{
          cwValue = (float)(cwValue) / 81 * 100;
        }
      }
      if (fabs(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
        // 5 & 5s & 5c
        if (cwValue < 63) {
          cwValue = cwValue + 1;
        }else{
          cwValue = (float)(cwValue) / 81 * 100;
        }
        
      }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
        // 6 & 6s
        if (cwValue < 63) {
          cwValue = cwValue;
        }else{
          cwValue += 1;
        }
        
      }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
        // 6p & 6sp
        
        if (cwValue < 63) {
          cwValue = cwValue;
        }else{
          cwValue = (float)(cwValue) / 111 * 100;
        }
      }
      
      self.CWValue.text = [NSString stringWithFormat:@"%d", cwValue];
      //在这里把cwValuevalue值传给服务器
        cwValue = 100 - cwValue;
      [HttpRequest sendYWWarmColdToServer:self.logic_id warmcoldValue:[NSString stringWithFormat:@"%d", cwValue] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"YW冷暖返回成功：%@",result);
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"YW冷暖返回失败：%@",error);
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
- (void)leftBtnClicked{
  
  for (UIViewController *controller in self.navigationController.viewControllers)
  {
    
    if ([controller isKindOfClass:[CYFFurnitureViewController class]])
    {
      
      [self.navigationController popToViewController:controller animated:YES];
      
    }
    if ([controller isKindOfClass:[YSYWPatternViewController class]])
      {
          
          [self.navigationController popToViewController:controller animated:YES];
          
      }
    
  }
}

//电器开关按钮
-(void)rightBtnClicked
{
  NSLog(@"开关按钮点击事件");
  //说明灯是关着的
  if(self.switchTag==0)
  {
    self.switchTag++;
    
    [HttpRequest sendYWBrightnessToServer:self.logic_id brightnessValue:@"100"
                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                    NSLog(@"成功: %@", string);
                                    
                                  }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    
                                    NSLog(@"失败: %@", error);
                                    [MBProgressHUD showError:@"请检查网关"];
                                    
                                    
                                  }];
    
  }
  else if (self.switchTag==1)
  {
    self.switchTag--;
    
    [HttpRequest sendYWBrightnessToServer:self.logic_id brightnessValue:@"0"
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

-(void)setNavigationBar
{
    UIButton *leftButton=[[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame=CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton=[[UIButton alloc]init];
    [rightButton setImage:[UIImage imageNamed:@"ct_icon_switch"] forState:UIControlStateNormal];
    rightButton.frame=CGRectMake(0, 0, 30, 30);
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(-4, 6, 4, -10)];
    [rightButton addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    UILabel *titleView=[[UILabel alloc]init];
    [titleView setText:@"YW灯"];
    titleView.frame=CGRectMake(0, 0, 100, 16);
    titleView.font=[UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleView;
}

-(void)ywClick
{
    NSLog(@"实际上是YW灯");
}
- (IBAction)photoClick1:(id)sender
{
    self.isPhoto=1;
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
            showPhoto.openType = UIImagePickerControllerSourceTypeCamera;//从照相机打开；
            showPhoto.logic_id = self.logic_id;
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
            showPhoto.openType = UIImagePickerControllerSourceTypePhotoLibrary;//从图库打开；
            showPhoto.logic_id = self.logic_id;
            [self.navigationController pushViewController:showPhoto animated:true];
        }
    }]];
    
    [self.alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //取消；
    }]];
    
    //弹出提示框；
    [self presentViewController:self.alert animated:true completion:nil];
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
            NSLog(@"可以发送请求%d",(int)slider.value);
        }
        
    }
}
@end

















