//
//  UILabel+DXM.m
//  DXMCLLocation
//
//  Created by YANGJINMING on 16/4/18.
//  Copyright © 2016年 YANGJINMING. All rights reserved.
//

#import "UILabel+DXM.h"

@implementation UILabel (DXM)

- (NSMutableAttributedString *)atributeStringWithRange:(NSRange)Range withString:(NSString *)text {
    NSMutableAttributedString *mAttributString = [[NSMutableAttributedString alloc] initWithString:text];
    [mAttributString addAttribute:NSForegroundColorAttributeName value:[[UIColor greenColor] colorWithAlphaComponent:0.6] range:Range];
    return mAttributString;
}
@end
