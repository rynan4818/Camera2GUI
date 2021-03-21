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

  def camera_load
    result, mes = camera2_setting_load
    unless result
      setting_load_error(mes)
      return
    end
    layer_conflict = []
    $cameras_json.sort! do |a,b|
      if a[CAMERA_JSON]["layer"] == b[CAMERA_JSON]["layer"]
        layer_conflict.push b[CAMERA_JSON]["layer"]
      end
      a[CAMERA_JSON]["layer"] <=> b[CAMERA_JSON]["layer"]
    end
    unless layer_conflict == []
      messageBox("'#{layer_conflict.join(",")}' #{LAYER_CONFLICT_MES}",
      LAYER_CONFLICT_TITLE, WConst::MB_ICONWARNING | WConst::MB_OK)
    end
    camera_list_set
  end

  def camera_list_set(idx = 0)
    if $cameras_json == []
      @listBox_camera.clearStrings
    else
      camera_list = []
      $cameras_json.each do |camera|
        camera_list.push "#{camera_list.size + 1}\t#{camera[CAMERA_JSON]["type"]}\t#{camera[CAMERA_NAME]}"
      end
      @listBox_camera.setListStrings(camera_list)
      $camera_idx = idx
      camera_setting_set
      @listBox_camera.select(idx)
    end
  end

  def camera_setting_set
    @tabPanel_main.panels[TAB_GENERAL].control_set
    @tabPanel_main.panels[TAB_VISIBILITY].control_set
    @tabPanel_main.panels[TAB_FOLLOW].control_set
    @tabPanel_main.panels[TAB_MODMAPEXT].control_set
    @tabPanel_main.panels[TAB_SCENES].control_set
    @tabPanel_main.panels[TAB_POSITION].control_set
    @tabPanel_main.panels[TAB_MOVEMENT].control_set
  end

  def control_json_save
    camera_list_refresh = false
    tab_general    = @tabPanel_main.panels[TAB_GENERAL]
    tab_visibility = @tabPanel_main.panels[TAB_VISIBILITY]
    tab_follow     = @tabPanel_main.panels[TAB_FOLLOW]
    tab_modmapext  = @tabPanel_main.panels[TAB_MODMAPEXT]
    tab_scenes     = @tabPanel_main.panels[TAB_SCENES]
    tab_position   = @tabPanel_main.panels[TAB_POSITION]
    tab_movement   = @tabPanel_main.panels[TAB_MOVEMENT]
    camera = $cameras_json[$camera_idx][CAMERA_JSON]
    #Camera Name
    before_camera_name = $cameras_json[$camera_idx][CAMERA_NAME]
    after_camera_name = tab_general.edit_camera_name.text.gsub(/[\\\/:\*\?"<>\|]/,'').gsub(/[^ -~]/,'').strip
    unless before_camera_name == after_camera_name
      $cameras_json[$camera_idx][CAMERA_NAME] = after_camera_name
      camera_list_refresh = true
    end
    #Camera Type
    type = tab_general.comboBox_camera_type.getTextOf(tab_general.comboBox_camera_type.selectedString)
    unless camera["type"] == type
      camera["type"] = type
      camera_list_refresh = true
    end
    camera["FOV"] = tab_general.edit_field_of_view.text.to_f
    camera["FPSLimiter"] = {} unless camera["FPSLimiter"]
    camera["FPSLimiter"]["fpsLimit"] = tab_general.edit_fps_limit.text.to_i
    camera["renderScale"] = tab_general.edit_render_scale.text.to_f
    camera["antiAliasing"] = tab_general.comboBox_anti_aliasing.getTextOf(tab_general.comboBox_anti_aliasing.selectedString).to_i
    camera["visibleObjects"] = {} unless camera["visibleObjects"]
    camera["visibleObjects"]["Walls"] = tab_visibility.comboBox_walls.getTextOf(tab_visibility.comboBox_walls.selectedString)
    camera["visibleObjects"]["Notes"] = tab_visibility.comboBox_notes.getTextOf(tab_visibility.comboBox_notes.selectedString)
    camera["visibleObjects"]["Debris"] = tab_visibility.checkBox_debris.checked?
    camera["visibleObjects"]["CutParticles"] = tab_visibility.checkBox_cut_particles.checked?
    camera["visibleObjects"]["Avatar"] = tab_visibility.checkBox_avatar.checked?
    camera["visibleObjects"]["UI"] = tab_visibility.checkBox_UI.checked?
    camera["visibleObjects"]["Floor"] = tab_visibility.checkBox_floor.checked?
    camera["targetPos"] = {} unless camera["targetPos"]
    camera["targetRot"] = {} unless camera["targetRot"]
    camera["ModmapExtensions"] = {} unless camera["ModmapExtensions"]
    camera["ModmapExtensions"]["autoOpaqueWalls"] = tab_modmapext.checkBox_auto_visible_walls.checked?
    camera["ModmapExtensions"]["autoHideHUD"] = tab_modmapext.checkBox_auto_hide_HUD.checked?
    camera["viewRect"] = {} unless camera["viewRect"]
    camera["viewRect"]["x"] = tab_position.edit_view_rect_x.text.to_f
    camera["viewRect"]["y"] = tab_position.edit_view_rect_y.text.to_f
    camera["viewRect"]["width"] = tab_position.edit_view_rect_width.text.to_f
    camera["viewRect"]["height"] = tab_position.edit_view_rect_height.text.to_f
    if $camera_type == TYPE_FIRSTPERSON
      camera.delete("worldCamVisibility")
      camera.delete("previewScreenSize")
      camera.delete("Follow360")
      camera["Smoothfollow"] = {} unless camera["Smoothfollow"]
      camera["Smoothfollow"]["forceUpright"] = tab_follow.checkBox_force_upright.checked?
      camera["Smoothfollow"]["followReplayPosition"] = tab_follow.checkBox_follow_replay_position.checked?
      camera["Smoothfollow"]["pivotingOffset"] = tab_follow.checkBox_pivoting_offset.checked?
      camera["Smoothfollow"]["position"] = tab_follow.edit_position_smoothing.text.to_f
      camera["Smoothfollow"]["rotation"] = tab_follow.edit_rotation_smoothing.text.to_f
      camera["ModmapExtensions"].delete("moveWithMap")
      camera["targetPos"]["x"] = 0.0
      camera["targetPos"]["y"] = 0.0
      camera["targetPos"]["z"] = tab_general.edit_z_offset.text.to_f
      camera["targetRot"]["x"] = 0.0
      camera["targetRot"]["y"] = 0.0
      camera["targetRot"]["z"] = 0.0
      camera.delete("MovementScript")
    elsif $camera_type == TYPE_POSITIONABLE
      worldcam_idx = tab_general.comboBox_worldcam_visibility.selectedString
      camera["worldCamVisibility"] = tab_general.comboBox_worldcam_visibility.getTextOf(worldcam_idx) if worldcam_idx > -1
      camera["previewScreenSize"] = tab_general.edit_preview_size.text.to_f
      camera.delete("Smoothfollow")
      camera["Follow360"] = {} unless camera["Follow360"]
      camera["Follow360"]["enabled"] = tab_follow.checkBox_enabled.checked?
      camera["Follow360"]["smoothing"] = tab_follow.edit_rotation_smoothing.text.to_f
      camera["ModmapExtensions"]["moveWithMap"] = tab_modmapext.checkBox_move_with_map.checked?
      camera["targetPos"]["x"] = tab_position.edit_target_pos_x.text.to_f
      camera["targetPos"]["y"] = tab_position.edit_target_pos_y.text.to_f
      camera["targetPos"]["z"] = tab_position.edit_target_pos_z.text.to_f
      camera["targetRot"]["x"] = tab_position.edit_target_rot_x.text.to_f
      camera["targetRot"]["y"] = tab_position.edit_target_rot_y.text.to_f
      camera["targetRot"]["z"] = tab_position.edit_target_rot_z.text.to_f
      camera["MovementScript"] = {} unless camera["MovementScript"]
      scriptList = []
      tab_movement.listBox_script_list.countStrings.times do |idx|
        unless tab_movement.listBox_script_list.sendMessage(WMsg::LB_GETSEL,idx,0) == 0
          scriptList.push "#{tab_movement.listBox_script_list.getTextOf(idx)}.json"
        end
      end
      camera["MovementScript"]["scriptList"] = scriptList
      camera["MovementScript"]["fromOrigin"] = tab_movement.checkBox_from_origin.checked?
      camera["MovementScript"]["enableInMenu"] = tab_movement.checkBox_enable_in_menu.checked?
    end
    scenes_json_set("Menu", tab_scenes.checkBox_menu.checked?, before_camera_name, after_camera_name)
    scenes_json_set("MultiplayerMenu", tab_scenes.checkBox_multiplayer_menu.checked?, before_camera_name, after_camera_name)
    scenes_json_set("Playing", tab_scenes.checkBox_playing.checked?, before_camera_name, after_camera_name)
    scenes_json_set("Playing360", tab_scenes.checkBox_playing_360.checked?, before_camera_name, after_camera_name)
    scenes_json_set("PlayingModmap", tab_scenes.checkBox_playing_modmap.checked?, before_camera_name, after_camera_name)
    scenes_json_set("PlayingMulti", tab_scenes.checkBox_playing_multi.checked?, before_camera_name, after_camera_name)
    scenes_json_set("Replay", tab_scenes.checkBox_replay.checked?, before_camera_name, after_camera_name)
    scenes_json_set("FPFC", tab_scenes.checkBox_fpfc.checked?, before_camera_name, after_camera_name)
    scenes_json_set("Custom1", tab_scenes.checkBox_custom1.checked?, before_camera_name, after_camera_name)
    scenes_json_set("Custom2", tab_scenes.checkBox_custom2.checked?, before_camera_name, after_camera_name)
    scenes_json_set("Custom3", tab_scenes.checkBox_custom3.checked?, before_camera_name, after_camera_name)
    return camera_list_refresh
  end

end
