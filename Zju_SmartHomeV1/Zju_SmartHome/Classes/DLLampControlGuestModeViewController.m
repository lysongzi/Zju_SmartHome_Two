//
//  DLLampControlGuestModeViewController.m
//  Zju_SmartHome
//
//  Created by TooWalker on 15/12/4.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "DLLampControlGuestModeViewController.h"
#import "ZQSlider.h"
#import "AFNetworking.h"
#import "HttpRequest.h"
#import "MBProgressHUD+MJ.h"
#import "AppDelegate.h"
#import "HttpRequest.h"
#import "PhotoViewController.h"
#import "CYFFurnitureViewController.h"
#import "YSYWPatternViewController.h"


@interface DLLampControlGuestModeViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *modeTitle;
@property (weak, nonatomic) IBOutlet UIImageView *modeImage;
@property (nonatomic, weak) UISlider *slider;
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UIView *viewColorPickerPositionIndicator;
@property (weak, nonatomic) IBOutlet UIView *panelView;
@property (weak, nonatomic) IBOutlet UILabel *rValue;
@property (weak, nonatomic) IBOutlet UILabel *gValue;
@property (weak, nonatomic) IBOutlet UILabel *bValue;
@property (weak, nonatomic) IBOutlet UIView *colorPreview;
@property (weak, nonatomic) IBOutlet UIButton *leftFront;

@property (weak, nonatomic) IBOutlet UIButton *rightNext;

@property (weak, nonatomic) IBOutlet UIButton *modeSelect;

@property(nonatomic,assign)int tag;
@property(nonatomic,assign)int switchTag;
@property (nonatomic, assign) int i;
@property(nonatomic,assign)int sliderValueTemp;

@property(nonatomic,assign)int isPhoto;

//有关照片取色的属性；
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (nonatomic,strong) UIAlertController *alert;

@end

@implementation DLLampControlGuestModeViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
    self.i = 0;
  self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(253/255.0f) blue:(185/255.0f) alpha:(255/255.0f)];
    self.rValue.text=@"255";
    self.gValue.text=@"253";
    self.bValue.text=@"185";
    
    NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",255]];
    NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",253]];
    
    NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",187]];
    
    [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  NSLog(@"成功: %@", string);
                                  
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                                  NSLog(@"失败: %@", error);
                                  [MBProgressHUD showError:@"请检查网关"];
                                  
                              }];
  
    //设置导航条
    [self setNavigationBar];
  //一开始进入会客模式,RGB灯亮,不能调控模式
  self.switchTag=1;
  self.leftFront.enabled=NO;
  [self.rightNext addTarget:self action:@selector(rightGo) forControlEvents:UIControlEventTouchUpInside];
    [self.leftFront addTarget:self action:@selector(leftGO) forControlEvents:UIControlEventTouchUpInside];
  [self.modeSelect addTarget:self action:@selector(modeSelected) forControlEvents:UIControlEventTouchUpInside];
 
  [self.modeSelect setBackgroundImage:[UIImage imageNamed:@"ct_icon_model_press"] forState:UIControlStateNormal];

  
  UIImageView *imgView = [[UIImageView alloc]init];
  imgView.tag = 10086;
    self.imgView = imgView;
  UIView *viewColorPickerPositionIndicator = [[UIView alloc]init];
  viewColorPickerPositionIndicator.tag = 10087;
    self.viewColorPickerPositionIndicator = viewColorPickerPositionIndicator;
  UIButton *btnPlay = [[UIButton alloc] init];
  
  ZQSlider *slider = [[ZQSlider alloc] init];
  slider.backgroundColor = [UIColor clearColor];
  
  slider.minimumValue = 0;
  slider.maximumValue = 100;
  slider.value = 100;
  
  [slider setMaximumTrackImage:[UIImage imageNamed:@"lightdarkslider3"] forState:UIControlStateNormal];
  [slider setMinimumTrackImage:[UIImage imageNamed:@"lightdarkslider3"] forState:UIControlStateNormal];
  [slider setThumbImage:[UIImage imageNamed:@"sliderPoint"] forState:UIControlStateNormal];
  [slider setThumbImage:[UIImage imageNamed:@"sliderPoint"] forState:UIControlStateNormal];
  
  slider.continuous = YES;
  
  self.slider = slider;
  [slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventValueChanged];
     [slider addTarget:self action:@selector(sliderTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
  
  if (fabs(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
    // 5 & 5s & 5c
    imgView.image = [UIImage imageNamed:@"YWCircle_5"];
    viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
    viewColorPickerPositionIndicator.layer.cornerRadius = 8;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    btnPlay.frame = CGRectMake(111, 111, 60, 60);
    slider.frame = CGRectMake(40, 260, 200, 10);
    
  }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
    // 6 & 6s
    imgView.image = [UIImage imageNamed:@"YWCircle_6"];
    viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
    viewColorPickerPositionIndicator.layer.cornerRadius = 10;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    btnPlay.frame = CGRectMake(135, 135, 60, 60);
    slider.frame = CGRectMake(50, 310, 225, 10);
    
  }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
    // 6p & 6sp
    imgView.image = [UIImage imageNamed:@"YWCircle_6p"];
    viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
    viewColorPickerPositionIndicator.layer.cornerRadius = 12;
    viewColorPickerPositionIndicator.layer.borderWidth = 2;
    btnPlay.frame = CGRectMake(150, 150, 60, 60);
    slider.frame = CGRectMake(85, 340, 200, 10);
    
  }
  
  imgView.frame = CGRectMake(35.0f, 35.0f, imgView.image.size.width, imgView.image.size.height);
  
  
  imgView.userInteractionEnabled = YES;
  _imgView = imgView;

  viewColorPickerPositionIndicator.backgroundColor = [UIColor clearColor];

  [btnPlay setBackgroundImage:[UIImage imageNamed:@"ct_icon_buttonbreak-off"] forState:UIControlStateNormal];
  
  [self.panelView addSubview:imgView];
  [self.panelView addSubview:viewColorPickerPositionIndicator];
  [self.panelView addSubview:btnPlay];
  [self.panelView addSubview:slider];
    
}

