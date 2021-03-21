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

class Form_main                                                     ##__BY_FDVR

  def self_created
    $main_windowrect = self.windowrect
    $camera_idx = nil
    $track_bar_position = {}
    $change_flag = false
    $camera_type = nil
    unless $bs_folder && File.directory?($bs_folder)
      messageBox("#{$bs_folder ? "'#{$bs_folder}'" : ""}#{MAIN_SELF_CREATED_BSDIR_CHK_MES}",
         MAIN_SELF_CREATED_BSDIR_CHK_TITLE, WConst::MB_ICONWARNING | WConst::MB_OK)
      exit unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_setting,nil,nil)
    end
    #Set tab stops for list box
    #[0x192,count,[position,....]]
    #style = LBS_USETABSTOPS
    #0x192 : LB_SETTABSTOPS
    #l*    : 32bit signed integer
    @listBox_camera.sendMessage(0x192, 2,[15,60].pack('l*'))
    camera_load
  end
  
  def button_add_clicked
  
  end
  
  def button_del_clicked
  
  end

  def button_reflection_clicked
  
  end

  def button_up_clicked
  
  end

  def button_down_clicked
  
  end

  def listBox_camera_selchanged
    if @listBox_camera.selectedString > -1
      camera_list_refresh = control_json_save
      $camera_idx = @listBox_camera.selectedString
      if camera_list_refresh
        camera_list_set($camera_idx)
      else
        camera_setting_set
      end
    end
  end
  
  def menu_setting_clicked
    $main_windowrect = self.windowrect
    return unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_setting,nil,nil)
    camera2_setting_load
  end

  def tabPanel_main_selchanged
    @tabPanel_main.panels[TAB_FOLLOW].view_set
    @tabPanel_main.panels[TAB_MODMAPEXT].view_set
    @tabPanel_main.panels[TAB_POSITION].view_set
    @tabPanel_main.panels[TAB_MOVEMENT].view_set
  end

end                                                                 ##__BY_FDVR
