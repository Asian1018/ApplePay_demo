
#import <UIKit/UIKit.h>
//#import "JSTwitterCoreTextView.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"
@class DetailCardCell;
@protocol DetailCardCellDelegate <NSObject>

-(void)showInfoWithUserId:(NSInteger)userid;
-(void)addLikeResultLogin;
@end

@interface DetailCardCell : UITableViewCell
@property (nonatomic, strong) UIView * souceView;//总容器
@property (nonatomic, strong) UIImageView * photoImageView;//头像
@property (nonatomic, strong) UILabel * userNameLabel;//用户昵称
@property (nonatomic, strong) UILabel * timelabel;//时间
@property (nonatomic, strong) UIButton * addressButton;//地址
@property (nonatomic, strong) UILabel * contantView;//内容
@property (nonatomic, strong) UIView *picUrlsView;//图片缩略图
@property(nonatomic,strong) UIButton * prizeButton;//赞label
@property(nonatomic ,strong) NSMutableArray* picUrlsArray;
@property(nonatomic,strong) UILabel * lineLabel;//线
@property(nonatomic,weak) id<DetailCardCellDelegate>delegate;
-(void)setcontantWithModel:(CardRecordList*)model cardId:(NSInteger)cardId;
+(NSInteger)heightWithModel:(CardRecordList*)model;

@end
