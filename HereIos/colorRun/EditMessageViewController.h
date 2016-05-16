//
//  EditMessageViewController.h
//  colorRun
//
//  Created by engine on 15/11/4.
//  Copyright (c) 2015年 engine. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"
@interface EditMessageViewController : BaseViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *textCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *editText;
@property (nonatomic,strong) User* user ;
@end
