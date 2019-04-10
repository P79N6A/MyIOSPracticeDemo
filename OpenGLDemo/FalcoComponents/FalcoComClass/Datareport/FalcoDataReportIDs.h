#ifndef OD_DATAREPORT_CONSTANTS_DEF_H__
#define OD_DATAREPORT_CONSTANTS_DEF_H__

////opername define
#define OPERNAME_CHATMODE @"chatmode"
#define OPERNAME_LIVEMODE @"livemode"
#define OPERNAME_PENDANT @"pendant"
#define OPERNAME_VOICETYPE @"voicetype"
#define OPERNAME_BEAUTY @"beauty"
#define OPERNAME_FILTER @"filter"
#define OPERNAME_EXCEPTION @"exception" //异常上报
#define OPERNAME_LAUNCHPREF @"launchPerf"
#define OPERNAME_CONSUME @"consume"

////module define
//#define MODULE_OD_LAUNCH  @"od_launch"              //通用房间启动
#define MODULE_ENTER_ROOM @"od_enter_room"          //进房
#define MODULE_EXIT_ROOM  @"od_exit_room"           //退房
//#define MODULE_RECHARGE   @"od_recharge"            //充值
//#define MODULE_CONSUME    @"od_consume"             //消费
//#define MODULE_IN_ROOM    @"od_in_room"             //房间内操作
#define MODULE_GLIVE_AV   @"od_glive_av"            //音视频
//#define MODULE_ROOM_SETTING @"od_room_setting"      //房间内设置
//#define MODULE_OD_GROUP   @"od_group"               //群侧
//#define MODULE_OD_PUSH    @"od_push"                //推送相关


////action define
#define ACTION_STARTLIVE @"startLive" // 开播操作
#define ACTION_STOPLIVE @"stopLive" // 下播操作
#define ACTION_VIDEO_STOP @"video_stop"
#define ACTION_AUDIO_STOP @"audio_stop"
#define ACTION_SELF_VIDEO_STOP @"self_video_stop"
#define ACTION_SELF_AUDIO_STOP @"self_audio_stop"
#define ACTION_WATCHVIDEO_TIME @"watchTotalTime" // 观看时长
#define ACTION_RESULT_UNKNOW_ERROR @"result_unknow_error"   //不能处理的未知错误
#define ACTION_ENTER_ROOM_COMPLETE @"enterRoom"   //进房完成
#define ACTION_ENTER_ROOM_START @"enter_room_start"         //进房开始(可能需要等待登陆)
#define ACTION_EXIT_ROOM @"exit_room"                 //退房


#define ODREP_MODULE_APP @"app"
#define ODREP_ACTION_APP_START @"start"
#define ODRep_ACTION_APP_SHOWHALL @"show_hall" // 承接页加载成功

#define ODREP_MODULE_MEMBER @"member"
#define ODREP_ACTION_MEMBER_CLICK @"memberlist_click"
#define ODREP_ACTION_MEMBER_CHKMANAGERS @"check_managers"

#define ODREP_MODULE_ROOMMANAGE @"room_management"
#define ODREP_ACTION_ROOMMANAGE_FORBIDWORD @"room_forbid_words"
#define ODREP_ACTION_ROOMMANAGE_CHANGEVISITLIMIT @"change_visit_limit"
#define ODREP_ACTION_ROOMMANAGE_CHANGEROOMMODE @"settingRoomMode" //设置房间模式操作

#define ODREP_MODULE_GIFT @"gift"
#define ODREP_ACTION_GIFT_SENDCLICK @"sendGift" // 点击送礼
#define ODREP_ACTION_GIFT_SEND @"send_gift" // 发起送礼请求（1s1次聚合请求）
#define ODREP_ACTION_GIFT_SENDSUCC @"send_gift_succ" // 送礼成功
#define ODREP_ACTION_GIFT_SENDFAIL @"send_gift_fail" // 送礼失败
#define ODREP_ACTION_GIFT_PANELCLICK @"giftpanel_click" // 点击礼物面板
#define ODREP_ACTION_GIFT_PICKSET @"pick_giftset" // 选择梳理
#define ODREP_ACTION_GIFT_PICKRECUID @"pick_recUid" // 选择收礼人

#define ODREP_MODULE_ROOM @"room"
#define ODREP_ACTION_ROOM_SHOW @"room_show"
#define ODREP_ACTION_ROOM_SHOWMINICARD @"miniProfileClick" // 展示mini资料卡
#define ODREP_ACTION_ROOM_FOLLOWCLICK @"followAnchor" // 点击关注
#define ODREP_ACTION_ROOM_SENDMSG @"sendMessage" // 公屏发言
#define ODREP_ACTION_ROOM_CHIEFLINEUPCLK @"lineUpBtnClick" // 排麦按钮点击
#define ODREP_ACTION_ROOM_CHIEFIMMCLK @"immBtnClick" // 立即排麦按钮点击
#define ODREP_ACTION_ROOM_LINEUPONSTAGE @"lineUpOnStage"// 排麦上舞台101
#define ODREP_ACTION_ROOM_CHANGEAVSTATUS @"changeAVStatus" // 变更音视频状态
#define ODREP_ACTION_ROOM_LINEBTNCLK @"lineBtnClick" // 排麦按钮点击
#define ODREP_ACTION_ROOM_ENTERLINELIST @"enterLineQueue" // 进入连麦列表

#define ODREP_MODULE_RESDOWNLOAD @"resdownload"
#define ODREP_ACTION_RESLOAD_BASESUCC @"load_baseImg_succ"
#define ODREP_ACTION_RESLOAD_BASEFAIL @"load_baseImg_fail"
#define ODREP_ACTION_RESLOAD_SUCC @"load_succ"
#define ODREP_ACTION_RESLOAD_FAIL @"load_fail"

#define ODREP_MODULE_MAINSTAGE @"mainstage"
#define ODREP_ACTION_STAGE_ENDLIANMAI @"lianmai_end_click"

#define ODREP_MODULE_BOTTOMBAR @"roombottombar"
#define ODREP_ACTION_BOTTOM_CANCELLIANMAI @"lianmai_cancel_click"
#define ODREP_ACTION_BOTTOM_OPENCAMERACLICK @"opencamera_click"
#define ODREP_ACTION_BOTTOM_OPENMORE @"open_more_page"

#define ODREP_MODULE_CHARGE @"charge"
#define ODREP_ACTION_CHARGE_CLICK @"charge_click"

#define ODREP_MODULE_LIVESETTING @"livesetting"
#define ODREP_ACTION_LIVESET_OPENCAMERA @"opencamera_click"

#define ODREP_MODULE_SPECIALEFFECTS @"specialeffects"
#define ODREP_ACTION_SPECIALEFFECTS_SELECTED @"specialeffects_selected"
#define ODREP_ACTION_SPECIALEFFECTS_BEAUTYCHANGE @"specialeffects_beautychange"

#define ODREP_MODULE_SHEETMENU @"sheetmenu"
#define ODREP_ACTION_MENU_MICICO @"mic_ico_click"

#define ODREP_MODULE_OCSMGR @"ODOCSMGR"
#define ODREP_ACTION_OCSLOADSUCC @"od_ocs_load_succ"

#define ODREP_MODULE_LOGIN @"login"
#define ODREP_ACTION_LOGIN_DONE @"loginResult"

#endif /* OD_DATAREPORT_CONSTANTS_DEF_H__ */



