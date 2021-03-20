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
        @trackBar_fps_limit.rangeMin = 0
        @trackBar_fps_limit.rangeMax = 2400
        @trackBar_fps_limit.linesize = 10
        @trackBar_fps_limit.pagesize = 100
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
        addEvent WMsg::WM_HSCROLL
      end

      def control_set
        @edit_camera_name.text = $cameras_name[$camera_idx]
        type = $cameras_json[$camera_idx]["type"]
        @comboBox_camera_type.select(@comboBox_camera_type.findString(type))
        if type == COMBO_CAMERA_TYPE[0]
          $camera_type = 0
        elsif type == COMBO_CAMERA_TYPE[1]
          $camera_type = 1
        else
          $camera_type = nil
          messageBox("'#{type}' : #{UNKNOWN_CAMERA_TYPE_MES}", UNKNOWN_CAMERA_TYPE_TITLE, WConst::MB_ICONWARNING | WConst::MB_OK)
        end
        comboBox_camera_type_selchanged
        @edit_field_of_view.text = $cameras_json[$camera_idx]["FOV"]
        edit_field_of_view_changed
        if fpslimit = $cameras_json[$camera_idx]["FPSLimiter"]
          @edit_fps_limit.text = fpslimit["fpsLimit"]
          edit_fps_limit_changed
        end
        @edit_render_scale.text = $cameras_json[$camera_idx]["renderScale"]
        edit_render_scale_changed
        @comboBox_anti_aliasing.select(@comboBox_anti_aliasing.findString($cameras_json[$camera_idx]["antiAliasing"].to_s))
        if $camera_type == 0
          #FirstPerson
          if zoffset = $cameras_json[$camera_idx]["targetPos"]
            @edit_z_offset.text = zoffset["z"]
          end
          @comboBox_worldcam_visibility.select(-1)
          @edit_preview_size.text = ""
        elsif $camera_type == 1
          #Positionable
          @edit_z_offset.text = ""
          @comboBox_worldcam_visibility.select(@comboBox_worldcam_visibility.findString($cameras_json[$camera_idx]["worldCamVisibility"]))
          @edit_preview_size.text = $cameras_json[$camera_idx]["previewScreenSize"]
        end
        edit_preview_size_changed
        edit_z_offset_changed
      end

      def msghandler(msg)
        super
        edit_set if msg.msg == WMsg::WM_HSCROLL
      end

      def view_set
        if $camera_type == 0
          #FirstPerson
          @static_warldcam_visibiity.style |= 0x08000000
          @comboBox_worldcam_visibility.style |= 0x08000000
          @static_preview_size.style |= 0x08000000
          @edit_preview_size.readonly = true
          @trackBar_preview_size.style |= 0x08000000
          @static_z_offset.style &= ~0x08000000
          @edit_z_offset.readonly = false
          @trackBar_z_offset.style &= ~0x08000000
        elsif $camera_type == 1
          #Positionable
          @static_warldcam_visibiity.style &= ~0x08000000
          @comboBox_worldcam_visibility.style &= ~0x08000000
          @static_preview_size.style &= ~0x08000000
          @edit_preview_size.readonly = false
          @trackBar_preview_size.style &= ~0x08000000
          @static_z_offset.style |= 0x08000000
          @edit_z_offset.readonly = true
          @trackBar_z_offset.style |= 0x08000000
        end
        refresh
      end


    end                                                             ##__BY_FDVR

    class Panel1                                                    ##__BY_FDVR
      #VISIBILITY

      def self_created
        @comboBox_walls.setListStrings(COMBO_WALL_VISIBLITY)
        @comboBox_notes.setListStrings(COMBO_NOTE_VISIBILITY)
      end

      def control_set
        if visible = $cameras_json[$camera_idx]["visibleObjects"]
          @comboBox_walls.select(@comboBox_walls.findString(visible["Walls"]))
          @comboBox_notes.select(@comboBox_notes.findString(visible["Notes"]))
          @checkBox_debris.check(visible["Debris"])
          @checkBox_cut_particles.check(visible["CutParticles"])
          @checkBox_avatar.check(visible["Avatar"])
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

      def control_set
        if $camera_type == 0
          #FirstPerson
          if follow = $cameras_json[$camera_idx]["Smoothfollow"]
            @checkBox_force_upright.check(follow["forceUpright"])
            @checkBox_follow_replay_position.check(follow["followReplayPosition"])
            @checkBox_pivoting_offset.check(follow["pivotingOffset"])
            @edit_position_smoothing.text = follow["position"].to_s
            @edit_rotation_smoothing.text = follow["rotation"].to_s
            @checkBox_enabled.check(false)
          end
        elsif $camera_type == 1
          #Positionable
          if follow = $cameras_json[$camera_idx]["Follow360"]
            @checkBox_force_upright.check(false)
            @checkBox_follow_replay_position.check(false)
            @checkBox_pivoting_offset.check(false)
            @edit_position_smoothing.text = ""
            @checkBox_enabled.check(follow["enabled"])
            @edit_rotation_smoothing.text = follow["smoothing"].to_s
          end
        end
        edit_position_smoothing_changed
        edit_rotation_smoothing_changed
        view_set
      end

      def msghandler(msg)
        super
        edit_set if msg.msg == WMsg::WM_HSCROLL
      end

      def view_set
        if $camera_type == 0
          #FirstPerson
          @static_smoothfollow.style &= ~0x08000000
          @checkBox_force_upright.style &= ~0x08000000
          @checkBox_pivoting_offset.style &= ~0x08000000
          @checkBox_follow_replay_position.style &= ~0x08000000
          @static_position_smoothing.style &= ~0x08000000
          @edit_position_smoothing.readonly = false
          @trackBar_position_smoothing.style &= ~0x08000000
          @static_follow360.style |= 0x08000000
          @checkBox_enabled.style |= 0x08000000
        elsif $camera_type == 1
          #Positionable
          @static_smoothfollow.style |= 0x08000000
          @checkBox_force_upright.style |= 0x08000000
          @checkBox_pivoting_offset.style |= 0x08000000
          @checkBox_follow_replay_position.style |= 0x08000000
          @static_position_smoothing.style |= 0x08000000
          @edit_position_smoothing.readonly = true
          @trackBar_position_smoothing.style |= 0x08000000
          @static_follow360.style &= ~0x08000000
          @checkBox_enabled.style &= ~0x08000000
        end
        refresh
      end

    end                                                             ##__BY_FDVR

    class Panel3                                                    ##__BY_FDVR
      #MODMAPEXT
      def control_set
        if extensions = $cameras_json[$camera_idx]["ModmapExtensions"]
          if $camera_type == 1
            @checkBox_move_with_map.check(extensions["moveWithMap"])
          else
            @checkBox_move_with_map.check(false)
          end
          @checkBox_auto_visible_walls.check(extensions["autoOpaqueWalls"])
          @checkBox_auto_hide_HUD.check(extensions["autoHideHUD"])
        end
        view_set
      end

      def view_set
        if $camera_type == 0
          #FirstPerson
          @checkBox_move_with_map.style |= 0x08000000
        elsif $camera_type == 1
          #Positionable
          @checkBox_move_with_map.style &= ~0x08000000
        end
        refresh
      end
    end                                                             ##__BY_FDVR

    class Panel4                                                    ##__BY_FDVR
      #SCENES

    end                                                             ##__BY_FDVR

    class Panel5                                                    ##__BY_FDVR
      #POSITION

    end                                                             ##__BY_FDVR

    class Panel6                                                    ##__BY_FDVR
      #MOVEMENT

      def movement_list_set
        if $movement_json == []
          @listBox_script_list.clearStrings
        else
          @listBox_script_list.setListStrings($movement_json)
        end
      end
    
    end                                                             ##__BY_FDVR

  end                                                               ##__BY_FDVR
  
end                                                                 ##__BY_FDVR
