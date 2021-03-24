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

MAIN_MENU_VERSION_TITLE              = "BeatSaber Camera2 GUI Version"
MAIN_SELF_CREATED_BSDIR_CHK_MES      = "The BeatSaber folder is not set.Please set it up."
MAIN_SELF_CREATED_BSDIR_CHK_TITLE    = "BeatSaber folder is missing."
MODALDLG_SETTING_OK_BTN_NO_DIR_MES   = "I don't have a BeatSaber Folder. Do you want to go back and reconfigure it?"
MODALDLG_SETTING_OK_BTN_NO_DIR_TITLE = "BeatSaber Folder setting error"
SETTING_LOAD_ERROR_NO_SCENE          = "'Scenes.json' file not found."
SETTING_LOAD_ERROR_MES               = "Unable to load the configuration file."
SETTING_LOAD_ERROR_NO_CAMERA         = "There is no 'Cameras' folder."
SETTING_LOAD_ERROR_NO_DEFAULT        = "No default configuration file is available."
UNKNOWN_CAMERA_TYPE_MES              = "This is a non-compliant camera type. Cannot be used"
UNKNOWN_CAMERA_TYPE_TITLE            = "Unknown camera type"
LAYER_CONFLICT_MES                   = "Layer conflict. We will reassign the layers, so please check the order."
LAYER_CONFLICT_TITLE                 = "Layer conflict"
CHARACTER_CHECK_MES                  = "is not a valid character."
CHARACTER_CHECK_TITLE                = "Use of non-text"
MODALDLG_CUSTOM_SCENES_ERR_MES       = "is in conflict. Please rename it."
MODALDLG_CUSTOM_SCENES_ERR_TITLE     = "Conflict"
MAIN_DELETE_MES                      = "Can I delete the selected camera?"
MAIN_DELETE_TITLE                    = "Deletion confirmation"
FILE_TIME_CHECK_MES                  = "The Camera2 configuration file has been updated. Do you want to reload it? (Unsaved settings will be lost.)"
FILE_TIME_CHECK_TITLE                = "Configuration file updated."
