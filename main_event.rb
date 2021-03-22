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

class Form_main                                                     ##__BY_FDVR

  def self_created
    $main_windowrect = self.windowrect
    $camera_idx = nil
    $track_bar_position = {}
    $change_flag = false
    $camera_type = nil
    $main_form = self
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
  
  def button_add_clicked(copy_json = $positionable_default)
    $apply_ok = false
    number = 1
    camera_name = ""
    ok = true
    while (ok) do
      camera_name = "NewCamera#{number}"
      $cameras_json.each do |camera|
        ok = false if camera[CAMERA_NAME] == camera_name
      end
      if ok
        break
      else
        number += 1
        ok = true
      end
    end
    $cameras_json.push [camera_name, copy_json, "", true]
    control_json_save
    $camera_idx = $cameras_json.size - 1
    camera_list_set($camera_idx)
    $apply_ok = true
  end
  
  def button_copy_clicked
    $apply_ok = false
    control_json_save
    button_add_clicked($cameras_json[$camera_idx][CAMERA_JSON])
    $apply_ok = true
  end

  def button_del_clicked
    return if $cameras_json.size <= 1
    $apply_ok = false
    $delete_camera.push $cameras_json.delete_at($camera_idx)
    $camera_idx = $cameras_json.size - 1 if $camera_idx >= $cameras_json.size
    camera_list_set($camera_idx)
    $apply_ok = true
  end

  def button_save_clicked
    SWin::Application.doevents
    camera_list_set($camera_idx) if control_json_save
    json_file_save
  end
  
  def button_apply_clicked
    button_save_clicked
    if AUTOIT.WinWait(BEATSABER_WINDOW_NAME,"",1) == 1
      AUTOIT.WinActivate(BEATSABER_WINDOW_NAME)
      AUTOIT.WinWaitActive(BEATSABER_WINDOW_NAME, "", 1)
      AUTOIT.Send("^+{F1}")
      puts "Send Key!"
    end
  end

  def button_list_up_clicked
    return if $camera_idx == 0
    $apply_ok = false
    control_json_save
    $cameras_json[$camera_idx - 1], $cameras_json[$camera_idx] = $cameras_json[$camera_idx], $cameras_json[$camera_idx - 1]
    $cameras_json[$camera_idx][CAMERA_CHANGE] = true
    $cameras_json[$camera_idx - 1][CAMERA_CHANGE] = true
    $camera_idx -= 1
    camera_list_set($camera_idx)
    $apply_ok = true
  end

  def button_list_down_clicked
    return if $camera_idx == $cameras_json.size - 1
    $apply_ok = false
    control_json_save
    $cameras_json[$camera_idx + 1], $cameras_json[$camera_idx] = $cameras_json[$camera_idx], $cameras_json[$camera_idx + 1]
    $cameras_json[$camera_idx][CAMERA_CHANGE] = true
    $cameras_json[$camera_idx + 1][CAMERA_CHANGE] = true
    $camera_idx += 1
    camera_list_set($camera_idx)
    $apply_ok = true
  end

  def listBox_camera_selchanged
    $apply_ok = false
    if @listBox_camera.selectedString > -1
      camera_list_refresh = control_json_save
      $camera_idx = @listBox_camera.selectedString
      if camera_list_refresh
        camera_list_set($camera_idx)
      else
        camera_setting_set
      end
    end
    $apply_ok = true
  end
  
  def menu_setting_clicked
    $main_windowrect = self.windowrect
    return unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_setting,nil,nil)
    camera2_setting_load
  end

  def tabPanel_main_selchanged
    $apply_ok = false
    @tabPanel_main.panels[TAB_FOLLOW].view_set
    @tabPanel_main.panels[TAB_MODMAPEXT].view_set
    @tabPanel_main.panels[TAB_POSITION].view_set
    @tabPanel_main.panels[TAB_MOVEMENT].view_set
    $apply_ok = true
  end

end                                                                 ##__BY_FDVR
