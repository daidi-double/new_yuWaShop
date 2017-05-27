//
//  YWHttpBase.h
//  YuWaShop
//
//  Created by Tian Wei You on 16/12/6.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#ifndef YWHttpBase_h
#define YWHttpBase_h

#define HTTP_ADDRESS        @"https://www.yuwabao.cn"    //地址

#pragma mark - Logion & Register
#define HTTP_REGISTER       @"/api.php/ShopLogin/reg/" //注册账号
#define HTTP_REGISTER_CODE   @"/api.php/ShopLogin/getRegisterCode/" //注册验证码
#define HTTP_LOGION_CODE   @"/api.php/ShopLogin/getRegisterCode/" //快捷登录验证码
#define HTTP_RESET_CODE   @"/api.php/ShopLogin/getRegisterCode/" //重置密码验证码
#define HTTP_LOGIN          @"/api.php/ShopLogin/login/" //登入
#define HTTP_LOGIN_Quick      @"/api.php/ShopLogin/phoneLogin/" //快捷登录
#define HTTP_LOGIN_FORGET_TEL @"/api.php/ShopLogin/resetPassword/" //找回密码

#pragma mark - Storm
#define HTTP_STORM_TAG @"/api.php/Shop/getTagNameByCid/" //子标签
#define HTTP_SHOP_GETCATEGORY     @"/api.php/Shop/getAllCatoryAndBusiness/"   //得到大分类和商圈

#pragma mark - IMG
#define HTTP_IMG_UP @"/api.php/Index/uploadImg/" //上传图片



#pragma mark - Red Book
#define HTTP_RB_HOME @"/api.php/Note/index/" //发现首页
#define HTTP_RB_DETAIL @"/api.php/Note/detail/" //笔记详情
#define HTTP_RB_DELNODE @"/api.php/Note/del/"//删除笔记
#define HTTP_RB_RELATED @"/api.php/Note/getRelationNote/" //相关笔记
#define HTTP_RB_LIKE @"/api.php/Note/addLikes/" //添加点赞（喜欢）
#define HTTP_RB_LIKE_CANCEL @"/api.php/Note/delLikes/" //取消点赞（喜欢）
#define HTTP_RB_ALDUM @"/api.php/Note/getUserAlbumLists/" //获取用户专辑列表
#define HTTP_RB_CREATE_ALDUM @"/api.php/Note/addAlbum/" //创建专辑
#define HTTP_RB_COLLECTION_TO_ALDUM @"/api.php/Note/addToMyAlbum/" //添加收藏到我的专辑
#define HTTP_PRESON_BASEINFO   @"/api.php/User/getNewBaseInfo"//获取关注人数等
#define HTTP_RB_COLLECTION_CANCEL @"/api.php/Note/delMyNoteAlbum/" //取消收藏
#define HTTP_RB_ATTENTION_ADD @"/api.php/User/addAttention/" //关注发布者
#define HTTP_RB_ATTENTION_CANCEL @"/api.php/User/delAttention/" //删除关注
#define HTTP_RB_COMMENT @"/api.php/Note/addNoteComment/" //评论发布
#define HTTP_RB_COMMENT_LIST @"/api.php/Note/getCommentListByNoteId/" //评论列表
#define HTTP_RB_SEARCH_QUICK @"/api.php/Note/hotSearch/" //笔记热门搜索
#define HTTP_RB_SEARCH_KEY @"/api.php/Note/getRelationKeywords/" //搜索相关
#define HTTP_RB_SEARCH_RESULT @"/api.php/Note/searchResult/" //搜索结果
#define HTTP_RB_NODE_PUBLISH @"/api.php/Note/addNote/" //发布笔记
//#define HTTP_RB_ @"/api.php/Login/resetPassword/" //添加地点
//#define HTTP_RB_ @"/api.php/Login/resetPassword/" //搜索地点
#define HTTP_RB_ATTENTION @"/api.php/User/myAttention/" //我的关注

#pragma mark - IMG
#define HTTP_IMG_UP @"/api.php/Index/uploadImg/" //上传图片


