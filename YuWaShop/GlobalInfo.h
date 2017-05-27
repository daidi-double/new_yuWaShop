//
//  GlobalInfo.h
//  NewVipxox
//
//  Created by 黄佳峰 on 16/8/30.
//  Copyright © 2016年 黄蜂大魔王. All rights reserved.
//

#ifndef GlobalInfo_h
#define GlobalInfo_h





#pragma mark  --    商家版的接口
#define SHOP_UPDATEIMAGE        @"/api.php/Index/uploadImg/"   //先上传照片 返回url

#define SHOP_PHOTO_ALBUM        @"/api.php/ShopAdmin/shopPhotoLists/"  //获取相册列表
#define SHOP_PHOTO_DELETE       @"/api.php/ShopAdmin/delShopPhoto/"   //删除相册
#define SHOP_PHOTO_ADD          @"/api.php/ShopAdmin/addShopPhoto/"   //添加新的图片
#define SHOP_PHOTI_CHANGE_TITLE @"/api.php/ShopAdmin/savePhotoName/"  //修改图片名字

#define SHOP_FINANCIALBASE      @"/api.php/ShopAdmin/financeBase/"  //财务管理基本信息
#define SHOP_FINANCIALLIST      @"/api.php/ShopAdmin/financeList/"  //财务管理的列表
#define SHOP_EVERY_RECORD       @"/api.php/ShopAdmin/financeDetail/"  //每条记录

#define SHOP_COMMENTLIST        @"/api.php/ShopAdmin/commentList/"    //口碑品牌之列表
#define SHOP_COMMENTREPLY       @"/api.php/ShopAdmin/commentReply/"   //口碑回复


#define SHOP_HOME_SHAREMONEY    @"/api.php/ShopAdmin/myDividendMoney/"  //我的分红的首页
#define SHOP_Filter_LIST        @"/api.php/ShopAdmin/myDividendDetail/"  //筛选列表
#define SHOP_Filter_DETAIL      @"/api.php/ShopAdmin/myDividendDetailShow/" //每条信息的详细
#define SHOP_BIND_USER          @"/api.php/ShopAdmin/myDirectUser/"  //绑定的用户
#define SHOP_POINT_GETMONEY     @"/api.php/ShopAdmin/scoreToMoney/"      //分红提现



#endif /* GlobalInfo_h */
