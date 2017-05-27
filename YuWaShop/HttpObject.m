//
//  HttpObject.m
//  YuWa
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "HttpObject.h"
#import "JWHttpManger.h"

@implementation HttpObject
+ (id)manager{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static HttpObject *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
        [JWHttpManger shareManager];
    });
    return manager;
}

- (void)getNoHudWithType:(kYuWaType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail{
    NSString * urlStr = HTTP_ADDRESS;
    switch (type) {
#pragma mark - RB_Node
        case  YuWaType_RB_SEARCH_QUICK://笔记热门搜索
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_SEARCH_QUICK];
            break;
#pragma mark - Storm
        case YuWaType_STORM_SEARCH_HOT://热门搜索
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_STORM_SEARCH_HOT];
            break;
            //URLStr建立
        default:
            break;
    }
    [[JWHttpManger shareManager] getDatasNoHudWithUrl:urlStr withParams:pragram compliation:^(id data, NSError *error) {
        if (data&&[data[@"errorCode"] integerValue] == 0) {
            success(data);
        }else{
            fail(data,error);
        }
    }];
}

- (void)postDataWithType:(kYuWaType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail{
    NSString * urlStr = HTTP_ADDRESS;
    switch (type) {
#pragma mark - Register
        case YuWaType_Register://注册账号
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_REGISTER];
            break;
        case YuWaType_Shoper_ShopAdmin_GetShopAgreement://获取开店协议
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_GetShopAgreement];
            break;
#pragma mark - Login
        case YuWaType_Logion://登入
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOGIN];
            break;
        case YuWaType_Logion_Quick://快捷登录
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOGIN_Quick];
            break;
#pragma mark - ForgetPassWord
        case YuWaType_Logion_Forget_Tel://找回密码
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOGIN_FORGET_TEL];
            break;
#pragma mark - RB_NODE
        case YuWaType_RB_COMMENT://评论发布
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_COMMENT];
            break;
        case YuWaType_RB_ATTENTION://显示关注
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_ATTENTION];
            break;
        case YuWaType_RB_SEARCH_RESULT://搜索结果
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_SEARCH_RESULT];
            break;
        case YuWaType_RB_NODE_PUBLISH://发布笔记
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_NODE_PUBLISH];
            break;
        case YuWaType_RB_DETAIL://笔记详情
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_DETAIL];
            break;
#pragma mark - Friends
        case YuWaType_FRIENDS_INFO://好友信息
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_FRIENDS_INFO];
            break;
            
#pragma mark - Shoper
        case YuWaType_VIP_Sale_Detail://交易详情信息，支持分页
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_VIP_Sale_Detail];
            break;
        case YuWaType_VIP_Sale_DetailShow://每一条交易详情信息
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_VIP_Sale_DetailShow];
            break;

        case YuWaType_ShopAdmin_Home://门店管理首页
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_VIP_ShopAdmin_Home];
            break;
        case YuWaType_Shoper_ShopAdmin_SetBaseInfo://设置店铺基本信息
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_SetBaseInfo];
            break;
        case YuWaType_Shoper_ShopAdmin_SetEnvironment://设置门店环境信息
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_SetEnvironment];
            break;
        case YuWaType_Shoper_ShopAdmin_SetDiscount://设置门店折扣
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_SetDiscount];
            break;
        case YuWaType_Shoper_ShopAdmin_SetPerCapita://设置人均消费
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_SetPerCapita];
            break;
        case YuWaType_Shoper_ShopAdmin_MyDividendMoney://我的分红
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_MyDividendMoney];
            break;
        case YuWaType_Shoper_ShopAdmin_AddRecord://买单收银，生成二维码
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_AddRecord];
            break;
        case YuWaType_Shoper_ShopAdmin_AddGoods://商品管理之添加商品
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_AddGoods];
            break;
        case YuWaType_Shoper_ShopAdmin_changGoods:
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_ChangeGoods];
            break;
        case YuWaType_Shoper_ShopAdmin_DelGoods://商品管理之删除商品
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_DelGoods];
            break;
            
        case YuWaType_Shoper_ShopAdmin_DelCategory://商品管理之删除分类
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_DelCategory];
            break;
        case YuWaType_Shoper_ShopAdmin_AddCoupon://优惠券之生成优惠券
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_AddCoupon];
            break;
        case YuWaType_Shoper_ShopAdmin_CommentReply://口碑品牌之回复
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_CommentReply];
            break;
        case YuWaType_Shoper_ShopAdmin_DelShopPhoto://相册管理之删除
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_DelShopPhoto];
            break;
        case YuWaType_Shoper_ShopAdmin_AddShopPhoto://相册管理之添加
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_AddShopPhoto];
            break;
        case YuWaType_Shoper_ShopAdmin_AddHoliday://节日管理之添加
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_AddHoliday];
            break;
        case YuWaType_Shoper_ShopAdmin_DelHoliday://节日管理之删除
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_DelHoliday];
            break;
        case YuWaType_Shoper_ShopAdmin_BookReply://预定管理之回复
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_BookReply];
            break;
        case YuWaType_Shoper_ShopAdmin_AddCheckStatus://提交门店实名认证
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_AddCheckStatus];
            break;
        case YuWaType_Shoper_ShopAdmin_Analysis://数据分析
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_Analysis];
            break;

        case YuWaType_Shoper_SetBusinessHours://设置营业时间
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_SetBusinessHours];
            break;
        case YuWaType_Shoper_ShopAdmin_GetEnvironment://获取环境信息
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_GetEnvironment];
            break;
        case YuWaType_Shoper_GetBusinessHours://获取营业时间
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_GetBusinessHours];
            break;
        case YuWaType_Shoper_ShopAdmin_SeeSuggest://意见反馈之查看新意见
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_SeeSuggest];
            break;
        case YuWaType_Shoper_ShopAdmin_ReplySuggest://意见反馈之反馈意见
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_ReplySuggest];
            break;
        case YuWaType_Shoper_DailyOperation://经营日报
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_DailyOperation];
            break;
        case YuWaType_Shoper_ShopAdmin_DelCoupon://优惠券之删除
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_DelCoupon];
            break;
        case YuWaType_Shoper_DelBusinessHours://删除营业时间
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_DelBusinessHours];
            break;
            
           //URLStr建立
        default:
            break;
    }
    [[JWHttpManger shareManager] postDatasWithUrl:urlStr withParams:pragram compliation:^(id data, NSError *error) {
        if (data&&[data[@"errorCode"] integerValue] == 0) {
            success(data);
        }else{
            fail(data,error);
        }
    }];
}