#pragma mark - Storm
#define HTTP_STORM_NEARSHOP @"/api.php/Shop/getMyNearShop/" //商家
#define HTTP_STORM_SEARCH_HOT @"/api.php/Index/hotSearch/" //热门搜索
#define HTTP_STORM_SEARCH @"/api.php/Shop/searchResult/" //搜索店铺

#pragma mark - Noticafication
#define HTTP_NOTCCAFICATIONJ_ORDER @"/api.php/User/reservePushNotice/" //预约通知
#define HTTP_NOTCCAFICATIONJ_PAY @"/api.php/User/payPushNotice/" //付款通知

#pragma mark - Friends
#define HTTP_FRIENDS_INFO @"/api.php/User/getUserInfoByUserName/" //好友信息

#pragma mark - BaoBao
#define HTTP_BAOBAO_LVUP @"/api.php/User/updateMyLevel/" //雨娃宝宝升级
#define HTTP_BAOBAO_SevenConsume @"/api.php/User/getSevenConsume/" //近7次消费金额
#define HTTP_BAOBAO_ConsumeType @"/api.php/User/consumeType/" //消费在哪个大类里面
#define HTTP_BAOBAO_LuckyDraw @"/api.php/User/luckyDraw/" //抢优惠券


#pragma mark - RBAdd
#define HTTP_RBAdd_AlbumDetail @"/api.php/Note/getAlbumDetail/" //专辑详情
#define HTTP_RBAdd_DelAlbum @"/api.php/Note/delMyAlbum/" //删除笔记
#define HTTP_RBAdd_DelNode @"/api.php/Note/delMyNoteAlbum/"//取消收藏单个笔记

#pragma mark - Other
#define HTTP_Other_Node @"/api.php/Note/getOtherNewNote/"//别人的笔记
#define HTTP_Other_Aldum @"/api.php/Note/getOtherAlbum/"//别人的专辑
#define HTTP_OTHERCOMMIT   @"/api.php/Shop/getUserComment/"   //别人的评论



#pragma mark - Shoper
#define HTTP_VIP_BaseInfo   @"/api.php/ShopAdmin/getBaseInfo/"   //基本信息
#define HTTP_VIP_Sale_Detail   @"/api.php/ShopAdmin/detail/"   //交易详情信息，支持分页
#define HTTP_VIP_Sale_DetailShow   @"/api.php/ShopAdmin/detailShow/"   //每一条交易详情信息

#define HTTP_VIP_ShopAdmin_Home   @"/api.php/ShopAdmin/home/"   //门店管理首页
#define HTTP_Shoper_ShopAdmin_SetBaseInfo   @"/api.php/ShopAdmin/setBaseInfo/"   //设置店铺基本信息
#define HTTP_Shoper_ShopAdmin_SetShopMap   @"/api.php/ShopAdmin/setShopMap/"   //门店地图
#define HTTP_Shoper_GetBusinessHours   @"/api.php/ShopAdmin/getBusinessHours/"   //获取营业时间
#define HTTP_Shoper_SetBusinessHours   @"/api.php/ShopAdmin/addBusinessHours/"   //设置营业时间
#define HTTP_Shoper_DelBusinessHours   @"/api.php/ShopAdmin/delBusinessHours/"   //删除营业时间
#define HTTP_Shoper_ShopAdmin_GetSalePhone   @"/api.php/ShopAdmin/getSalePhone/"   //获取营销顾问电话
#define HTTP_Shoper_ShopAdmin_SetEnvironment   @"/api.php/ShopAdmin/setEnvironment/"   //设置环境信息
#define HTTP_Shoper_ShopAdmin_GetEnvironment   @"/api.php/ShopAdmin/getEnvironment/"   //获取环境信息
#define HTTP_Shoper_ShopAdmin_SetDiscount   @"/api.php/ShopAdmin/setDiscount/"   //设置门店折扣

#define HTTP_Shoper_ShopAdmin_MyBankList   @"/api.php/UserCard/showList/"   //设置银行卡列表
#define HTTP_PRESON_RELIEVEBANK   @"/api.php/UserCard/delete/"   //设置解绑银行卡
#define HTTP_Shoper_ShopAdmin_AddMyBank  @"/api.php/UserCard/add/"   //设置银行卡添加




