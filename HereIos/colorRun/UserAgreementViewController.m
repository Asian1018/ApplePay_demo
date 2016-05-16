
#import "UserAgreementViewController.h"

@interface UserAgreementViewController ()<UIWebViewDelegate>{
    UIWebView *webView;
    MBProgressHUD * hud;
}

@end

@implementation UserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"用户协议";
    // Do any additional setup after loading the view.
    [self makeButton];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Here用户注册协议" ofType:@"doc"];
    
    webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 50 - 64);
    webView.scalesPageToFit = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:webView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    hud = [Utile showHudInView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    hud.hidden = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    hud.hidden = YES;

}
-(void)makeButton{
    UIButton * bu = [[UIButton alloc]init];
    bu.frame = CGRectMake(0, self.view.frame.size.height - 50, VIEW_WIDTH, 50);
    bu.titleLabel.font = [UIFont systemFontOfSize:20];
    bu.titleLabel.textColor = [UIColor whiteColor];
    [bu setBackgroundColor:[Utile green]];
    [bu setTitle:@"同意Here<用户服务协议>" forState:UIControlStateNormal];
    [self.view addSubview:bu];
    [bu addTarget:self action:@selector(agreement) forControlEvents:UIControlEventTouchUpInside];

}
-(void)agreement{
    [self.navigationController popViewControllerAnimated:YES];

}
@end
