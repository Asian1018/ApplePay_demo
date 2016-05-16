
#import "O2OWebViewController.h"
#import "RDVTabBarController.h"
//#import "WebViewJavascriptBridge.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayController.h"
#import "LoginViewController.h"
#import "MyModel.h"
#import "CardDetailViewController.h"
@interface O2OWebViewController ()<UIWebViewDelegate,LoginDelegate>{
    UIWebView * MywebView;
    MBProgressHUD * hud;
//    JSContext *context;
}
//@property(nonatomic,strong)WebViewJavascriptBridge* bridge;
@property(nonatomic,strong)JSContext* context;
@end

@implementation O2OWebViewController

-(void)backAction{
    if ([MywebView canGoBack]) {
        [MywebView goBack];
    }
    else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    UIBarButtonItem * buttons = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"top_black_back"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = buttons;
    MywebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    MywebView.scalesPageToFit = YES;//自动缩放页面以适应屏幕 m
    MywebView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.o2oUrl]];
    [self.view addSubview:MywebView];
    [MywebView loadRequest:request];

}
-(void)refreshViewInfo{
//    User * user = [[UserDao sharedInstance]loadUser];
//    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
//    if (user.userId.length > 0) {
//        for (id key in [user PropertyKeys]) {
//            if ([key isEqualToString:@"userId"] || [key isEqualToString:@"sex"]) {
//                NSString * str = [NSString stringWithFormat:@"%@",[user valueForKey:key]];
//                [dic setObject:[NSNumber numberWithInteger:[str integerValue] ] forKey:key];
//            }
//            else{
//                [dic setObject:[user valueForKey:key] forKey:key] ;
//            }
//        }
//    }
//    NSString * data = [Utile changeToJsonStringWith:dic];
//    NSString *jsStr=[NSString stringWithFormat:@"getuser('%@')",data];
//    //    [context evaluateScript:jsStr];
//    [self.context[@"getuser"] callWithArguments:@[jsStr, @0]];

}
-(NSString*)returnUserInfoStr{
    //主动给用户登录信息
    User * user = [[UserDao sharedInstance]loadUser];
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    if (user.userId> 0) {
        for (id key in [user PropertyKeys]) {
            if ([key isEqualToString:@"userId"] || [key isEqualToString:@"sex"]) {
                NSString * str = [NSString stringWithFormat:@"%@",[user valueForKey:key]];
                str=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
                [dic setObject:[NSNumber numberWithInteger:[str integerValue] ] forKey:key];
            }
            else{
                [dic setObject:[user valueForKey:key] forKey:key] ;
            }
        }
    }
    
    [dic removeObjectsForKeys:@[@"remind",@"oauthId",@"oauthType"]];
    NSString * data = [Utile changeToJsonStringWith:dic];
    return data;
}

-(void)requestJSAction{
   self.context = [MywebView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(JSContext)  *weakContext =  self.context;
    __weak O2OWebViewController * weakSelf = self;
//    self.context = context;
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    __weak NSString* json = [weakSelf returnUserInfoStr] ;
     self.context[@"getuser"] = ^() {
//        NSArray *args = [JSContext currentArguments];
          NSLog(@"getUser json=%@",[weakSelf returnUserInfoStr]) ;
         return [weakSelf returnUserInfoStr] ;
         
        };
    
//    NSString *jsStr=[NSString stringWithFormat:@"getuser(%@)",[self returnUserInfoStr]];//
    
//    JSValue *value = [squareFunc callWithArguments:@[jsStr]];
  //  [self.context[@"getuser"] callWithArguments:@[[self returnUserInfoStr]]];

    //测试弹框信息
     self.context[@"toast"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [Utile showPromptAlertWithString:[NSString stringWithFormat:@"%@",jsVal]];
            });
        }
    };
    
    //返回活动ID,进去详情页
     self.context[@"carddetail"] = ^(){
        NSArray *args = [JSContext currentArguments];
        for (JSValue *jsVal in args) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CardDetailViewController * cardDteail = [[CardDetailViewController alloc]init];
                cardDteail.card = [[MyCard alloc]init];
                cardDteail.cardId = [[NSString stringWithFormat:@"%@",jsVal] integerValue];
                [weakSelf.navigationController pushViewController:cardDteail animated:YES];
            });

        }
    };
    
    //退出
     self.context[@"close"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.navigationController.navigationBarHidden = NO;
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        });
    };
    
    //支付宝
    self.context[@"alipay"] = ^(){
        NSArray *args = [JSContext currentArguments];
        NSString * payStr = @"";
        for (JSValue *jsVal in args) {
            NSLog(@"信息%@", [jsVal toString]);
            payStr = [jsVal toString];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (payStr.length > 20) {
                    [PayController payWithString:payStr Block:^(NSString *resultStatus) {
                        if (resultStatus.length > 0) {
                            NSString *jsFunctStr=[NSString stringWithFormat:@"alipayNotify('%@')",resultStatus];
                            [weakContext[@"setTimeout"] callWithArguments:@[jsFunctStr, @0]];
                            
                        }
                        
                    }];
                }
                
            });
            
        }
        
    };
    //唤起登录
     self.context[@"login"] = ^(){
        
        if ([[UserDao sharedInstance]loadUser] == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf withoutLogin];
                //                [Utile showPromptAlertWithString:@"唤起支付宝00"];
            });
            
        }
    };
    self.context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
}

-(void)withoutLogin{
    UIStoryboard *borad = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *loginController =[borad instantiateViewControllerWithIdentifier:@"loginNavigation"] ;
    [self.navigationController presentViewController:loginController animated:YES completion:nil] ;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    hud = [Utile showHudInView:self.navigationController.view];
    [self requestJSAction];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    hud.hidden = YES;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self requestJSAction];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [Utile showPromptAlertWithString:@"网页加载失败"];
    hud.hidden = YES;
}
@end