#define HTTP_GETMYACTOUNTMONEY    @"/api.php/shopAdmin/cash/"//获取账户可提现金额
#define HTTP_GETMYTOBANK          @"/api.php/ShopAdmin/add_cash/"//收益提现




#define HTTP_GETMYMONEYTOBANK      @"/api.php/Withdraw/check/" //钱包零钱提现
#define HTTP_SUREGETMYMONEY         @"/api.php/Withdraw/application/"//确认提交申请提现

#define HTTP_PRESON_CHICKWHETHERHAVEPASSWORD    @"/api.php/PaymentCode/checkhas/"//检测是否设有支付密码

#define HTTP_PRESON_CHECKPASSWORD @"/api.php/PaymentCode/checkPaymentCode/"//检测支付密码是否正确
#define HTTP_PRESON_UPPASSWORD    @"/api.php/PaymentCode/setPaymentCode/"//上传支付密码
#define HTTP_Shoper_shopAdmin_PhoneCode  @"/api.php/UserCard/sendMobileCode/" //设置短信验证码
#define HTTP_PRESON_SENDPHONECODE  @"/api.php/PaymentCode/sendCode/"//忘记密码发送验证码
#define HTTP_PRESON_RESETPAYPASSWORD @"/api.php/PaymentCode/resetPaymentCode/" //重设支付密码



#define HTTP_Shoper_ShopAdmin_SetPerCapita   @"/api.php/ShopAdmin/setPerCapita/"   //设置人均消费
#define HTTP_Shoper_ShopAdmin_MyDividendMoney   @"/api.php/ShopAdmin/myDividendMoney/"   //我的分红
#define HTTP_Shoper_DailyOperation   @"/api.php/ShopAdmin/dailyOperation/"   //经营日报
#define HTTP_Shoper_ShopAdmin_AddRecord   @"/api.php/ShopAdmin/addRecord/"   //买单收银，生成二维码
#define HTTP_Shoper_ShopAdmin_RecordLists   @"/api.php/ShopAdmin/myRecordLists/"   //闪惠记录
#define HTTP_Shoper_ShopAdmin_GoodsLists   @"/api.php/ShopAdmin/goodsLists/"   //商品管理之商品列表,支持分页
#define HTTP_Shoper_ShopAdmin_AddGoods   @"/api.php/ShopAdmin/addGoods/"   //商品管理之添加商品
#define HTTP_Shoper_ShopAdmin_ChangeGoods @"/api.php/ShopAdmin/goodsEdit/"
//修改商品
#define HTTP_Shoper_ShopAdmin_DelGoods   @"/api.php/ShopAdmin/delGoods/"   //商品管理之删除商品
#define HTTP_Shoper_ShopAdmin_DelCategory   @"/api.php/ShopAdmin/delGoodsCat/"   //商品管理之删除分类
#define HTTP_Shopr_ShopAdmin_AddCategory @"/api.php/ShopAdmin/addgoodsClassify"//添加商品分类
#define HTTP_Shopr_ShopAdmin_RecomposeCategory @"//api.php/ShopAdmin/editgoodsClassify"//修改商品分类
#define HTTP_SHOP_SHOPADMIN_CATEGORY   @"/api.php/ShopAdmin/goodsClassify/"//获取店铺分类列表

