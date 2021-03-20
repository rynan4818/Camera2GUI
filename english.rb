#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
#このスクリプトの文字コードはSJISです。
$KCODE='s'
#==============================================================================
#Project Name    : BeatSaber Camera2GUI
#Creation Date   : 2021/03/20
#Copyright       : 2021 (c) リュナン (Twitter @rynan4818)
#License         : MIT License
#                  https://github.com/rynan4818/Camera2GUI/blob/main/LICENSE
#Tool            : ActiveScriptRuby(1.8.7-p330)
#                  https://www.artonx.org/data/asr/
#                  FormDesigner Release v2020/06/18
#                  https://github.com/rynan4818/formdesigner
#RubyGems Package: rubygems-update (1.8.21)      https://rubygems.org/
#                  json (1.4.6 x86-mswin32)
#==============================================================================

MAIN_SELF_CREATED_BSDIR_CHK_MES      = "The BeatSaber folder is not set.Please set it up."
MAIN_SELF_CREATED_BSDIR_CHK_TITLE    = "BeatSaber folder is missing."
MODALDLG_SETTING_OK_BTN_NO_DIR_MES   = "I don't have a BeatSaber Folder. Do you want to go back and reconfigure it?"
MODALDLG_SETTING_OK_BTN_NO_DIR_TITLE = "BeatSaber Folder setting error"
SETTING_LOAD_ERROR_NO_SCENE          = "'Scenes.json' file not found"
SETTING_LOAD_ERROR_MES               = "Unable to load the configuration file for Camera2"
SETTING_LOAD_ERROR_NO_CAMERA         = "There is no 'Cameras' setting"
UNKNOWN_CAMERA_TYPE_MES              = "This is a non-compliant camera type. Cannot be used."
UNKNOWN_CAMERA_TYPE_TITLE            = "Unknown camera type."
