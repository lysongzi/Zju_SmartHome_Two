//
//  STHomeView.h
//  STHome
//
//  Created by gujinyue on 15/12/29.
//  Copyright © 2015年 gujinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STHomeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *posLabel;

- (IBAction)officeClick:(id)sender;
- (IBAction)homeClick:(id)sender;
- (IBAction)universalClick:(id)sender;
- (IBAction)singleClick:(id)sender;

+(instancetype)initWithSThomeView;
@end
