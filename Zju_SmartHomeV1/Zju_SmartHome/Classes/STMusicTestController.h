//
//  STMusicTestController.h
//  Zju_SmartHome
//
//  Created by gujinyue on 16/1/7.
//  Copyright © 2016年 GJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STMusicTestController : UIViewController
- (IBAction)palypause:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)next:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *protolName;
@property (weak, nonatomic) IBOutlet UITextField *value;

@end
