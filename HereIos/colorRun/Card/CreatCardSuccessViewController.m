
#import "CreatCardSuccessViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DetailCardViewController.h"
#import "InviteFriendsViewController.h"
@interface CreatCardSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation CreatCardSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MYCARD object:nil];
    self.titleLabel.text =[NSString stringWithFormat:@"- %@ -", self.model.title];
    if (self.model.image.length > 0) {
        [self.backGroundImage sd_setImageWithURL:[NSURL URLWithString:self.model.image] placeholderImage:[UIImage imageNamed:@"empty"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}
//现在去打卡
- (IBAction)signCardNowAction:(UIButton *)sender {
    DetailCardViewController * de = [[DetailCardViewController alloc]initWithStyle:UITableViewStyleGrouped];
    de.cardId = self.model.cardId;
    de.cardType = self.cardType;
    [self.navigationController pushViewController:de animated:YES];
}
//邀请好友
- (IBAction)interviteFriends:(UIButton *)sender {
    UIStoryboard * cardStoryboard = [UIStoryboard storyboardWithName:@"Card" bundle:[NSBundle mainBundle]];
    InviteFriendsViewController * card = [cardStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass([InviteFriendsViewController class])];
    card.cardId = self.model.cardId;
    card.fromType = @"1";
    card.shareUrl = self.model.shareUrl;
    [self.navigationController pushViewController:card animated:YES];
    
}



@end