- (void)postNoHudWithType:(kYuWaType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail{
    NSString * urlStr = HTTP_ADDRESS;
    switch (type) {
#pragma mark - MessageComfiredCode
        case YuWaType_Register_Code://注册验证码
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_REGISTER_CODE];
            break;
        case YuWaType_Logion_Code://快捷登录验证码
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOGION_CODE];
            break;
        case YuWaType_Reset_Code://重置密码验证码
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RESET_CODE];
            break;
#pragma mark - Login
        case YuWaType_Logion://登入
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_LOGIN];
            break;
#pragma mark - RB_NODE
        case YuWaType_RB_HOME://发现首页
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_HOME];
            break;
        case YuWaType_RB_RELATED://相关笔记
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_RELATED];
            break;
        case YuWaType_RB_COMMENT_LIST://评论列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_COMMENT_LIST];
            break;
        case YuWaType_RB_LIKE://添加点赞（喜欢）
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_LIKE];
            break;
        case YuWaType_RB_LIKE_CANCEL://取消点赞（喜欢）
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_LIKE_CANCEL];
            break;
        case YuWaType_RB_ALDUM://获取用户专辑列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_ALDUM];
            break;
        case YuWaType_RB_CREATE_ALDUM://创建专辑
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_CREATE_ALDUM];
            break;
        case YuWaType_RB_COLLECTION_TO_ALDUM://添加收藏到我的专辑
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_COLLECTION_TO_ALDUM];
            break;
        case YuWaType_RBAdd_DelAlbum://删除笔记
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RBAdd_DelAlbum];
            break;
        case YuWaType_RB_COLLECTION_CANCEL://取消收藏
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_COLLECTION_CANCEL];
            break;
        case YuWaType_RB_ATTENTION_ADD://关注发布者
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_ATTENTION_ADD];
            break;
        case YuWaType_RB_ATTENTION_CANCEL://删除关注
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_ATTENTION_CANCEL];
            break;
        case YuWaType_RB_ATTENTION://显示关注
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_ATTENTION];
            break;
        case YuWaType_RB_SEARCH_KEY://搜索相关
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RB_SEARCH_KEY];
            break;
#pragma mark - Storm
        case YuWaType_STORM_NEARSHOP://商家
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_STORM_NEARSHOP];
            break;
        case YuWaType_STORM_TAG://子标签
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_STORM_TAG];
            break;
        case YuWaType_STORM_SEARCH://搜索店铺
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_STORM_SEARCH];
            break;
#pragma mark - Noticafication
        case YuWaType_NOTCCAFICATIONJ_ORDER://预约通知
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_NOTCCAFICATIONJ_ORDER];
            break;
        case YuWaType_NOTCCAFICATIONJ_PAY://付款通知
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_NOTCCAFICATIONJ_PAY];
            break;
#pragma mark - Friends
        case YuWaType_FRIENDS_INFO://好友信息
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_FRIENDS_INFO];
            break;
#pragma mark - BaoBao
        case YuWaType_BAOBAO_LVUP://雨娃宝宝升级
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_BAOBAO_LVUP];
            break;
        case YuWaType_BAOBAO_SevenConsume://近7次消费金额
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_BAOBAO_SevenConsume];
            break;
        case YuWaType_BAOBAO_ConsumeType://消费在哪个大类里面
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_BAOBAO_ConsumeType];
            break;
        case YuWaType_BAOBAO_LuckyDraw://抢优惠券
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_BAOBAO_LuckyDraw];
            break;
            
