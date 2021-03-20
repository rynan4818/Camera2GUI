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
        if @comboBox_camera_type.getTextOf(@comboBox_camera_type.selectedString) == COMBO_CAMERA_TYPE[0]
          #FirstPerson
          $camera_type = 0
        elsif @comboBox_camera_type.getTextOf(@comboBox_camera_type.selectedString) == COMBO_CAMERA_TYPE[1]
          #Positionable
          $camera_type = 1
        end
        view_set
      end

      def edit_field_of_view_changed
        trackbar_set(@edit_field_of_view, @trackBar_field_of_view)
      end
    
      def edit_fps_limit_changed
        trackbar_set(@edit_fps_limit, @trackBar_fps_limit)
      end
    
      def edit_render_scale_changed
        trackbar_set(@edit_render_scale, @trackBar_render_scale)
      end
    
      def edit_preview_size_changed
        trackbar_set(@edit_preview_size, @trackBar_preview_size)
      end
    
      def edit_z_offset_changed
        trackbar_set(@edit_z_offset, @trackBar_z_offset)
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
        trackbar_set(@edit_position_smoothing, @trackBar_position_smoothing)
      end
    
      def edit_rotation_smoothing_changed
        trackbar_set(@edit_rotation_smoothing, @trackBar_rotation_smoothing)
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
