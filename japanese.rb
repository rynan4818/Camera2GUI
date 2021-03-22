#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
#
$KCODE='s'
#==============================================================================
#Project Name    : BeatSaber Camera2GUI
#Creation Date   : 2021/03/20
#Copyright       : (c) 2021 rynan4818 (Twitter @rynan4818)
#License         : MIT License
#                  https://github.com/rynan4818/Camera2GUI/blob/main/LICENSE
#Tool            : ActiveScriptRuby(1.8.7-p330)
#                  https://www.artonx.org/data/asr/
#                  FormDesigner Release v2020/06/18
#                  https://github.com/rynan4818/formdesigner
#RubyGems Package: rubygems-update (1.8.21)      https://rubygems.org/
#                  json (1.4.6 x86-mswin32)
#==============================================================================

MAIN_SELF_CREATED_BSDIR_CHK_MES      = "BeatSaber フォルダの設定がありません。設定画面を開くので設定して下さい。"
MAIN_SELF_CREATED_BSDIR_CHK_TITLE    = "BeatSaber フォルダ未設定"
MODALDLG_SETTING_OK_BTN_NO_DIR_MES   = "BeatSaber Folderがありません。戻って再設定しますか？"
MODALDLG_SETTING_OK_BTN_NO_DIR_TITLE = "BeatSaber Folder 設定ミス"
SETTING_LOAD_ERROR_NO_SCENE          = "'Scenes.json' ファイルが見つかりません。"
SETTING_LOAD_ERROR_MES               = "設定ファイルが読み込めません。"
SETTING_LOAD_ERROR_NO_CAMERA         = "'Cameras'のフォルダがありません。"
SETTING_LOAD_ERROR_NO_DEFAULT        = "デフォルト設定ファイルがありません。"
UNKNOWN_CAMERA_TYPE_MES              = "非対応のカメラタイプです。使用できません。"
UNKNOWN_CAMERA_TYPE_TITLE            = "未知のカメラタイプ"
LAYER_CONFLICT_MES                   = "レイヤーが競合しています。レイヤーを振り直しますので、順序を確認して下さい。"
LAYER_CONFLICT_TITLE                 = "レイヤー競合"
CHARACTER_CHECK_MES                  = "は使用できない文字です"
CHARACTER_CHECK_TITLE                = "使用不可文字"
