
#import <UIKit/UIKit.h>
#import "SJAvatarBrowser.h"
@class HeaderView;
@protocol HeaderViewDelegate <NSObject>
-(void)showMyCardInfo;
@end


@interface HeaderView : UIView
@property(nonatomic,strong) UIButton * avatarButton;
@property(nonatomic,strong) UILabel * nameLabel;
@property(nonatomic,strong) UILabel * addressLabel;
@property(nonatomic,strong) UILabel * dayLabel;
@property(nonatomic,weak) id<HeaderViewDelegate>delegate;

-(id)init;
-(void)fillWithModel:(CardInfoModel*)model;


@end