//控制RGB灯亮度方法
-(void)sliderValueChanged
{
    if(fabsf(self.slider.value-self.sliderValueTemp)>9)
    {
        NSLog(@"哪个被发送请求的啊%f",self.slider.value);
        if(self.slider.value<=10)
        {
            self.slider.value=0;
        }
        if(self.slider.value>=90)
        {
            self.slider.value=100;
        }
        int value = (int)self.slider.value;
        
        self.sliderValueTemp=self.slider.value;
        [HttpRequest sendRGBBrightnessToServer:self.logic_id brightnessValue:[NSString stringWithFormat:@"%d", value]
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

-(void)sliderTouchUpInside
{
    NSLog(@"还原");
    self.sliderValueTemp=0;
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
    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(colorImageView.frame.size.width / 2, colorImageView.frame.size.height / 2)
                           bigRadius:colorImageView.frame.size.width * 0.48
                         smallRadius:colorImageView.frame.size.width * 0.38        //0.39
                         targetPoint:touchLocation]) {
      
      self.rValue.text = [NSString stringWithFormat:@"%d", (int)(components[0] * 255)];
      self.gValue.text = [NSString stringWithFormat:@"%d", (int)(components[1] * 255)];
      self.bValue.text = [NSString stringWithFormat:@"%d", (int)(components[2] * 255)];
      NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.rValue.text intValue]]];
      NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.gValue.text intValue]]];
      
      NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.bValue.text intValue]]];
      
      self.colorPreview.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      //!!!:ATTENTIOIN
      //        viewColorPickerPositionIndicator.center = touchLocation;
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);

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
  //  NSLog(@"%@", NSStringFromCGRect(imgView.frame));
  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.38
                                       targetPoint:touchLocation];
  if (pointInRound) {
    UIImageView *colorImageView = (UIImageView *)[self.view viewWithTag:10086];
    UIView *viewColorPickerPositionIndicator = (UIView *)[self.view viewWithTag:10087];
    UITouch *touch = touches.anyObject;
    //!!!:ATTENTION
    
    CGPoint touchLocation = [touch locationInView:self.imgView];
    UIColor *positionColor = [self getPixelColorAtLocation:touchLocation];
    const CGFloat *components = CGColorGetComponents(positionColor.CGColor);
    
    if ([self touchPointInsideCircle:CGPointMake(colorImageView.frame.size.width / 2, colorImageView.frame.size.height / 2)
                           bigRadius:colorImageView.frame.size.width * 0.48
                         smallRadius:colorImageView.frame.size.width * 0.38        //0.39
                         targetPoint:touchLocation]) {
      
      self.rValue.text = [NSString stringWithFormat:@"%d", (int)(components[0] * 255)];
      self.gValue.text = [NSString stringWithFormat:@"%d", (int)(components[1] * 255)];
      self.bValue.text = [NSString stringWithFormat:@"%d", (int)(components[2] * 255)];
      
      NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.rValue.text intValue]]];
      NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.gValue.text intValue]]];
      
      NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.bValue.text intValue]]];
      
      self.colorPreview.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      //!!!:ATTENTIOIN
      //        viewColorPickerPositionIndicator.center = touchLocation;
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
//      viewColorPickerPositionIndicator.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      
      int i, j, k;
      if ((i = arc4random() % 2)) {
        if ((j = arc4random() % 2)) {
          if ((k = arc4random() % 2)) {
            //在这里把rgb（self.rValue.text, self.gValue.text, self.bValue.text）值传给服务器
              NSLog(@"%@ %@ %@", self.rValue.text, self.gValue.text, self.bValue.text);
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
 // UIView *hitView = nil;
  
  UIImageView *imgView = (UIImageView *)[self.view viewWithTag:10086];
  //  NSLog(@"%@", NSStringFromCGRect(imgView.frame));
  BOOL pointInRound = [self touchPointInsideCircle:CGPointMake(imgView.frame.size.width / 2, imgView.frame.size.height / 2)
                                         bigRadius:imgView.frame.size.width * 0.48
                                       smallRadius:imgView.frame.size.width * 0.38
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
                         smallRadius:colorImageView.frame.size.width * 0.38        //0.39
                         targetPoint:touchLocation]) {
      
      self.rValue.text = [NSString stringWithFormat:@"%d", (int)(components[0] * 255)];
      self.gValue.text = [NSString stringWithFormat:@"%d", (int)(components[1] * 255)];
      self.bValue.text = [NSString stringWithFormat:@"%d", (int)(components[2] * 255)];
      NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.rValue.text intValue]]];
      NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.gValue.text intValue]]];
      
      NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",[self.bValue.text intValue]]];
      
      self.colorPreview.backgroundColor = [self getPixelColorAtLocation:touchLocation];
      //!!!:ATTENTIOIN
      //        viewColorPickerPositionIndicator.center = touchLocation;
      viewColorPickerPositionIndicator.center = CGPointMake(touchLocation.x + 35, touchLocation.y + 35);
      
      [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  NSLog(@"成功: %@", string);
                                  
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
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
//向左切换模式
- (void)leftBtnClicked{
  
  for (UIViewController *controller in self.navigationController.viewControllers)
  {
    
    if ([controller isKindOfClass:[CYFFurnitureViewController class]])
    {
      
      [self.navigationController popToViewController:controller animated:YES];
      
    }
    if([controller isKindOfClass:[YSYWPatternViewController class]])
    {
        [self.navigationController popToViewController:controller animated:YES];
    }
    
  }
}
- (void)leftGO{
    self.rightNext.enabled = YES;
    self.i--;

    if (fabs(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
        // 5 & 5s & 5c
        switch (_i) {
            case 0:
                _imgView.image = [UIImage imageNamed:@"YWCircle_5"];
                self.modeImage.image = [UIImage imageNamed:@"会客"];
                self.modeTitle.text = @"会客模式";
                self.leftFront.enabled = NO;
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(253/255.0f) blue:(185/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"255";
                self.gValue.text=@"253";
                self.bValue.text=@"185";
                 self.viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
                [self yellowSlider];
                [self guestFirst];
                break;
            case 1:
                _imgView.image = [UIImage imageNamed:@"circle_5"];
                self.modeImage.image = [UIImage imageNamed:@"烛光"];
                self.modeTitle.text = @"烛光晚宴";
                [self blueSlider];
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(165/255.0f) green:(42/255.0f) blue:(182/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"165";
                self.gValue.text=@"42";
                self.bValue.text=@"182";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
                [self dinnerFirst];
                
                break;
            case 2:
                _imgView.image = [UIImage imageNamed:@"YWCircle_5"];
                self.modeImage.image = [UIImage imageNamed:@"阅读"];
                self.modeTitle.text = @"读书模式";
                [self yellowSlider];
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(235/255.0f) blue:(204/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"255";
                self.gValue.text=@"235";
                self.bValue.text=@"204";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
                [self readFirst];
                
                break;
            case 3:
                _imgView.image = [UIImage imageNamed:@"sleeping_5"];
                self.modeImage.image = [UIImage imageNamed:@"睡眠"];
                self.modeTitle.text = @"睡眠模式";
                [self blueSlider];
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(38/255.0f) green:(92/255.0f) blue:(145/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"38";
                self.gValue.text=@"92";
                self.bValue.text=@"145";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
                [self sleepFirst];
                break;
            case 4:
                _imgView.image = [UIImage imageNamed:@"RGBCircle_5"];
                self.modeImage.image = [UIImage imageNamed:@""];
                self.modeTitle.text = @"彩色自定义";
                [self blueSlider];
                [self customFirst];
                break;
            default:
                break;
        }
    }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 667)) < 1) {
        // 6 & 6s
        switch (_i) {
            case 0:
                _imgView.image = [UIImage imageNamed:@"YWCircle_6"];
                self.modeImage.image = [UIImage imageNamed:@"会客"];
                self.modeTitle.text = @"会客模式";
                [self yellowSlider];
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(253/255.0f) blue:(185/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"255";
                self.gValue.text=@"253";
                self.bValue.text=@"185";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
                self.leftFront.enabled = NO;
                [self guestFirst];
                break;
            case 1:
                _imgView.image = [UIImage imageNamed:@"circle_6"];
                self.modeImage.image = [UIImage imageNamed:@"烛光"];
                self.modeTitle.text = @"烛光晚宴";
                [self blueSlider];
               self.colorPreview.backgroundColor = [UIColor colorWithRed:(165/255.0f) green:(42/255.0f) blue:(182/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"165";
                self.gValue.text=@"42";
                self.bValue.text=@"182";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
                [self dinnerFirst];
                break;
            case 2:
                _imgView.image = [UIImage imageNamed:@"YWCircle_6"];
                self.modeImage.image = [UIImage imageNamed:@"阅读"];
                self.modeTitle.text = @"读书模式";
                [self yellowSlider];
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(235/255.0f) blue:(204/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"255";
                self.gValue.text=@"235";
                self.bValue.text=@"204";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
                [self readFirst];
                break;
            case 3:
                _imgView.image = [UIImage imageNamed:@"sleeping_6"];
                self.modeImage.image = [UIImage imageNamed:@"睡眠"];
                self.modeTitle.text = @"睡眠模式";
                [self blueSlider];
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(38/255.0f) green:(92/255.0f) blue:(145/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"38";
                self.gValue.text=@"92";
                self.bValue.text=@"145";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
                [self sleepFirst];
                break;
            case 4:
                _imgView.image = [UIImage imageNamed:@"RGBCircle_6"];
                self.modeImage.image = [UIImage imageNamed:@""];
                self.modeTitle.text = @"彩色自定义";
                [self yellowSlider];
                [self blueSlider];
                [self customFirst];
                break;
            default:
                break;
        }
    }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 736)) < 1){
        // 6p & 6sp
        switch (_i) {
            case 0:
                self.modeImage.image = [UIImage imageNamed:@"会客"];
                self.modeTitle.text = @"会客模式";
                _imgView.image = [UIImage imageNamed:@"YWCircle_6p"];
                self.leftFront.enabled = NO;
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(253/255.0f) blue:(185/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"255";
                self.gValue.text=@"253";
                self.bValue.text=@"185";
                 self.viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
                [self yellowSlider];
                [self guestFirst];
                break;
            case 1:
                _imgView.image = [UIImage imageNamed:@"circle_6p"];
                self.modeImage.image = [UIImage imageNamed:@"烛光"];
                self.modeTitle.text = @"烛光晚宴";
                [self blueSlider];
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(165/255.0f) green:(42/255.0f) blue:(182/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"165";
                self.gValue.text=@"42";
                self.bValue.text=@"182";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
                [self dinnerFirst];
                break;
            case 2:
                _imgView.image = [UIImage imageNamed:@"YWCircle_6p"];
                self.modeImage.image = [UIImage imageNamed:@"阅读"];
                self.modeTitle.text = @"读书模式";
                [self yellowSlider];
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(235/255.0f) blue:(204/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"255";
                self.gValue.text=@"235";
                self.bValue.text=@"204";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
                [self readFirst];
                break;
            case 3:
                _imgView.image = [UIImage imageNamed:@"sleeping_6p"];
                self.modeImage.image = [UIImage imageNamed:@"睡眠"];
                self.modeTitle.text = @"睡眠模式";
                [self blueSlider];
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(38/255.0f) green:(92/255.0f) blue:(145/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"38";
                self.gValue.text=@"92";
                self.bValue.text=@"145";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
                [self sleepFirst];
                break;
            case 4:
                _imgView.image = [UIImage imageNamed:@"RGBCircle_6p"];
                self.modeImage.image = [UIImage imageNamed:@""];
                self.modeTitle.text = @"彩色自定义";
                [self blueSlider];
                [self customFirst];
                break;
            default:
                break;
        }
    }
}

//向右切换模式
-(void)rightGo
{
    self.leftFront.enabled = YES;
    self.i++;
    self.colorPreview.backgroundColor=[UIColor clearColor];

    if (fabs(([[UIScreen mainScreen] bounds].size.height - 568)) < 1){
        // 5 & 5s & 5c
        switch (_i)
        {
            case 0:
                _imgView.image = [UIImage imageNamed:@"YWCircle_5"];
                self.modeImage.image = [UIImage imageNamed:@"会客"];
                self.modeTitle.text = @"会客模式";
                [self yellowSlider];
                [self guestFirst];
                break;
            case 1:
                _imgView.image = [UIImage imageNamed:@"circle_5"];
                self.modeImage.image = [UIImage imageNamed:@"烛光"];
                self.modeTitle.text = @"烛光晚宴";
                [self blueSlider];
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(165/255.0f) green:(42/255.0f) blue:(182/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"165";
                self.gValue.text=@"42";
                self.bValue.text=@"182";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
                [self dinnerFirst];
                break;
            case 2:
                _imgView.image = [UIImage imageNamed:@"reading_circle_5"];
                self.modeImage.image = [UIImage imageNamed:@"阅读"];
                self.modeTitle.text = @"读书模式";
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(235/255.0f) blue:(204/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"255";
                self.gValue.text=@"235";
                self.bValue.text=@"204";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
                [self yellowSlider];
                [self readFirst];
                break;
            case 3:
                _imgView.image = [UIImage imageNamed:@"sleeping_5"];
                self.modeImage.image = [UIImage imageNamed:@"睡眠"];
                self.modeTitle.text = @"睡眠模式";
                [self blueSlider];
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(38/255.0f) green:(92/255.0f) blue:(145/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"38";
                self.gValue.text=@"92";
                self.bValue.text=@"145";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
                [self sleepFirst];
                break;
            case 4:
                _imgView.image = [UIImage imageNamed:@"circle_55"];
                self.modeImage.image = [UIImage imageNamed:@""];
                self.modeTitle.text = @"彩色自定义";
                self.rightNext.enabled = NO;
                [self blueSlider];
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(229/255.0f) blue:(0/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"255";
                self.gValue.text=@"229";
                self.bValue.text=@"0";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(70, 70, 16, 16);
                [self customFirst];
                break;
            default:
                break;
        }

    }else if (fabs(([[UIScreen mainScreen] bounds].size.height - 667)) < 1)
    {
        // 6 & 6s
        switch (_i)
        {
            case 0:
                _imgView.image = [UIImage imageNamed:@"YWCircle_6"];
                self.modeImage.image = [UIImage imageNamed:@"会客"];
                self.modeTitle.text = @"会客模式";
                [self yellowSlider];
                [self guestFirst];
                break;
            case 1:
                _imgView.image = [UIImage imageNamed:@"circle_6"];
                self.modeImage.image = [UIImage imageNamed:@"烛光"];
                self.modeTitle.text = @"烛光晚宴";
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(165/255.0f) green:(42/255.0f) blue:(182/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"165";
                self.gValue.text=@"42";
                self.bValue.text=@"182";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
                [self blueSlider];
                [self dinnerFirst];
                break;
            case 2:
                _imgView.image = [UIImage imageNamed:@"reading_circle_6"];
                self.modeImage.image = [UIImage imageNamed:@"阅读"];
                self.modeTitle.text = @"读书模式";
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(235/255.0f) blue:(204/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"255";
                self.gValue.text=@"235";
                self.bValue.text=@"204";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
                [self yellowSlider];
                [self readFirst];
                break;
            case 3:
                _imgView.image = [UIImage imageNamed:@"sleeping_6"];
                self.modeImage.image = [UIImage imageNamed:@"睡眠"];
                self.modeTitle.text = @"睡眠模式";
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(38/255.0f) green:(92/255.0f) blue:(145/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"38";
                self.gValue.text=@"92";
                self.bValue.text=@"145";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
                [self blueSlider];
                [self sleepFirst];
                break;
            case 4:
                _imgView.image = [UIImage imageNamed:@"circle_66"];
                self.modeImage.image = [UIImage imageNamed:@""];
                self.modeTitle.text = @"彩色自定义";
                self.rightNext.enabled = NO;
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(229/255.0f) blue:(0/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"255";
                self.gValue.text=@"229";
                self.bValue.text=@"0";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(75, 75, 20, 20);
                [self blueSlider];
                [self customFirst];
                break;
            default:
                break;
        }
        
    }
    else if (fabs(([[UIScreen mainScreen] bounds].size.height - 736)) < 1)
    {
        // 6p & 6sp
        switch (_i)
        {
            case 0:
                _imgView.image = [UIImage imageNamed:@"YWCircle_6p"];
                self.modeImage.image = [UIImage imageNamed:@"会客"];
                self.modeTitle.text = @"会客模式";
                [self yellowSlider];
                [self guestFirst];
                break;
            case 1:
                _imgView.image = [UIImage imageNamed:@"circle_6p"];
                self.modeImage.image = [UIImage imageNamed:@"烛光"];
                self.modeTitle.text = @"烛光晚宴";
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(165/255.0f) green:(42/255.0f) blue:(182/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"165";
                self.gValue.text=@"42";
                self.bValue.text=@"182";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
                [self blueSlider];
                [self dinnerFirst];
                break;
            case 2:
                _imgView.image = [UIImage imageNamed:@"reading_circle_6p"];
                self.modeImage.image = [UIImage imageNamed:@"阅读"];
                self.modeTitle.text = @"读书模式";
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(235/255.0f) blue:(204/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"255";
                self.gValue.text=@"235";
                self.bValue.text=@"204";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
                [self yellowSlider];
                [self readFirst];
                break;
            case 3:
                _imgView.image = [UIImage imageNamed:@"sleeping_6p"];
                self.modeImage.image = [UIImage imageNamed:@"睡眠"];
                self.modeTitle.text = @"睡眠模式";
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(38/255.0f) green:(92/255.0f) blue:(145/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"38";
                self.gValue.text=@"92";
                self.bValue.text=@"145";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
                [self blueSlider];
                [self sleepFirst];
                break;
            case 4:
                _imgView.image = [UIImage imageNamed:@"circle_6pp"];
                self.modeImage.image = [UIImage imageNamed:@""];
                self.modeTitle.text = @"彩色自定义";
                self.rightNext.enabled = NO;
                self.colorPreview.backgroundColor = [UIColor colorWithRed:(255/255.0f) green:(229/255.0f) blue:(0/255.0f) alpha:(255/255.0f)];
                self.rValue.text=@"255";
                self.gValue.text=@"229";
                self.bValue.text=@"0";
                self.viewColorPickerPositionIndicator.frame = CGRectMake(80, 80, 24, 24);
                [self blueSlider];
                [self customFirst];
                break;
            default:
                break;
        
        }
    }
}


-(void)modeSelected
{
  if(self.tag==0)
  {
      
    self.rightNext.enabled=NO;
      self.leftFront.enabled=NO;
    self.tag++;
    //        [self.modeSelect setImage:[UIImage imageNamed:@"ct_icon_model_unpress"] forState:UIControlStateNormal];
    [self.modeSelect setBackgroundImage:[UIImage imageNamed:@"ct_icon_model_unpress"] forState:UIControlStateNormal];
  }
  else if(self.tag==1)
  {
      if (self.i != 4) {
          self.rightNext.enabled=YES;
      }
    
      if (self.i != 0) {
          self.leftFront.enabled=YES;
      }
      
    self.tag--;
    //        [self.modeSelect setImage:[UIImage imageNamed:@"ct_icon_model_press"] forState:UIControlStateNormal];
    [self.modeSelect setBackgroundImage:[UIImage imageNamed:@"ct_icon_model_press"] forState:UIControlStateNormal];
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
    
    [HttpRequest sendRGBBrightnessToServer:self.logic_id brightnessValue:@"100"
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
    
    [HttpRequest sendRGBBrightnessToServer:self.logic_id brightnessValue:@"0"
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
- (void)blueSlider{
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"blackblue"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"blackblue"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"sliderPoint"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"sliderPoint"] forState:UIControlStateNormal];
}

- (void)yellowSlider{
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"lightdarkslider3"] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"lightdarkslider3"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"sliderPoint"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"sliderPoint"] forState:UIControlStateNormal];
}

-(void)guestFirst
{
    NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",255]];
    NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",253]];
    
    NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",185]];
    
    [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  NSLog(@"成功: %@", string);
                                  
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD showError:@"请检查网关"];
                                  
                              }];

}
-(void)dinnerFirst
{
    NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",165]];
    NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",42]];
    
    NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",182]];
    
    [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  NSLog(@"成功: %@", string);
                                  
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD showError:@"请检查网关"];
                                  
                              }];

}
-(void)readFirst
{
    NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",255]];
    NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",235]];
    
    NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",204]];
    
    [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  NSLog(@"成功: %@", string);
                                  
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD showError:@"请检查网关"];
                                  
                              }];

}
-(void)sleepFirst
{
    NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",38]];
    NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",92]];
    
    NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",145]];
    
    [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  NSLog(@"成功: %@", string);
                                  
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD showError:@"请检查网关"];
                                  
                              }];

}
-(void)customFirst
{
    NSString *r = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",255]];
    NSString *g = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",229]];
    
    NSString *b = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithFormat:@"%1x",0]];
    
    [HttpRequest sendRGBColorToServer:self.logic_id redValue:r greenValue:g blueValue:b
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  
                                  NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                  NSLog(@"成功: %@", string);
                                  
                                  
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  [MBProgressHUD showError:@"请检查网关"];
                                  
                              }];

}

#pragma mark - 点击左上角按钮 进行拍照


- (IBAction)takephotoButtonPressed:(id)sender {

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
    
    UIButton *rightButton=[[UIButton alloc]init];
    [rightButton setImage:[UIImage imageNamed:@"ct_icon_switch"] forState:UIControlStateNormal];
    rightButton.frame=CGRectMake(0, 0, 30, 30);
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(-4, 6, 4, -10)];
    [rightButton addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightItem;
}
@end
