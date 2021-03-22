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


#Set 'EXE_DIR' directly at runtime
EXE_DIR = (File.dirname(File.expand_path($0)).sub(/\/$/,'') + '/').gsub(/\//,'\\') unless defined?(EXE_DIR)

#Predefined Constants
#EXE_DIR ****** Folder with EXE files[It ends with '\']
#MAIN_RB ****** Main ruby script file name
#ERR_LOG ****** Error log file name

#Setting
SETTING_FILE = EXE_DIR + "setting.json"
FIRSTPERSON_DEFAULT  = EXE_DIR + "FirstPersonDefault.json"
POSITIONABLE_DEFALUT = EXE_DIR + "PositionableDefault.json"
BEATSABER_WINDOW_NAME = "Beat Saber"
BS_WIN_ACTIVE_WAITE   = 0.5

DEFAULT_BS_FOLDER = ["C:\\Program Files (x86)\\Steam\\steamapps\\common\\Beat Saber",
                     "C:\\Program Files\\Oculus\\Software\\hyperbolic-magnetism-beat-saber"]
CAMERA2_SCENES_JSON  = "UserData\\Camera2\\Scenes.json"
CAMERA2_CAMERAS_DIR  = "UserData\\Camera2\\Cameras"
CAMERA2_MOVEMENT_DIR = "UserData\\Camera2\\MovementScripts"

#Const
TAB_GENERAL    = 0
TAB_VISIBILITY = 1
TAB_FOLLOW     = 2
TAB_MODMAPEXT  = 3
TAB_SCENES     = 4
TAB_POSITION   = 5
TAB_MOVEMENT   = 6

CAMERA_NAME   = 0
CAMERA_JSON   = 1
CAMERA_ORG    = 2
CAMERA_CHANGE = 3

POS_ROT_ROUND = 1000000.0
#Combobox
COMBO_CAMERA_TYPE         = ["FirstPerson","Positionable"]
COMBO_WORLD_CAMVISIBILITY = ["Visible","HiddenWhilePlaying","Hidden"]
COMBO_ANTI_ALIASING       = ["1","2","4","8"]
COMBO_WALL_VISIBLITY      = ["Visible","Transparent","Hidden"]
COMBO_NOTE_VISIBILITY     = ["Hidden","Visible","ForceCustomNotes"]

TYPE_FIRSTPERSON  = COMBO_CAMERA_TYPE.index("FirstPerson")
TYPE_POSITIONABLE = COMBO_CAMERA_TYPE.index("Positionable")

#Library
require 'rubygems'
require 'json'
require 'vr/vruby'
require 'vr/contrib/msgboxconst'
require 'win32ole'

#Sub script
require 'utility'
setting_load
require "#{$language}.rb"

require '_frm_Camera2GUI'
require 'main_event'
require 'main_sub'
require 'tabpanel_event'
require 'tabpanel_set'
require 'dialog'

AUTOIT = WIN32OLE.new("AutoItX3.Control")
AUTOIT.AutoItSetOption("SendKeyDownDelay", 100)
AUTOIT.AutoItSetOption("WinWaitDelay", 10)

VRLocalScreen.start Form_main
