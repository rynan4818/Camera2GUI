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

  class TabPanel_main                                               ##__BY_FDVR

    class Panel0                                                    ##__BY_FDVR
      #GENERAL
      def self_created
        @comboBox_camera_type.setListStrings(COMBO_CAMERA_TYPE)
        @comboBox_worldcam_visibility.setListStrings(COMBO_WORLD_CAMVISIBILITY)
        @comboBox_anti_aliasing.setListStrings(COMBO_ANTI_ALIASING)
        @trackBar_field_of_view.rangeMin = 10
        @trackBar_field_of_view.rangeMax = 1400
        @trackBar_field_of_view.linesize = 5
        @trackBar_field_of_view.pagesize = 50
        @trackBar_render_scale.rangeMin = 2
        @trackBar_render_scale.rangeMax = 30
        @trackBar_render_scale.linesize = 1
        @trackBar_render_scale.pagesize = 5
        @trackBar_preview_size.rangeMin = 3
        @trackBar_preview_size.rangeMax = 30
        @trackBar_preview_size.linesize = 1
        @trackBar_preview_size.pagesize = 5
        @trackBar_z_offset.rangeMin = -20
        @trackBar_z_offset.rangeMax = 5
        @trackBar_z_offset.linesize = 1
        @trackBar_z_offset.pagesize = 5
        @camera_name_check = false
        addEvent WMsg::WM_HSCROLL
      end
      
      def main_created
        if $tooltip_enabled
          $main_form.tooltip.addTool(@edit_camera_name, TOOLTIP_CAMERA_NAME)
          $main_form.tooltip.addTool(@comboBox_camera_type, TOOLTIP_CAMERA_TYPE)
          $main_form.tooltip.addTool(@edit_field_of_view, TOOLTIP_FIELD_OF_VIEW)
          $main_form.tooltip.addTool(@trackBar_field_of_view, TOOLTIP_FIELD_OF_VIEW)
          $main_form.tooltip.addTool(@edit_render_scale, TOOLTIP_RENDER_SCALE)
          $main_form.tooltip.addTool(@trackBar_render_scale, TOOLTIP_RENDER_SCALE)
          $main_form.tooltip.addTool(@comboBox_anti_aliasing, TOOLTIP_ANTI_ALIASING)
          $main_form.tooltip.addTool(@comboBox_worldcam_visibility, TOOLTIP_WORLDCAM_VISIBILITY)
          $main_form.tooltip.addTool(@edit_preview_size, TOOLTIP_PREVIEW_SIZE)
          $main_form.tooltip.addTool(@trackBar_preview_size, TOOLTIP_PREVIEW_SIZE)
          $main_form.tooltip.addTool(@edit_z_offset, TOOLTIP_Z_OFFSET)
          $main_form.tooltip.addTool(@trackBar_z_offset, TOOLTIP_Z_OFFSET)
          $main_form.tooltip.addTool(@edit_x_rotation_offset, TOOLTIP_X_ROTATION_OFFSET)
          $main_form.tooltip.addTool(@trackBar_x_rotation_offset, TOOLTIP_X_ROTATION_OFFSET)
          $main_form.tooltip.addTool(@checkBox_pivoting_offset, TOOLTIP_PIVOTING_OFFSET)
          $main_form.tooltip.addTool(@checkBox_lock_screen, TOOLTIP_LOCK_SCREEN)
        end
      end

      def control_set
        @edit_camera_name.text = $cameras_json[$camera_idx][CAMERA_NAME]
        type = $cameras_json[$camera_idx][CAMERA_JSON]["type"]
        @comboBox_camera_type.select(@comboBox_camera_type.findString(type))
        if type == COMBO_CAMERA_TYPE[TYPE_FIRSTPERSON]
          $camera_type = TYPE_FIRSTPERSON
        elsif type == COMBO_CAMERA_TYPE[TYPE_POSITIONABLE]
          $camera_type = TYPE_POSITIONABLE
        else
          $camera_type = nil
          messageBox("'#{type}' : #{UNKNOWN_CAMERA_TYPE_MES}", UNKNOWN_CAMERA_TYPE_TITLE, WConst::MB_ICONWARNING | WConst::MB_OK)
        end
        comboBox_camera_type_selchanged
        @edit_field_of_view.text = "%.15g"%$cameras_json[$camera_idx][CAMERA_JSON]["FOV"]
        edit_field_of_view_changed
        @edit_render_scale.text = "%.15g"%$cameras_json[$camera_idx][CAMERA_JSON]["renderScale"]
        edit_render_scale_changed
        @comboBox_anti_aliasing.select(@comboBox_anti_aliasing.findString($cameras_json[$camera_idx][CAMERA_JSON]["antiAliasing"].to_s))
        if $camera_type == TYPE_FIRSTPERSON
          if zoffset = $cameras_json[$camera_idx][CAMERA_JSON]["targetPos"]
            @edit_z_offset.text = "%.15g"%zoffset["z"]
          end
          @comboBox_worldcam_visibility.select(-1)
          @edit_preview_size.text = ""
          @checkBox_pivoting_offset.check(follow["pivotingOffset"])
        elsif $camera_type == TYPE_POSITIONABLE
          @edit_z_offset.text = ""
          @comboBox_worldcam_visibility.select(@comboBox_worldcam_visibility.findString($cameras_json[$camera_idx][CAMERA_JSON]["worldCamVisibility"]))
          @edit_preview_size.text = $cameras_json[$camera_idx][CAMERA_JSON]["previewScreenSize"]
          @checkBox_pivoting_offset.check(false)
        end
        edit_preview_size_changed
        edit_z_offset_changed
      end

      def msghandler(msg)
        super
        edit_set if msg.msg == WMsg::WM_HSCROLL
      end

      def view_set
        firstperson_control = [@static_z_offset, @edit_z_offset, @trackBar_z_offset, @checkBox_pivoting_offset]
        positionable_control = [@static_warldcam_visibiity, @comboBox_worldcam_visibility, @static_preview_size,
                                @edit_preview_size, @trackBar_preview_size]
        if $camera_type == TYPE_FIRSTPERSON
          control_disable(positionable_control, false)
          control_enable(firstperson_control)
          edit_z_offset_changed
        elsif $camera_type == TYPE_POSITIONABLE
          if @comboBox_worldcam_visibility.selectedString == -1
            @comboBox_worldcam_visibility.select(@comboBox_worldcam_visibility.findString($positionable_default["worldCamVisibility"]))
          end
          control_disable(firstperson_control, false)
          control_enable(positionable_control)
          edit_preview_size_changed
        end
      end
    end                                                             ##__BY_FDVR

    class Panel1                                                    ##__BY_FDVR
      #VISIBILITY
      def self_created
        @comboBox_walls.setListStrings(COMBO_WALL_VISIBLITY)
        @comboBox_notes.setListStrings(COMBO_NOTE_VISIBILITY)
        @comboBox_avatar.setListStrings(COMBO_AVATAR_VISIBILITY)
      end

      def main_created
        if $tooltip_enabled
          $main_form.tooltip.addTool(@comboBox_walls, TOOLTIP_WALLS)
          $main_form.tooltip.addTool(@comboBox_notes, TOOLTIP_NOTES)
          $main_form.tooltip.addTool(@comboBox_avatar, TOOLTIP_AVATAR)
          $main_form.tooltip.addTool(@checkBox_debris, TOOLTIP_DEBRIS)
          $main_form.tooltip.addTool(@checkBox_cut_particles, TOOLTIP_CUT_PARTICLES)
          $main_form.tooltip.addTool(@checkBox_UI, TOOLTIP_UI)
          $main_form.tooltip.addTool(@checkBox_floor, TOOLTIP_FLOOR)
        end
      end

      def control_set
        if visible = $cameras_json[$camera_idx][CAMERA_JSON]["visibleObjects"]
          @comboBox_walls.select(@comboBox_walls.findString(visible["Walls"]))
          @comboBox_notes.select(@comboBox_notes.findString(visible["Notes"]))
          @comboBox_avatar.select(@comboBox_avatar.findString(visible["Avatar"]))
          @checkBox_debris.check(visible["Debris"])
          @checkBox_cut_particles.check(visible["CutParticles"])
          @checkBox_UI.check(visible["UI"])
          @checkBox_floor.check(visible["Floor"])
        end
      end
    end                                                             ##__BY_FDVR

    class Panel2                                                    ##__BY_FDVR
      #FOLLOW
      def self_created
        @trackBar_position_smoothing.rangeMin = 1
        @trackBar_position_smoothing.rangeMax = 500
        @trackBar_position_smoothing.linesize = 1
        @trackBar_position_smoothing.pagesize = 10
        @trackBar_rotation_smoothing.rangeMin = 1
        @trackBar_rotation_smoothing.rangeMax = 500
        @trackBar_rotation_smoothing.linesize = 1
        @trackBar_rotation_smoothing.pagesize = 10
        addEvent WMsg::WM_HSCROLL
      end

      def main_created
        if $tooltip_enabled
          $main_form.tooltip.addTool(@checkBox_force_upright, TOOLTIP_FORCE_UPRIGHT)
          $main_form.tooltip.addTool(@checkBox_follow_replay_position, TOOLTIP_FOLLOW_REPLAY_POSITION)
          $main_form.tooltip.addTool(@edit_position_smoothing, TOOLTIP_POSITION_SMOOTHING)
          $main_form.tooltip.addTool(@trackBar_position_smoothing, TOOLTIP_POSITION_SMOOTHING)
          $main_form.tooltip.addTool(@checkBox_enabled, TOOLTIP_360ENABLED)
          $main_form.tooltip.addTool(@edit_rotation_smoothing, TOOLTIP_ROTATION_SMOOTHING)
          $main_form.tooltip.addTool(@trackBar_rotation_smoothing, TOOLTIP_ROTATION_SMOOTHING)
        end
      end

      def control_set
        view_set
        if $camera_type == TYPE_FIRSTPERSON
          if follow = $cameras_json[$camera_idx][CAMERA_JSON]["Smoothfollow"]
            @checkBox_force_upright.check(follow["forceUpright"])
            @checkBox_follow_replay_position.check(follow["followReplayPosition"])
            @edit_position_smoothing.text = "%.15g"%follow["position"]
            @edit_rotation_smoothing.text = "%.15g"%follow["rotation"]
            @checkBox_enabled.check(false)
          end
        elsif $camera_type == TYPE_POSITIONABLE
          if follow = $cameras_json[$camera_idx][CAMERA_JSON]["Follow360"]
            @checkBox_force_upright.check(false)
            @checkBox_follow_replay_position.check(false)
            @edit_position_smoothing.text = ""
            @checkBox_enabled.check(follow["enabled"])
            @edit_rotation_smoothing.text = "%.15g"%follow["smoothing"]
          end
        end
        edit_position_smoothing_changed
        edit_rotation_smoothing_changed
      end

      def msghandler(msg)
        super
        edit_set if msg.msg == WMsg::WM_HSCROLL
      end

      def view_set
        firstperson_control = [@static_smoothfollow, @checkBox_force_upright, @checkBox_follow_replay_position,
          @static_position_smoothing, @edit_position_smoothing, @trackBar_position_smoothing]
        positionable_control = [@static_follow360, @checkBox_enabled]
        if $camera_type == TYPE_FIRSTPERSON
          control_disable(positionable_control, false)
          control_enable(firstperson_control)
          edit_position_smoothing_changed
          edit_rotation_smoothing_changed
        elsif $camera_type == TYPE_POSITIONABLE
          control_disable(firstperson_control, false)
          control_enable(positionable_control)
          edit_rotation_smoothing_changed
        end
      end
    end                                                             ##__BY_FDVR

    class Panel3                                                    ##__BY_FDVR
      #MODMAPEXT
      def main_created
        if $tooltip_enabled
          $main_form.tooltip.addTool(@checkBox_move_with_map, TOOLTIP_MOVE_WITH_MAP)
          $main_form.tooltip.addTool(@checkBox_auto_visible_walls, TOOLTIP_AUTO_VISIBLE_WALLS)
          $main_form.tooltip.addTool(@checkBox_auto_hide_HUD, TOOLTIP_AUTO_HIDE_HUD)
        end
      end
      
      def control_set
        view_set
        if extensions = $cameras_json[$camera_idx][CAMERA_JSON]["ModmapExtensions"]
          if $camera_type == TYPE_FIRSTPERSON
            @checkBox_move_with_map.check(false)
          elsif $camera_type == TYPE_POSITIONABLE
            @checkBox_move_with_map.check(extensions["moveWithMap"])
          end
          @checkBox_auto_visible_walls.check(extensions["autoOpaqueWalls"])
          @checkBox_auto_hide_HUD.check(extensions["autoHideHUD"])
        end
      end

      def view_set
        if $camera_type == TYPE_FIRSTPERSON
          @checkBox_move_with_map.style |= WStyle::WS_DISABLED
        elsif $camera_type == TYPE_POSITIONABLE
          @checkBox_move_with_map.style &= ~WStyle::WS_DISABLED
        end
        refresh
      end
    end                                                             ##__BY_FDVR

    class Panel4                                                    ##__BY_FDVR
      #SCENES
      def main_created
        if $tooltip_enabled
          $main_form.tooltip.addTool(@checkBox_menu, TOOLTIP_SCENE_MENU)
          $main_form.tooltip.addTool(@checkBox_multiplayer_menu, TOOLTIP_SCENE_MULTIPLAYER_MENU)
          $main_form.tooltip.addTool(@checkBox_playing, TOOLTIP_SCENE_PLAYING)
          $main_form.tooltip.addTool(@checkBox_playing_360, TOOLTIP_SCENE_PLAYING_360)
          $main_form.tooltip.addTool(@checkBox_playing_modmap, TOOLTIP_SCENE_PLAYING_MODMAP)
          $main_form.tooltip.addTool(@checkBox_playing_multi, TOOLTIP_SCENE_PLAYING_MULTI)
          $main_form.tooltip.addTool(@checkBox_replay, TOOLTIP_SCENE_REPLAY)
          $main_form.tooltip.addTool(@checkBox_fpfc, TOOLTIP_SCENE_FPFC)
          $main_form.tooltip.addTool(@checkBox_spectating_multi, TOOLTIP_SCENE_SPECTATING_MULTI)
          $main_form.tooltip.addTool(@checkBox_autoswitch_from_custom, TOOLTIP_AUTOSWITCH_FROM_CUSTOM)
          $main_form.tooltip.addTool(@button_custom_scenes, TOOLTIP_CUSTOM_SCENES)
        end
      end

      def control_set
        @checkBox_menu.check(false)
        @checkBox_multiplayer_menu.check(false)
        @checkBox_playing.check(false)
        @checkBox_playing_360.check(false)
        @checkBox_playing_modmap.check(false)
        @checkBox_playing_multi.check(false)
        @checkBox_replay.check(false)
        @checkBox_fpfc.check(false)
        @checkBox_spectating_multi.check(false)
        @checkBox_autoswitch_from_custom.check(false)
        if scenes = $scene_json["scenes"]
          camera_name = $cameras_json[$camera_idx][CAMERA_NAME]
          scenes.each do |scene, cameras|
            @checkBox_menu.check(true) if scene == "Menu" && cameras.index(camera_name)
            @checkBox_multiplayer_menu.check(true) if scene == "MultiplayerMenu" && cameras.index(camera_name)
            @checkBox_playing.check(true) if scene == "Playing" && cameras.index(camera_name)
            @checkBox_playing_360.check(true) if scene == "Playing360" && cameras.index(camera_name)
            @checkBox_playing_modmap.check(true) if scene == "PlayingModmap" && cameras.index(camera_name)
            @checkBox_playing_multi.check(true) if scene == "PlayingMulti" && cameras.index(camera_name)
            @checkBox_replay.check(true) if scene == "Replay" && cameras.index(camera_name)
            @checkBox_fpfc.check(true) if scene == "FPFC" && cameras.index(camera_name)
            @checkBox_spectating_multi.check(true) if scene == "SpectatingMulti" && cameras.index(camera_name)
          end
        end
        @checkBox_autoswitch_from_custom.check(true) if $scene_json["autoswitchFromCustom"]
      end

    end                                                             ##__BY_FDVR

    class Panel5                                                    ##__BY_FDVR
      #LAYOUT
      def self_created
        @panel_target_rot.radioBtn_target_rot1.check(true) unless $rot_amount
        @panel_view_rect.radioBtn_view_rect1.check(true) unless $view_amount
        @change_pos_ok = true
        @change_rot_ok = true
        @change_view_ok = true
        $apply_ok = true
        @trackBar_pos_amount.rangeMin = 0
        @trackBar_pos_amount.rangeMax = 22
        @trackBar_pos_amount.linesize = 1
        @trackBar_pos_amount.pagesize = 4
        @panel_view_rect.radioBtn_view_rect1.check(true) if @panel_view_rect.radioBtn_view_rect1.caption.to_i == $view_amount
        @panel_view_rect.radioBtn_view_rect2.check(true) if @panel_view_rect.radioBtn_view_rect2.caption.to_i == $view_amount
        @panel_view_rect.radioBtn_view_rect3.check(true) if @panel_view_rect.radioBtn_view_rect3.caption.to_i == $view_amount
        @panel_view_rect.radioBtn_view_rect4.check(true) if @panel_view_rect.radioBtn_view_rect4.caption.to_i == $view_amount
        @panel_target_rot.radioBtn_target_rot1.check(true) if @panel_target_rot.radioBtn_target_rot1.caption.to_f == $rot_amount
        @panel_target_rot.radioBtn_target_rot2.check(true) if @panel_target_rot.radioBtn_target_rot2.caption.to_f == $rot_amount
        @panel_target_rot.radioBtn_target_rot3.check(true) if @panel_target_rot.radioBtn_target_rot3.caption.to_f == $rot_amount
        @panel_target_rot.radioBtn_target_rot4.check(true) if @panel_target_rot.radioBtn_target_rot4.caption.to_f == $rot_amount
        @panel_target_rot.radioBtn_target_rot5.check(true) if @panel_target_rot.radioBtn_target_rot5.caption.to_f == $rot_amount
        @panel_target_rot.radioBtn_target_rot6.check(true) if @panel_target_rot.radioBtn_target_rot6.caption.to_f == $rot_amount
        addEvent WMsg::WM_HSCROLL
      end

      def main_created
        if $tooltip_enabled
          $main_form.tooltip.addTool(@checkBox_auto_apply, TOOLTIP_AUTO_APPLY)
          $main_form.tooltip.addTool(@button_reset, TOOLTIP_RESET)
          $main_form.tooltip.addTool(@edit_pos_amount, TOOLTIP_POS_AMOUNT)
          $main_form.tooltip.addTool(@trackBar_pos_amount, TOOLTIP_POS_AMOUNT)
          $main_form.tooltip.addTool(@panel_target_rot.radioBtn_target_rot1, TOOLTIP_ROT_AMOUNT)
          $main_form.tooltip.addTool(@panel_target_rot.radioBtn_target_rot2, TOOLTIP_ROT_AMOUNT)
          $main_form.tooltip.addTool(@panel_target_rot.radioBtn_target_rot3, TOOLTIP_ROT_AMOUNT)
          $main_form.tooltip.addTool(@panel_target_rot.radioBtn_target_rot4, TOOLTIP_ROT_AMOUNT)
          $main_form.tooltip.addTool(@panel_target_rot.radioBtn_target_rot5, TOOLTIP_ROT_AMOUNT)
          $main_form.tooltip.addTool(@panel_target_rot.radioBtn_target_rot6, TOOLTIP_ROT_AMOUNT)
          $main_form.tooltip.addTool(@panel_target_rot.radioBtn_target_rot1, TOOLTIP_ROT_AMOUNT)
          $main_form.tooltip.addTool(@panel_view_rect.radioBtn_view_rect1, TOOLTIP_VIEW_AMOUNT)
          $main_form.tooltip.addTool(@panel_view_rect.radioBtn_view_rect2, TOOLTIP_VIEW_AMOUNT)
          $main_form.tooltip.addTool(@panel_view_rect.radioBtn_view_rect3, TOOLTIP_VIEW_AMOUNT)
          $main_form.tooltip.addTool(@panel_view_rect.radioBtn_view_rect4, TOOLTIP_VIEW_AMOUNT)
        end
      end

      def control_set
        $apply_ok = false
        @edit_view_rect_x.text = ""
        @edit_view_rect_y.text = ""
        @edit_view_rect_width.text = ""
        @edit_view_rect_height.text = ""
        @edit_target_pos_x.text = ""
        @edit_target_pos_y.text = ""
        @edit_target_pos_z.text = ""
        @edit_target_rot_x.text = ""
        @edit_target_rot_y.text = ""
        @edit_target_rot_z.text = ""
        @checkBox_view_rect_full.check(false)
        if view = $cameras_json[$camera_idx][CAMERA_JSON]["viewRect"]
          if view["x"] == 0.0 && view["y"] == 0.0 && view["width"] == -1.0 && view["height"] == -1.0
            @checkBox_view_rect_full.check(true)
            @view_x_backup = "0"
            @view_y_backup = "0"
            @view_width_backup = "640"
            @view_height_backup = "380"
          else
            @checkBox_view_rect_full.check(false)
            @view_x_backup = view["x"]
            @view_y_backup = view["y"]
            @view_width_backup = view["width"]
            @view_height_backup = view["height"]
            @edit_view_rect_x.text = view["x"]
            @edit_view_rect_y.text = view["y"]
            @edit_view_rect_width.text = view["width"]
            @edit_view_rect_height.text = view["height"]
          end
        end
        if $camera_type == TYPE_POSITIONABLE
          if pos = $cameras_json[$camera_idx][CAMERA_JSON]["targetPos"]
            @edit_target_pos_x.text = "%.15g"%pos["x"]
            @edit_target_pos_y.text = "%.15g"%pos["y"]
            @edit_target_pos_z.text = "%.15g"%pos["z"]
          end
          if rot = $cameras_json[$camera_idx][CAMERA_JSON]["targetRot"]
            @edit_target_rot_x.text = "%.15g"%rot["x"]
            @edit_target_rot_y.text = "%.15g"%rot["y"]
            @edit_target_rot_z.text = "%.15g"%rot["z"]
          end
        end
        @edit_pos_amount.text = $pos_amount
        view_set
        $apply_ok = true
      end

      def msghandler(msg)
        super
        amount_edit_set(0.01, 2, @trackBar_pos_amount.rangeMax) if msg.msg == WMsg::WM_HSCROLL
      end

      def view_set
        control_list = [@button_back, @button_down, @button_front, @button_left, @button_pitch_down, @button_pitch_up, @button_right,
          @button_roll_left, @button_roll_right, @button_target_pos_x_d, @button_target_pos_x_u, @button_target_pos_y_d,
          @button_target_pos_y_u, @button_target_pos_z_d, @button_target_pos_z_u, @button_target_rot_x_d, @button_target_rot_x_u,
          @button_target_rot_y_d, @button_target_rot_y_u, @button_target_rot_z_d, @button_target_rot_z_u, @button_up,@button_yaw_left,
          @button_yaw_right, @edit_target_pos_x, @edit_target_pos_y, @edit_target_pos_z, @edit_target_rot_x, @edit_target_rot_y,
          @edit_target_rot_z, @static_target_pos, @static_target_pos_x, @static_target_pos_y, @static_target_pos_z,
          @static_target_rot, @static_target_rot_x, @static_target_rot_y, @static_target_rot_z, @static_flying_control,
          @panel_target_rot.radioBtn_target_rot1, @panel_target_rot.radioBtn_target_rot2, @panel_target_rot.radioBtn_target_rot3, 
          @panel_target_rot.radioBtn_target_rot4, @panel_target_rot.radioBtn_target_rot5, @panel_target_rot.radioBtn_target_rot6,
          @static_pos_amount, @edit_pos_amount, @trackBar_pos_amount, @checkBox_auto_apply, @button_reset]
        if $camera_type == TYPE_FIRSTPERSON
          control_disable(control_list, false)
        elsif $camera_type == TYPE_POSITIONABLE
          control_enable(control_list, false)
        end
        checkBox_view_rect_full_clicked
      end

      def view_amount
        return @panel_view_rect.radioBtn_view_rect1.caption.to_i if @panel_view_rect.radioBtn_view_rect1.checked?
        return @panel_view_rect.radioBtn_view_rect2.caption.to_i if @panel_view_rect.radioBtn_view_rect2.checked?
        return @panel_view_rect.radioBtn_view_rect3.caption.to_i if @panel_view_rect.radioBtn_view_rect3.checked?
        return @panel_view_rect.radioBtn_view_rect4.caption.to_i if @panel_view_rect.radioBtn_view_rect4.checked?
      end

      def pos_amount
        return @edit_pos_amount.text.to_f
      end

      def rot_amount
        return @panel_target_rot.radioBtn_target_rot1.caption.to_f if @panel_target_rot.radioBtn_target_rot1.checked?
        return @panel_target_rot.radioBtn_target_rot2.caption.to_f if @panel_target_rot.radioBtn_target_rot2.checked?
        return @panel_target_rot.radioBtn_target_rot3.caption.to_f if @panel_target_rot.radioBtn_target_rot3.checked?
        return @panel_target_rot.radioBtn_target_rot4.caption.to_f if @panel_target_rot.radioBtn_target_rot4.checked?
        return @panel_target_rot.radioBtn_target_rot5.caption.to_f if @panel_target_rot.radioBtn_target_rot5.checked?
        return @panel_target_rot.radioBtn_target_rot6.caption.to_f if @panel_target_rot.radioBtn_target_rot6.checked?
      end
      
      def flying_move(x,y,z)
        px = @edit_target_pos_x.text.to_f
        py = @edit_target_pos_y.text.to_f
        pz = @edit_target_pos_z.text.to_f
        rx = @edit_target_rot_x.text.to_f
        ry = @edit_target_rot_y.text.to_f
        rz = @edit_target_rot_z.text.to_f
        r = rotation_matrix(rx, ry, rz)
        xx, yy, zz = rotation_cal(x, y, z ,r)
        @edit_target_pos_x.text = "%.15g"%(((px + xx) * POS_ROT_ROUND).round.to_f / POS_ROT_ROUND)
        @edit_target_pos_y.text = "%.15g"%(((py + yy) * POS_ROT_ROUND).round.to_f / POS_ROT_ROUND)
        @edit_target_pos_z.text = "%.15g"%(((pz + zz) * POS_ROT_ROUND).round.to_f / POS_ROT_ROUND)
      end
    end                                                             ##__BY_FDVR

    class Panel6                                                    ##__BY_FDVR
      #MOVEMENT
      def main_created
        if $tooltip_enabled
          $main_form.tooltip.addTool(@checkBox_from_origin, TOOLTIP_MOVEMENT_FROM_ORIGIN)
          $main_form.tooltip.addTool(@listBox_script_list, TOOLTIP_MOVEMENT_SCRIPT_LIST)
        end
      end
      
      def control_set
        view_set
        @checkBox_from_origin.check(false)
        if $camera_type == TYPE_POSITIONABLE
          if movement = $cameras_json[$camera_idx][CAMERA_JSON]["MovementScript"]
            @checkBox_from_origin.check(movement["fromOrigin"])
          end
        end
        if $movement_json == []
          @listBox_script_list.clearStrings
        else
          @listBox_script_list.setListStrings($movement_json)
          if movement = $cameras_json[$camera_idx][CAMERA_JSON]["MovementScript"]
            movement["scriptList"].each do |script|
              idx = @listBox_script_list.findString(script)
              if idx > -1
                @listBox_script_list.sendMessage(WMsg::LB_SETSEL, 1, idx)
              end
            end
          end
        end
      end

      def view_set
        positionable_control = [@checkBox_from_origin, @listBox_script_list, @static_movement_script]
        if $camera_type == TYPE_FIRSTPERSON
          control_disable(positionable_control)
        elsif $camera_type == TYPE_POSITIONABLE
          control_enable(positionable_control)
        end
      end
    
    end                                                             ##__BY_FDVR

    class Panel7                                                    ##__BY_FDVR
      #MISC
      def self_created
        @trackBar_fps_limit.rangeMin = 0
        @trackBar_fps_limit.rangeMax = 2400
        @trackBar_fps_limit.linesize = 10
        @trackBar_fps_limit.pagesize = 100
      end
      
      def main_created
        if $tooltip_enabled
          $main_form.tooltip.addTool(@checkBox_orthographic, TOOLTIP_ORTHOGRAPHIC)
          $main_form.tooltip.addTool(@checkBox_follow_spectator_plattform, TOOLTIP_FOLLOW_SPECTATOR_PLATTFORM)
          $main_form.tooltip.addTool(@checkBox_enable_in_menu, TOOLTIP_MOVEMENT_ENABLE_IN_MENU)
          $main_form.tooltip.addTool(@edit_far_z, TOOLTIP_FAR_Z)
          $main_form.tooltip.addTool(@edit_vmc_destination, TOOLTIP_VMC_DESTINATION)
          $main_form.tooltip.addTool(@comboBox_vmc_mode, TOOLTIP_VMC_MODE)
          $main_form.tooltip.addTool(@edit_fps_limit, TOOLTIP_FPS_LIMIT)
          $main_form.tooltip.addTool(@trackBar_fps_limit, TOOLTIP_FPS_LIMIT)
        end
      end
      
      def control_set
        view_set
        @checkBox_orthographic.check($cameras_json[$camera_idx][CAMERA_JSON]["orthographic"])
        if multiplayer = $cameras_json[$camera_idx][CAMERA_JSON]["Multiplayer"]
          @checkBox_follow_spectator_plattform.check(multiplayer["followSpectatorPlattform"])
        else
          @checkBox_follow_spectator_plattform.check(false)
        end
        @checkBox_enable_in_menu.check(false)
        if $camera_type == TYPE_POSITIONABLE
          if movement = $cameras_json[$camera_idx][CAMERA_JSON]["MovementScript"]
            @checkBox_enable_in_menu.check(movement["enableInMenu"])
          end
          if vmc_protocol = $cameras_json[$camera_idx][CAMERA_JSON]["VMCProtocol"]
            @edit_vmc_destination.text = vmc_protocol["destination"]
            @comboBox_vmc_mode.select(@comboBox_vmc_mode.findString(vmc_protocol["mode"].to_s))
          end
        else
          @edit_vmc_destination.text = ""
          @comboBox_vmc_mode.select(-1)
        end
        @edit_far_z.text = $cameras_json[$camera_idx][CAMERA_JSON]["farZ"]
        if fpslimit = $cameras_json[$camera_idx][CAMERA_JSON]["FPSLimiter"]
          @edit_fps_limit.text = "%.15g"%fpslimit["fpsLimit"]
          edit_fps_limit_changed
        end
      end
      
      def view_set
        positionable_control = [@checkBox_enable_in_menu, @edit_vmc_destination, @static_vmc_destination, @static_vmc_mode, @static_vmc_protocol, @comboBox_vmc_mode]
        if $camera_type == TYPE_FIRSTPERSON
          control_disable(positionable_control)
        elsif $camera_type == TYPE_POSITIONABLE
          control_enable(positionable_control)
        end
      end
      
    end

  end                                                               ##__BY_FDVR
  
end                                                                 ##__BY_FDVR
