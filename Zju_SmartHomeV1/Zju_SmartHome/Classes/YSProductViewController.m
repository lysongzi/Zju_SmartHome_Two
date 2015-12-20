//
//  YSProductViewController.m
//  Zju_SmartHome
//
//  Created by lysongzi on 15/12/18.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "YSProductViewController.h"
#import "YSProductViewCell.h"
#import "CYFMainViewController.h"
#import "HttpRequest.h"
#import "JYFurnitureBackStatus.h"
#import "JYFurniture.h"
#import "JYFurnitureBack.h"
#import "MBProgressHUD+MJ.h"
#import "QRCatchViewController.h"
#import "DLAddDeviceView.h"
#import "LogicIdXMLParser.h"
#import "JYUpdateFurnitureName.h"
#import "YSPatternViewController.h"

#define UISCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define UISCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define STATUS_HEIGHT 64
#define SECTION_COLUMN 3
#define SECTION_COUNT 1

NS_ENUM(NSInteger, productEditingState)
{
    ProductEditStateNormal,
    ProductEditStateDelete
};

NS_ENUM(NSInteger, ProductType)
{
    YWLIGHT_ON,
    YWLIGHT_OFF,
    RGBLIGHT_ON,
    RGBLIGHT_OFF,
    FRIDGE_ON,
    FRIDGE_OFF,
    BEDLIGHT_ON,
    BEDLIGHT_OFF,
    PURIFER_ON,
    PURIFER_OFF,
    AIRCONDITION_ON,
    AIRCONDITION_OFF,
    SOUND_ON,
    SOUND_OFF,
    TV_ON,
    TV_OFF
};

@interface YSProductViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UINavigationBarDelegate, DLAddDeviceViewDelegate, JYUpdateFurnitureNameDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *products;
@property (strong, nonatomic) JYFurnitureBackStatus *furnitureBackStatus;
@property (strong, nonatomic) DLAddDeviceView *addDeviceView;
@property (strong, nonatomic) JYUpdateFurnitureName *updateFurniture;

@property (strong, nonatomic) NSMutableDictionary *imageDic;
@property (assign) enum productEditingState currentEditState;

@end

@implementation YSProductViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initImageDictionary];
        self.products = [NSMutableArray array];
    }
    return self;
}

- (void)appendBtnAdd
{
    if (self.products) {
        JYFurniture *add = [[JYFurniture alloc] init];
        add.imageStr = @"equipment_add";
        add.descLabel = @"添加";
        add.registed = NO;
        [self.products addObject:add];
    }
}


- (void)initImageDictionary
{
    if (self.imageDic == nil) {
        self.imageDic = [NSMutableDictionary dictionary];
        self.imageDic[@(YWLIGHT_ON)] = @"yw_light_on";
        self.imageDic[@(YWLIGHT_OFF)] = @"yw_light_off";
        
        self.imageDic[@(RGBLIGHT_ON)] = @"rgb_light_on";
        self.imageDic[@(RGBLIGHT_OFF)] = @"rgb_light_off";
        
        self.imageDic[@(FRIDGE_ON)] = @"fridge_on";
        self.imageDic[@(FRIDGE_OFF)] = @"fridge_off";
        
        self.imageDic[@(BEDLIGHT_ON)] = @"yw_light_on";
        self.imageDic[@(BEDLIGHT_OFF)] = @"yw_light_off";
        
        self.imageDic[@(PURIFER_ON)] = @"purifer_on";
        self.imageDic[@(PURIFER_OFF)] = @"purifer_off";
        
        self.imageDic[@(AIRCONDITION_ON)] = @"aircondition_on";
        self.imageDic[@(AIRCONDITION_OFF)] = @"aircondition_off";
        
        self.imageDic[@(SOUND_ON)] = @"sound_on";
        self.imageDic[@(SOUND_OFF)] = @"sound_off";
        
        self.imageDic[@(TV_ON)] = @"tv_on";
        self.imageDic[@(TV_OFF)] = @"tv_off";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //进行CollectionView和Cell的绑定
    [self.collectionView registerClass:[YSProductViewCell class] forCellWithReuseIdentifier:@"YSProductViewCell"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    //self.collectionView.showsVerticalScrollIndicator = false;
    
    [self setNaviBarItemButton];
    
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    [self getDataFromRemote];
    
}

- (void)updateScrollView
{
    self.mainScrollView.contentSize = CGSizeMake(UISCREEN_WIDTH, self.mainImageView.frame.size.height + self.collectionView.contentSize.height - 64);
    
    self.collectionView.frame = CGRectMake(0, self.mainImageView.frame.size.height - 64, UISCREEN_WIDTH, self.collectionView.contentSize.height);
}

#pragma mark - UICollectionViewDataSource 协议的实现

//返回模型个数
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.products count];
}

