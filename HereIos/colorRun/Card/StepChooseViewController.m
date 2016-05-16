
#import "StepChooseViewController.h"
#import "TXHRrettyRuler.h"
@interface StepChooseViewController ()<UITextFieldDelegate,TXHRrettyRulerDelegate>{
    TXHRrettyRuler *ruler;
    NSString* lastString;
}
//@property(nonatomic ,strong)UITextField *field;
@end

@implementation StepChooseViewController{
    UILabel *showLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设定目标";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel * desLabel = [[UILabel alloc]init];
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.frame = CGRectMake(20, 80,[UIScreen mainScreen].bounds.size.width - 20 * 2, 40);
    desLabel.text = @"目标步数";
    desLabel.font = [UIFont systemFontOfSize:24.f];
    desLabel.textColor = [Utile green];
    [self.view addSubview:desLabel];
    
    showLabel = [[UILabel alloc] init];
    showLabel.font = [UIFont systemFontOfSize:24.f];
    showLabel.textColor = [Utile green];
    showLabel.text = @"5000";
    showLabel.frame = CGRectMake(20, 130, [UIScreen mainScreen].bounds.size.width - 20 * 2, 40);
    showLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:showLabel];
    lastString = @"5000";
    if (self.sportType == 3) {
        desLabel.text = @"目标里程";
        showLabel.text = @"1km";
        lastString = @"1";
        ruler = [[TXHRrettyRuler alloc] initWithFrame:CGRectMake(20, 220, [UIScreen mainScreen].bounds.size.width - 20 * 2, 140)];
        ruler.rulerDeletate = self;
        [ruler showRulerScrollViewWithCount:200 average:[NSNumber numberWithFloat:0.1] currentValue:1.0f smallMode:YES];
        [self.view addSubview:ruler];
    }
    else{
        ruler = [[TXHRrettyRuler alloc] initWithFrame:CGRectMake(20, 220, [UIScreen mainScreen].bounds.size.width - 20 * 2, 140)];
        ruler.rulerDeletate = self;
        [ruler showRulerScrollViewWithCount:250 average:[NSNumber numberWithFloat:200] currentValue:5000.0f smallMode:YES];
        [self.view addSubview:ruler];
    }
    
      CGFloat margent = 50.0;
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - margent, self.view.frame.size.width, margent)];
    button.backgroundColor = [Utile green];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(OKButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [self.view addGestureRecognizer:singleTap];
    
    
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    
    [self.view endEditing:YES];
    
}
-(void)OKButton{
    if ([self.delegate respondsToSelector:@selector(getResultStepWithCount:)]) {
        [self.delegate getResultStepWithCount:lastString];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)txhRrettyRuler:(TXHRulerScrollView *)rulerScrollView {
    if (self.sportType == 3) {
     showLabel.text = [NSString stringWithFormat:@"%.1fkm", rulerScrollView.rulerValue];
        lastString =[NSString stringWithFormat:@"%.1f", rulerScrollView.rulerValue];
        return;
    }
    NSInteger n = rulerScrollView.rulerValue / 200 ;
    CGFloat dis = rulerScrollView.rulerValue - n * 200;
    if (dis > 100) {
        n = n + 1;
    }
    
    showLabel.text = [NSString stringWithFormat:@"%ld", n * 200];
    lastString = [NSString stringWithFormat:@"%ld", n * 200];
}


//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [_field resignFirstResponder];
//    
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
