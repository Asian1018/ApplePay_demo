

#import "TimePickerViewController.h"

@interface TimePickerViewController (){
    
}
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *dateSwitch;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property(nonatomic) NSInteger nowSecond;
@property(nonatomic,strong)NSString * timeStr;
@end

@implementation TimePickerViewController
-(NSString *)getTimeString:(NSInteger)count{
    NSString * lastStr = @"";
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",count/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(count%3600)/60];
    
    lastStr = [NSString stringWithFormat:@"%@:%@",str_hour,str_minute];
    if ([lastStr isEqualToString:@"00:00"]) {
        lastStr = @"19:00";
    }
    return lastStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"卡片定时提醒";
    self.view.backgroundColor = [UIColor whiteColor];
    self.datePicker.timeZone = [NSTimeZone localTimeZone];
    if (self.seconds > 0) {
        self.nowSecond = self.seconds;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
        NSString * dastr = [dateString substringToIndex:11];
        NSString * lastString = [NSString stringWithFormat:@"%@%@",dastr,[self getTimeString:self.seconds]];
        NSDate * date = [dateFormatter dateFromString:lastString];
        
        [self.datePicker setDate:date animated:YES];
        
        self.timeStr = [self getTimeString:self.seconds];
    }
    else{
        self.nowSecond = 60 * 60 * 19;
        self.timeStr = @"19:00";
    }
    if (self.isRemind == 0) {
       self.dateSwitch.on = YES;
        [self.completeButton setBackgroundColor:[Utile green]];
    }
    else{
        self.dateSwitch.on = NO;
        [self.completeButton setBackgroundColor:[UIColor lightGrayColor]];
        self.completeButton.enabled = NO;
    }
    
    if ([self.fromType isEqualToString:@"1"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(highbutton)];
    }
    
}
-(void)highbutton{
    // do nothing
}
- (IBAction)showTimeOrNot:(UISwitch*)sender {
    if (sender.on) {
        [self.completeButton setBackgroundColor:[Utile green]];
        self.isRemind = 1;
        self.completeButton.enabled = YES;
    }
    else{
        [self.completeButton setBackgroundColor:[UIColor lightGrayColor]];
        self.isRemind = 0;
        self.completeButton.enabled = NO;
    }
    
}

- (IBAction)setTimeAction:(id)sender {
    Handleremind * hand = [[Handleremind alloc]init];
    hand.qcId = self.qcId;
    hand.remindTime = self.nowSecond;
    hand.isRemind = self.isRemind;
    MBProgressHUD * hud = [Utile showHudInView:self.navigationController.view];
    [hand executeHasParse:^(id jsonData) {
        hud.hidden = YES;
        if ([[NSString stringWithFormat:@"%@",jsonData[@"status"]] isEqualToString:@"0"] ) {
            //succ
            if ([self.delegate respondsToSelector:@selector(getResultStepWithCount:timeString:)]) {
                [self.delegate getResultStepWithCount:self.nowSecond timeString:self.timeStr];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [Utile showPromptAlertWithString:@"设置失败"];
        }
    } failure:^(NSString *error) {
        hud.hidden = YES;
        [Utile showPromptAlertWithString:error];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getTime:(UIDatePicker *)sender {
    [Utile getTimeStampWithdate:sender.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
    NSString *dateString = [dateFormatter stringFromDate:sender.date];
    NSLog(@"得到时间:%@",dateString);
    NSString * hour = [dateString substringWithRange:NSMakeRange(11, 2)];
    NSString * minute =[dateString substringWithRange:NSMakeRange(14, 2)];
    self.timeStr = [NSString stringWithFormat:@"%@:%@",hour,minute];
    NSLog(@"时间:%@",self.timeStr);
    CGFloat f = [minute integerValue]*0.1 / 6;
    self.nowSecond = 60*60*([hour integerValue]) + f*60*60;
     NSLog(@"长度:%ld",(long)self.nowSecond);
    
}


@end
