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

      def comboBox_camera_type_selchanged
        return unless $camera_type
        if @comboBox_camera_type.getTextOf(@comboBox_camera_type.selectedString) == COMBO_CAMERA_TYPE[TYPE_FIRSTPERSON]
          $camera_type = TYPE_FIRSTPERSON
        elsif @comboBox_camera_type.getTextOf(@comboBox_camera_type.selectedString) == COMBO_CAMERA_TYPE[TYPE_POSITIONABLE]
          $camera_type = TYPE_POSITIONABLE
        end
        view_set
      end

      def edit_camera_name_changed
        return if @camera_name_check
        @camera_name_check = true
        if rename_text = character_check(self,/[\\\/:\*\?"<>\|]/,@edit_camera_name.text)
          @edit_camera_name.text = rename_text
        end
        if rename_text = character_check(self,/[^ -~]/,@edit_camera_name.text)
          @edit_camera_name.text = rename_text
        end
        @camera_name_check = false
      end
    
      def edit_field_of_view_changed
        trackbar_set(@edit_field_of_view, @trackBar_field_of_view, $firstperson_default["FOV"])
      end
    
      def edit_fps_limit_changed
        trackbar_set(@edit_fps_limit, @trackBar_fps_limit, $firstperson_default["FPSLimiter"]["fpsLimit"])
      end
    
      def edit_render_scale_changed
        trackbar_set(@edit_render_scale, @trackBar_render_scale, $firstperson_default["renderScale"])
      end
    
      def edit_preview_size_changed
        trackbar_set(@edit_preview_size, @trackBar_preview_size , $positionable_default["previewScreenSize"]) if $camera_type == TYPE_POSITIONABLE
      end
    
      def edit_z_offset_changed
        trackbar_set(@edit_z_offset, @trackBar_z_offset, $positionable_default["targetPos"]["z"]) if $camera_type == TYPE_FIRSTPERSON
      end
    
    end                                                             ##__BY_FDVR

    class Panel1                                                    ##__BY_FDVR
      #VISIBILITY
    
      def edit_camera_name_changed
      
      end
    
    end                                                             ##__BY_FDVR

    class Panel2                                                    ##__BY_FDVR
      #FOLLOW

      def edit_position_smoothing_changed
        trackbar_set(@edit_position_smoothing, @trackBar_position_smoothing, $firstperson_default["Smoothfollow"]["position"]) if $camera_type == TYPE_FIRSTPERSON
      end
    
      def edit_rotation_smoothing_changed
        if $camera_type == TYPE_FIRSTPERSON
          default = $firstperson_default["Smoothfollow"]["rotation"]
        elsif $camera_type == TYPE_POSITIONABLE
          default = $positionable_default["Follow360"]["smoothing"]
        end
        trackbar_set(@edit_rotation_smoothing, @trackBar_rotation_smoothing, default)
      end
    
        

    end                                                             ##__BY_FDVR

    class Panel3                                                    ##__BY_FDVR
      #MODMAPEXT

    end                                                             ##__BY_FDVR

    class Panel4                                                    ##__BY_FDVR
      #SCENES

    end                                                             ##__BY_FDVR

    class Panel5                                                    ##__BY_FDVR
      #POSITION

      def checkBox_view_rect_full_clicked
        control_list = [@edit_view_rect_x, @edit_view_rect_y, @edit_view_rect_width, @edit_view_rect_height,
                        @button_view_rect_x_u, @button_view_rect_x_d, @button_view_rect_y_u, @button_view_rect_y_d,
                        @button_view_rect_width_u, @button_view_rect_width_d, @button_view_rect_height_u, @button_view_rect_height_d]
        if @checkBox_view_rect_full.checked?
          @view_x_backup = @edit_view_rect_x.text
          @view_y_backup = @edit_view_rect_y.text
          @view_width_backup = @edit_view_rect_width.text
          @view_height_backup = @edit_view_rect_height.text
          @edit_view_rect_x.text = "0"
          @edit_view_rect_y.text = "0"
          @edit_view_rect_width.text = "-1"
          @edit_view_rect_height.text = "-1"
          control_disable(control_list)
        else
          @edit_view_rect_x.text = @view_x_backup
          @edit_view_rect_y.text = @view_y_backup
          @edit_view_rect_width.text = @view_width_backup
          @edit_view_rect_height.text = @view_height_backup
          control_enable(control_list)
        end
      end
        
      class Panel_view_rect                                         ##__BY_FDVR

      end                                                           ##__BY_FDVR

      class Panel_target_rot                                        ##__BY_FDVR

      end                                                           ##__BY_FDVR

      class Panel_target_pos                                        ##__BY_FDVR

      end                                                           ##__BY_FDVR

    end                                                             ##__BY_FDVR

    class Panel6                                                    ##__BY_FDVR
      #MOVEMENT
    
    end                                                             ##__BY_FDVR
    
  end                                                               ##__BY_FDVR
  
end                                                                 ##__BY_FDVR