//默认只有一个section
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return SECTION_COUNT;
}

//每个具体Cell的视图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YSProductViewCell *cell =
        [self.collectionView dequeueReusableCellWithReuseIdentifier:@"YSProductViewCell"
                                                       forIndexPath:indexPath];
    
    JYFurniture *product = self.products[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:product.imageStr];
    cell.descLabel.text = product.descLabel;
    cell.closeButton.hidden = YES;
    //默认底端和右端的线都显示
    cell.rightLine.hidden = NO;
    cell.bottomLine.hidden = NO;
    
    //行末尾，则不显示右侧的线
    if (indexPath.row % SECTION_COLUMN == (SECTION_COLUMN - 1))
    {
        cell.rightLine.hidden = YES;
    }
    
    [cell.closeButton addTarget:self action:@selector(deleteCellButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

    [self updateScrollView];
    return cell;
}

#pragma mark - UICollectionViewDelegate 协议的实现

//Cell点击触发的事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击添加按钮
    if (indexPath.row == (self.products.count - 1))
    {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提示 " message:@"请选择注册方式" preferredStyle:UIAlertControllerStyleAlert];
        
        //手动输入
        UIAlertAction *actionInHand = [UIAlertAction actionWithTitle:@"手动输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            //手动输入的操作
            DLAddDeviceView *addDeviceView = [DLAddDeviceView addDeviceView];
            addDeviceView.delegate = self;
            self.addDeviceView = addDeviceView;
            
            addDeviceView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:addDeviceView];
            self.navigationItem.hidesBackButton = YES;
        }];
        
        [alertController addAction:actionInHand];
        
        UIAlertAction *actionCode = [UIAlertAction actionWithTitle:@"扫码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
        {
            //打开扫码界面
            QRCatchViewController *qrCatcherVC=[[QRCatchViewController alloc]init];
            [self.navigationController pushViewController:qrCatcherVC animated:YES];
        }];
        
        [alertController addAction:actionCode];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
    else
    {
        JYFurniture * furniture = self.products[indexPath.row];
        [self.navigationController pushViewController:furniture.controller animated:YES];
    }
}

#pragma mark - DLAddDeviceViewDelegate 协议的实现

//取消添加设备
-(void)cancelAddDevice
{
    [self.addDeviceView removeFromSuperview];
}

//添加设备
-(void)addDeviceGoGoGo:(NSString *)deviceName and:(NSString *)deviceMac
{
    if([deviceMac isEqualToString:@""])
    {
        [MBProgressHUD showError:@"Mac值不能为空"];
    }
    else
    {
        [HttpRequest getLogicIdfromMac:deviceMac
                               success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             //表示从网关返回逻辑ID成功；需要解析这个逻辑ID，并发送到服务器；
             NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             
             //这里需要进行XML解析；
             LogicIdXMLParser *logicIdXMLParser = [[LogicIdXMLParser alloc] initWithXMLString:result];
             
             if([logicIdXMLParser.result isEqualToString:@"fail"])
             {
                 NSLog(@"注册电器失败");
                 [MBProgressHUD showError:@"设备注册失败"];
             }
             else
             {
                 NSLog(@"注册电器成功");
             }
             
        }
         
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
             //从网关返回逻辑ID失败；
             [MBProgressHUD showError:@"获取逻辑ID失败，请检查网关"];
        }];
        
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout 协议的实现

//设定每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(UISCREEN_WIDTH / SECTION_COLUMN, UISCREEN_WIDTH / SECTION_COLUMN);
}

//设置每个Cell的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - 网络数据获取与处理

