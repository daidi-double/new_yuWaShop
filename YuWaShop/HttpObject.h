//
//  HttpObject.h
//  YuWa
//
//  Created by Tian Wei You on 16/8/8.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum YuWaType{
    YuWaType_Register,//注册账号
    YuWaType_Register_Code,//注册验证码
    
    YuWaType_Logion,//登入
    YuWaType_Logion_Quick,//快捷登录
    YuWaType_Logion_Code,//快捷登录验证码
    
    YuWaType_Logion_Forget_Tel,//找回密码
    YuWaType_Reset_Code,//重置密码验证码
    
    YuWaType_STORM_TAG, //子标签
    YuWaType_SHOP_GETCATEGORY, //得到大分类和商圈
    
    
    YuWaType_IMG_UP, //上传图片
    YuWaType_IMG_UP_NOHUD, //上传图片
   
    YuWaType_RB_HOME, //发现首页
    YuWaType_RB_DETAIL, //笔记详情
    YuWaType_RB_RELATED, //相关笔记
    YuWaType_RB_LIKE, //添加点赞（喜欢）
    YuWaType_RB_LIKE_CANCEL, //取消点赞（喜欢）
    YuWaType_RB_ALDUM, //获取用户专辑列表
    YuWaType_RB_CREATE_ALDUM, //创建专辑
    YuWaType_RB_COLLECTION_TO_ALDUM, //添加收藏到我的专辑
    YuWaType_RB_COLLECTION_CANCEL, //取消收藏
    YuWaType_RB_ATTENTION_ADD, //关注发布者
    YuWaType_RB_ATTENTION_CANCEL, //删除关注
    YuWaType_RB_COMMENT, //评论发布
    YuWaType_RB_COMMENT_LIST, //评论列表
    YuWaType_RB_SEARCH_QUICK, //笔记热门搜索
    YuWaType_RB_SEARCH_KEY, //搜索相关
    YuWaType_RB_SEARCH_RESULT, //搜索结果
    YuWaType_RB_NODE_PUBLISH, //发布笔记
    YuWaType_RB_ATTENTION, //我的关注
    
    YuWaType_STORM_NEARSHOP, //商家
    YuWaType_STORM_SEARCH_HOT, //热门搜索
    YuWaType_STORM_SEARCH, //搜索店铺
    
    YuWaType_NOTCCAFICATIONJ_ORDER, //预约通知
    YuWaType_NOTCCAFICATIONJ_PAY, //付款通知
    
    YuWaType_FRIENDS_INFO, //好友信息
    
    YuWaType_BAOBAO_LVUP, //雨娃宝宝升级
    YuWaType_RBAdd_AlbumDetail, //专辑详情
    YuWaType_RBAdd_DelAlbum, //删除笔记
    YuWaType_RBAdd_DelNode,//取消收藏单个笔记
    

    YuWaType_BAOBAO_SevenConsume, //近7次消费金额
    YuWaType_BAOBAO_ConsumeType, //消费在哪个大类里面
    YuWaType_BAOBAO_LuckyDraw, //抢优惠券
    
    YuWaType_Other_Node,//别人的笔记
    YuWaType_Other_Aldum,//别人的专辑
    
    YuWaType_PRESON_BANKLIST,//获取银行卡列表
    
    
    YuWaType_VIP_BaseInfo,//基本信息
    YuWaType_VIP_Sale_Detail,//交易详情信息，支持分页
    YuWaType_VIP_Sale_MyDirectUser,//我的绑定用户
    YuWaType_VIP_Sale_MyInviteShop,//我签约的商铺
    YuWaType_VIP_Sale_MyMoneyHistory,//收支明细
    YuWaType_VIP_Sale_DetailShow,//每一条交易详情信息
    YuWaType_VIP_Sale_ScoreToMoney,//积分提现
    
    YuWaType_ShopAdmin_Home,//门店管理首页
    YuWaType_Shoper_ShopAdmin_SetBaseInfo,//设置店铺基本信息
    YuWaType_Shoper_ShopAdmin_SetShopMap,//门店地图
    YuWaType_Shoper_ShopAdmin_GetSalePhone,//获取营销顾问电话
    YuWaType_Shoper_ShopAdmin_SetEnvironment,//设置门店环境信息
    YuWaType_Shoper_ShopAdmin_SetDiscount,//设置门店折扣
    YuWaType_Shoper_ShopAdmin_SetPerCapita,//设置人均消费
    YuWaType_Shoper_ShopAdmin_MyDividendMoney,//我的分红
    YuWaType_Shoper_ShopAdmin_AddRecord,//买单收银，生成二维码
    YuWaType_Shoper_ShopAdmin_RecordLists,//闪惠记录
    YuWaType_Shoper_ShopAdmin_GoodsLists,//商品管理之商品列表,支持分页
    YuWaType_Shoper_ShopAdmin_AddGoods,//商品管理之添加商品
    YuWaType_Shoper_ShopAdmin_AddGoodsCategory,//商品管理之获取分类列表
    YuWaType_Shoper_ShopAdmin_changGoods,//修改商品
    YuWaType_Shoper_ShopAdmin_DelCategory,//商品管理之删除分类
    YuWaType_Shoper_ShopAdmin_DelGoods,//商品管理之删除商品
    YuWaType_Shoper_ShopAdmin_AddCoupon,//优惠券之生成优惠券
    YuWaType_Shoper_ShopAdmin_CouponList,//优惠券之列表
    YuWaType_Shoper_ShopAdmin_DelCoupon,   //优惠券之删除
    YuWaType_Shoper_ShopAdmin_CommentList,//口碑品牌之列表
    YuWaType_Shoper_ShopAdmin_CommentReply,//口碑品牌之回复
    YuWaType_Shoper_ShopAdmin_AddCheckStatus, //提交门店实名认证
    YuWaType_Shoper_ShopAdmin_BookLists,  //预定管理之列表
    YuWaType_Shoper_ShopAdmin_BookReply,  //预定管理之回复
    YuWaType_Shoper_ShopAdmin_HolidayLists,  //节日管理之列表
    YuWaType_Shoper_ShopAdmin_DelHoliday,  //节日管理之删除
    YuWaType_Shoper_ShopAdmin_AddHoliday, //节日管理之添加
    YuWaType_Shoper_ShopAdmin_AddShopPhoto,  //相册管理之添加
    YuWaType_Shoper_ShopAdmin_DelShopPhoto,  //相册管理之删除
    YuWaType_Shoper_ShopAdmin_ShopPhotoLists,  //相册管理之列表
    YuWaType_Shoper_ShopAdmin_MyNotice,   //消息通知之列表
    YuWaType_Shoper_ShopAdmin_UpdateMyNotice,  //消息通知之更新
    YuWaType_Shoper_ShopAdmin_Analysis,  //数据分析
    YuWaType_Shoper_ShopAdmin_GetShopAgreement,   //获取开店协议
    YuWaType_Shoper_ShopAdmin_GetCatTag,   //获取主分类及小标签
    YuWaType_Shoper_ShopAdmin_GetEnvironment,   //获取环境信息
    YuWaType_Shoper_GetBusinessHours,   //获取营业时间
    YuWaType_Shoper_SetBusinessHours,   //设置营业时间
    YuWaType_Shoper_DelBusinessHours,  //设置营业时间
    YuWaType_Shoper_ShopAdmin_SeeSuggest,   //意见反馈之查看新意见
    YuWaType_Shoper_ShopAdmin_SuggestLists,   //意见反馈之列表
    YuWaType_Shoper_ShopAdmin_ReplySuggest,   //意见反馈之反馈意见
    YuWaType_Shoper_DailyOperation,   //经营日报
    
    YuWaType_Shoper_ShopAdmin_RankLists,   //同业排行
    
    YuWaType_
    
}kYuWaType;

@interface HttpObject : NSObject
#pragma mark - Singleton
+ (id)manager;

//Get无Hud请求
- (void)getNoHudWithType:(kYuWaType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail;

//Post请求
- (void)postDataWithType:(kYuWaType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail;

//Post无Hud请求
- (void)postNoHudWithType:(kYuWaType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail;

//上传照片
- (void)postPhotoWithType:(kYuWaType)type withPragram:(NSDictionary *)pragram success:(void(^)(id responsObj))success failur:(void(^)(id errorData,NSError *error))fail withPhoto:(NSData *)photo;


@end