#define HTTP_Shoper_ShopAdmin_AddCoupon   @"/api.php/ShopAdmin/addCoupon/"   //优惠券之生成优惠券
#define HTTP_Shoper_ShopAdmin_CouponList   @"/api.php/ShopAdmin/couponList/"   //优惠券之列表
#define HTTP_Shoper_ShopAdmin_DelCoupon   @"/api.php/ShopAdmin/delCoupon/"   //优惠券之删除
#define HTTP_Shoper_ShopAdmin_CommentList   @"/api.php/ShopAdmin/commentList/"   //口碑品牌之列表
#define HTTP_Shoper_ShopAdmin_CommentReply   @"/api.php/ShopAdmin/commentReply/"   //口碑品牌之回复
#define HTTP_Shoper_ShopAdmin_AddCheckStatus   @"/api.php/ShopAdmin/addCheckStatus/"   //提交门店实名认证
#define HTTP_Shoper_ShopAdmin_BookLists   @"/api.php/ShopAdmin/bookLists/"   //预定管理之列表
#define HTTP_Shoper_ShopAdmin_BookReply   @"/api.php/ShopAdmin/bookReply/"   //预定管理之回复
#define HTTP_Shoper_ShopAdmin_HolidayLists   @"/api.php/ShopAdmin/holidayLists/"   //节日管理之列表
#define HTTP_Shoper_ShopAdmin_DelHoliday   @"/api.php/ShopAdmin/delHoliday/"   //节日管理之删除
#define HTTP_Shoper_ShopAdmin_AddHoliday   @"/api.php/ShopAdmin/addHoliday/"   //节日管理之添加
#define HTTP_Shoper_ShopAdmin_AddShopPhoto   @"/api.php/ShopAdmin/addShopPhoto/"   //相册管理之添加
#define HTTP_Shoper_ShopAdmin_DelShopPhoto   @"/api.php/ShopAdmin/delShopPhoto/"   //相册管理之删除
#define HTTP_Shoper_ShopAdmin_ShopPhotoLists   @"/api.php/ShopAdmin/shopPhotoLists/"   //相册管理之列表

#define HTTP_Shoper_ShopAdmin_MyNotice   @"/api.php/ShopAdmin/myNotice/"   //消息通知之列表
#define HTTP_Shoper_ShopAdmin_UpdateMyNotice   @"/api.php/ShopAdmin/updateMyNotice/"   //消息通知之更新
#define HTTP_Shoper_ShopAdmin_Analysis   @"/api.php/ShopAdmin/analysis/"   //数据分析
#define HTTP_Shoper_ShopAdmin_GetShopAgreement   @"/api.php/ShopAdmin/getShopAgreement/"   //获取开店协议
#define HTTP_Shoper_ShopAdmin_GetCatTag   @"/api.php/ShopAdmin/getCatTag/"   //获取主分类及小标签
#define HTTP_Shoper_ShopAdmin_SeeSuggest   @"/api.php/ShopAdmin/seeSuggest/"   //意见反馈之查看新意见
#define HTTP_Shoper_ShopAdmin_SuggestLists   @"/api.php/ShopAdmin/suggestLists/"   //意见反馈之列表
#define HTTP_Shoper_ShopAdmin_ReplySuggest   @"/api.php/ShopAdmin/addSuggest/"   //意见反馈之反馈意见
#define HTTP_Shoper_ShopAdmin_RankLists   @"/api.php/ShopAdmin/rankLists/"   //同业排行












#pragma mark  -- 首页
#define HTTP_HOME_PAGE    @"/api.php/Index/index/"    //首页获取数据的接口
#define HTTP_HOME_MORELOADING     @"/api.php/Index/pullRefresh/"   //加载更多的数据
#define HTTP_HOME_UPDATECOORDINATE    @"/api.php/Index/updateCoordinate/"   //更新经纬度
#define HTTP_HOME_HOTSEARCH          @"/api.php/Index/hotSearch/"    //热门搜索
#define HTTP_HOME_SEARCH            @"/api.php/Index/searchResult/"     //搜索

#define HTTP_HOME_SHOPDETAIL        @"/api.php/Shop/index/"      //店铺详情
#define HTTP_HOME_SCHEDULE          @"/api.php/User/addReserve/" //店铺预定
#define HTTP_HOME_SHOPPHOTO         @"/api.php/Shop/getShopPhoto/"  //店铺相册
#define HTTP_HOME_MOREGOODS       @"/api.php/Shop/moreGoods/"  //更多商品
#define HTTP_HOME_MORECOMMIT      @"/api.php/Shop/moreComment/"  //更多评论
#define HTTP_HOME_GETCATEGORY     @"/api.php/Shop/getAllCatoryAndBusiness/"   //得到大分类和商圈
#define HTTP_HOME_CATEGORYSHOW    @"/api.php/Shop/checkShop/"    //18个分类的筛选
#define HTTP_GETPAGEVIEW          @"/api.php/Shop/addLog"      //得到浏览量


