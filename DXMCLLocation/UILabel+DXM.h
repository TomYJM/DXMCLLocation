//
//  UILabel+DXM.h
//  DXMCLLocation
//
//  Created by YANGJINMING on 16/4/18.
//  Copyright © 2016年 YANGJINMING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DXM)
//修改指定字符串颜色
- (NSMutableAttributedString *)atributeStringWithRange:(NSRange)Range withString:(NSString *)text;
@end