#pragma mark - Other
        case YuWaType_Other_Node://别人的笔记
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Other_Node];
            break;
        case YuWaType_Other_Aldum://别人的专辑
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Other_Aldum];
            break;
#pragma mark - RBAdd
        case YuWaType_RBAdd_AlbumDetail://专辑详情
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RBAdd_AlbumDetail];
            break;
        case YuWaType_RBAdd_DelNode://取消收藏单个笔记
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_RBAdd_DelNode];
            break;

        case YuWaType_SHOP_GETCATEGORY://得到大分类和商圈
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SHOP_GETCATEGORY];
            break;
            
#pragma mark - Shoper
        case YuWaType_VIP_BaseInfo://基本信息
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_VIP_BaseInfo];
            break;
        case YuWaType_PRESON_BANKLIST://银行卡列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_MyBankList];
            break;
        case YuWaType_Shoper_ShopAdmin_SetShopMap://门店地图
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_SetShopMap];
            break;
        case YuWaType_Shoper_ShopAdmin_GetSalePhone://获取营销顾问电话
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_GetSalePhone];
            break;
        case YuWaType_Shoper_ShopAdmin_RecordLists://闪惠记录
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_RecordLists];
            break;
        case YuWaType_Shoper_ShopAdmin_CouponList://优惠券之列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_CouponList];
            break;
        case YuWaType_Shoper_ShopAdmin_CommentList://口碑品牌之列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_CommentList];
            break;
        case YuWaType_Shoper_ShopAdmin_MyNotice://消息通知之列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_MyNotice];
            break;
        case YuWaType_Shoper_ShopAdmin_GoodsLists://商品管理之商品列表,支持分页
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_GoodsLists];
            break;
        case YuWaType_Shoper_ShopAdmin_AddGoodsCategory://商品管理之分类列表,支持分页
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_SHOP_SHOPADMIN_CATEGORY];
            break;
        case YuWaType_Shoper_ShopAdmin_SetBaseInfo://设置店铺基本信息
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_SetBaseInfo];
            break;
        case YuWaType_Shoper_ShopAdmin_BookLists://预定管理之列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_BookLists];
            break;
        case YuWaType_Shoper_ShopAdmin_HolidayLists://节日管理之列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_HolidayLists];
            break;
        case YuWaType_Shoper_ShopAdmin_ShopPhotoLists://相册管理之列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_ShopPhotoLists];
            break;
        case YuWaType_Shoper_ShopAdmin_UpdateMyNotice://消息通知之更新
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_UpdateMyNotice];
            break;
        case YuWaType_Shoper_ShopAdmin_GetCatTag://获取主分类及小标签
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_GetCatTag];
            break;
        case YuWaType_Shoper_ShopAdmin_GetEnvironment://获取环境信息
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_GetEnvironment];
            break;
        case YuWaType_Shoper_GetBusinessHours://获取营业时间
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_GetBusinessHours];
            break;
        case YuWaType_Shoper_ShopAdmin_SuggestLists://意见反馈之列表
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_SuggestLists];
            break;
        case YuWaType_Shoper_ShopAdmin_RankLists://同业排行
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_Shoper_ShopAdmin_RankLists];
            break;
            
            //URLStr建立
        default:
            break;
    }
    [[JWHttpManger shareManager] postDatasNoHudWithUrl:urlStr withParams:pragram compliation:^(id data, NSError *error) {
        if (data&&[data[@"errorCode"] integerValue] == 0) {
            success(data);
        }else{
            fail(data,error);
        }
    }];
}


- (void)postPhotoWithType:(kYuWaType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail withPhoto:(NSData *)photo{
    NSString * urlStr = HTTP_ADDRESS;
    switch (type) {
#pragma mark - IMG
        case YuWaType_IMG_UP://上传图片
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_IMG_UP];
            break;
          
        case YuWaType_IMG_UP_NOHUD://上传图片
            urlStr = [NSString stringWithFormat:@"%@%@",HTTP_ADDRESS,HTTP_IMG_UP];
            break;
        default:
            break;
    }
    if (type == YuWaType_IMG_UP_NOHUD) {
        [[JWHttpManger shareManager] postNoHudUpdatePohotoWithUrl:urlStr withParams:pragram withPhoto:photo compliation:^(id data, NSError *error) {
            MyLog(@"认证中");
            if (data&&[data[@"errorCode"] integerValue] == 0) {
                success(data);
                
            }else{
                fail(data,error);
            }
        }];
 
    }else{
           [[JWHttpManger shareManager] postUpdatePohotoWithUrl:urlStr withParams:pragram withPhoto:photo compliation:^(id data, NSError *error) {
        if (data&&[data[@"errorCode"] integerValue] == 0) {
            success(data);
           
        }else{
            fail(data,error);
        }
    }];
    }
}

@end
