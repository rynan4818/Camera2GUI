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

class Form_main
  def setting_load_error(mes)
    messageBox("#{mes}\r\n#{SETTING_LOAD_ERROR_MES}",
      mes, WConst::MB_OK | WConst::MB_ICONERROR)
    $scene_json = nil
  end

  def camera_list_set
    if $cameras_name == []
      @listBox_camera.clearStrings
    else
      @listBox_camera.setListStrings($cameras_name)
      @listBox_camera.select(0)
      listBox_camera_selchanged
    end
  end

  def camera_setting_set
    @tabPanel_main.panels[TAB_GENERAL].control_set
    @tabPanel_main.panels[TAB_VISIBILITY].control_set
    @tabPanel_main.panels[TAB_FOLLOW].control_set
    @tabPanel_main.panels[TAB_MODMAPEXT].control_set
    @tabPanel_main.panels[TAB_MOVEMENT].movement_list_set
  end

end