#pragma mark  -- 个人中心
#define HTTP_PERSON_COUPON         @"/api.php/User/getMyCoupon/"   //得到优惠券
#define HTTP_PRESON_CHANGEINFO     @"/api.php/User/setMyBaseInfo/"  //修改个人中心资料

#define HTTP_GETMONEY              @"/api.php/User/getMyMoney/"   //得到钱
#define HTTP_GETPAYDETAIL          @"/api.php/ShopAdmin/getMyAccount"   //得到收入支出明细
#define HTTP_GETDETAIL             @"/api.php/ShopAdmin/detailShow/"//账单详情
#define HTTP_ORDERDTEAIL           @"/api.php/ShopAdmin/getMyOrderDetail/"//订单详情
#define HTTP_MYORDER               @"/api.php/User/getMyOrder/"   //显示我的订单
#define HTTP_MAKEORDER             @"/api.php/Index/addNoPayOrder/"  //生成未付款的订单
#define HTTP_DELETEORDER           @"/api.php/Index/delOrder/"   //删除未付款的订单


#define HTTP_SHOWCOLLECTION        @"/api.php/User/getMyCollection/"   //显示收藏
#define HTTP_DELETECOLLECTION      @"/api.php/User/delCollection"     //删除收藏
#define HTTP_ADDCOLLECTION         @"/api.php/User/addCollection"     //添加收藏

#define HTTP_PAYRECORD             @"/api.php/User/myConsumption/"    //消费记录

#define HTTP_GETNOTES              @"/api.php/Note/getMyNewNote/"    //得到笔记
#define HTTP_GETALBUMS             @"/api.php/Note/getMyNewAlbum/"   //得到专辑
#define HTTP_GETCOMMIT             @"/api.php/Shop/getUserComment"   //得到评论


#define HTTP_MYABOUNT              @"/api.php/User/myAttention/"   //我的关注
#define HTTP_MYFANS                @"/api.php/User/myFans/"        //我的粉丝
#define HTTP_MYNOTEBEPRAISE        @"/api.php/User/myPraised/"     //被赞
#define HTTP_MYNOTEBECOLLECT       @"/api.php/User/myCollected/"   //被收藏
#define HTTP_TAABOUNT              @"/api.php/User/otherAttention/"  //他的关注
#define HTTP_TAFANS                @"/api.php/User/otherFans/"       //他的粉丝
#define HTTP_ADDABOUT              @"/api.php/User/addAttention/"    //加关注
#define HTTP_DELABOUT              @"/api.php/User/delAttention/"    //删除关注
#define HTTP_POSTCOMMIT            @"/api.php/Shop/addShopComment/"   //发布评价

//商务会员
#define HTTP_BUSINESS_HOME         @"/api.php/Sale/getBaseInfo/"    //商务会员首页
#define HTTP_BUSINESS_SALEINFO     @"/api.php/Sale/detail/"    //交易详情信息
#define HTTP_MY_ORDER_SHOP         @"/api.php/Sale/myInviteShop/" //我签约的店铺
#define HTTP_MY_USER               @"/api.php/Sale/myDirectUser/"  //我的绑定用户
#define HTTP_POINTGETMONEY         @"/api.php/Sale/scoreToMoney/" //积分提现
#define HTTP_DEAL_DETAIL           @"/api.php/Sale/detailShow/"  //每一条交易详情
//收支明细
#define HTTP_INCOMEOUT             @"/api.php/Sale/myMoneyHistory/"  //收支明细
//普通消费者
#define HTTP_PERSON_INTRODUCE      @"/api.php/Customer/getBaseInfo/"  //普通消费者的介绍分红
#define HTTP_PERSON_SALEINFO       @"/api.php/Customer/detail/"   //普通消费者的交易详情
#define HTTP_PERSON_DETAIL         @"/api.php/Customer/detailShow/"  //普通消费者的详情




#define HTTP_SEEOTHERCENTER       @"/api.php/User/getUserInfo/"  //查看他人个人中心

#endif /* YWHttpBase_h */