-(void)getDataFromRemote
{
    [HttpRequest findAllDeviceFromServer:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        //NSLog(@"已经接受到服务器返回的数据");
        self.furnitureBackStatus = [JYFurnitureBackStatus statusWithDict:responseObject];
        
        NSMutableArray *backProducts = self.furnitureBackStatus.furnitureArray;
        //NSLog(@"backProducts : %ld", [backProducts count]);
        
        if (backProducts && [backProducts count] > 0) {
            for (JYFurnitureBack *fb in backProducts) {
                JYFurniture *furniture = [[JYFurniture alloc] init];
                furniture.descLabel = fb.name;
                furniture.registed = YES;
                furniture.logic_id = fb.logic_id;
                furniture.deviceType = fb.deviceType;
                
                if ([furniture.deviceType isEqualToString:@"40"]) {
                    furniture.imageStr = self.imageDic[@(RGBLIGHT_ON)];
                    furniture.controller = [[YSPatternViewController alloc] init];
                }
                else if ([furniture.deviceType isEqualToString:@"41"]) {
                    furniture.imageStr = self.imageDic[@(YWLIGHT_ON)];
                    furniture.controller = [[YSPatternViewController alloc] init];
                }
                else {
                    furniture.imageStr = self.imageDic[@(TV_ON)];
                    furniture.controller = nil;
                }
                
                [self.products addObject:furniture];
            }
        }
        
        [self appendBtnAdd];
        [self addLongPressGestureToCell];
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //失败的回调；
        [MBProgressHUD showError:@"服务器加载数据失败"];
    }];
    
}

#pragma mark - 长按Cell的手势事件

- (void)addLongPressGestureToCell
{
    //创建长按手势监听
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(myHandleCollectionViewCellLongPressed:)];
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    [self.collectionView addGestureRecognizer:longPress];
}

//处理Cell的长按事件
- (void) myHandleCollectionViewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
        
        long updateRow = indexPath.row;
        //JYFurniture *furniture = self.products[updateRow];
        
        //如果点击的是添加按钮，不做处理
        if(updateRow == (self.products.count - 1))
        {
            return;
        }
        
        JYUpdateFurnitureName *updateFurniture=[JYUpdateFurnitureName updateFurnitureNameView];
        updateFurniture.delegate = self;
        updateFurniture.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.updateFurniture = updateFurniture;
        [self.view addSubview:self.updateFurniture];
        
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"长按手势结束");
    }
}

//更改电器名称代理方法
-(void)updateGoGoGo:(NSString *)furnitureName
{
    //这里是更新电器名称的处理
}

//取消更改电器名称
-(void)cancelUpdate
{
    [self.updateFurniture removeFromSuperview];
}


#pragma mark - 导航栏

//设置导航条
- (void)setNaviBarItemButton
{
    UILabel *titleView=[[UILabel alloc]init];
    [titleView setText:@"单品"];
    titleView.frame=CGRectMake(0, 0, 100, 16);
    titleView.font=[UIFont systemFontOfSize:16];
    [titleView setTextColor:[UIColor whiteColor]];
    titleView.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView=titleView;
    
    //左侧返回按钮
    UIButton *leftButton=[[UIButton alloc]init];
    [leftButton setImage:[UIImage imageNamed:@"ct_icon_leftbutton"] forState:UIControlStateNormal];
    leftButton.frame=CGRectMake(0, 0, 25, 25);
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [leftButton addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    //右侧切换模式
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(rightBtnClicked)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

//左侧返回按钮操作
- (void)leftBtnClicked
{
    for (UIViewController *controller in self.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[CYFMainViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

//单行条右边按钮操作
- (void)rightBtnClicked
{
    //此时你要删除cell了；
    if (self.currentEditState == ProductEditStateNormal)
    {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        self.currentEditState = ProductEditStateDelete;//两个状态切换；
        
        for(YSProductViewCell *cell in self.collectionView.visibleCells)
        {
            
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            JYFurniture *furniture = self.products[indexPath.row];
            
            if (furniture.registed == YES)
            {
                [cell.closeButton setHidden:NO];
            }
            else
            {
                [cell.closeButton setHidden:YES];
            }
        }
    }
    else
    {
        //这是正常情况下；
        self.navigationItem.rightBarButtonItem.title = @"删除";
        self.currentEditState = ProductEditStateNormal;
        
        [self.collectionView reloadData];
    }
}

//删除单品操作
- (void)deleteCellButtonPressed:(id)sender
{
    NSLog(@"dsffsdfsdf");
}

@end
