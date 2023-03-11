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
      def button_custom_scenes_clicked
        $main_windowrect = self.windowrect
        return unless VRLocalScreen.openModalDialog(self,nil,Modaldlg_custom_scenes,nil,nil)
      end
    end                                                             ##__BY_FDVR

    class Panel5                                                    ##__BY_FDVR
      #LAYOUT
      def checkBox_view_rect_full_clicked
        @change_view_ok = false
        control_list = [@edit_view_rect_x, @edit_view_rect_y, @edit_view_rect_width, @edit_view_rect_height,
                        @button_view_rect_x_u, @button_view_rect_x_d, @button_view_rect_y_u, @button_view_rect_y_d,
                        @button_view_rect_width_u, @button_view_rect_width_d, @button_view_rect_height_u, @button_view_rect_height_d]
        if @checkBox_view_rect_full.checked?
          @view_x_backup = @edit_view_rect_x.text
          @view_y_backup = @edit_view_rect_y.text
          @view_width_backup = @edit_view_rect_width.text
          @view_height_backup = @edit_view_rect_height.text
          @edit_view_rect_x.text = "0.0"
          @edit_view_rect_y.text = "0.0"
          @edit_view_rect_width.text = "-1.0"
          @edit_view_rect_height.text = "-1.0"
          control_disable(control_list)
        else
          @edit_view_rect_x.text = @view_x_backup
          @edit_view_rect_y.text = @view_y_backup
          @edit_view_rect_width.text = @view_width_backup
          @edit_view_rect_height.text = @view_height_backup
          control_enable(control_list)
        end
        @change_view_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
      
      def edit_target_rot_x_changed
        return unless @change_rot_ok
        @change_rot_ok = false
        rot_x = @edit_target_rot_x.text.to_f
        if @edit_target_rot_x.text.to_f >= 360.0
          rot_x = @edit_target_rot_x.text.to_f - 360.0
        elsif @edit_target_rot_x.text.to_f < 0.0
          rot_x = 360.0 + @edit_target_rot_x.text.to_f
        end
        change_rot_x = "%.15g"%((rot_x * POS_ROT_ROUND).round.to_f / POS_ROT_ROUND)
        @edit_target_rot_x.text = change_rot_x unless @edit_target_rot_x.text == change_rot_x
        @change_rot_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def edit_target_rot_y_changed
        return unless @change_rot_ok
        @change_rot_ok = false
        rot_y = @edit_target_rot_y.text.to_f
        if @edit_target_rot_y.text.to_f >= 360.0
          rot_y = @edit_target_rot_y.text.to_f - 360.0
        elsif @edit_target_rot_y.text.to_f < 0.0
          rot_y = 360.0 + @edit_target_rot_y.text.to_f
        end
        change_rot_y = "%.15g"%((rot_y * POS_ROT_ROUND).round.to_f / POS_ROT_ROUND)
        @edit_target_rot_y.text = change_rot_y unless @edit_target_rot_y.text == change_rot_y
        @change_rot_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def edit_target_rot_z_changed
        return unless @change_rot_ok
        @change_rot_ok = false
        rot_z = @edit_target_rot_z.text.to_f
        if @edit_target_rot_z.text.to_f >= 360.0
          rot_z = @edit_target_rot_z.text.to_f - 360.0
        elsif @edit_target_rot_z.text.to_f < 0.0
          rot_z = 360.0 + @edit_target_rot_z.text.to_f
        end
        change_rot_z = "%.15g"%((rot_z * POS_ROT_ROUND).round.to_f / POS_ROT_ROUND)
        @edit_target_rot_z.text = change_rot_z unless @edit_target_rot_z.text == change_rot_z
        @change_rot_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
      
      def edit_target_pos_x_changed
        return unless @change_pos_ok
        @change_pos_ok = false
        change_pos_x = "%.15g"%((@edit_target_pos_x.text.to_f * POS_ROT_ROUND).round.to_f / POS_ROT_ROUND)
        @edit_target_pos_x.text = change_pos_x unless @edit_target_pos_x.text == change_pos_x
        @change_pos_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def edit_target_pos_y_changed
        return unless @change_pos_ok
        @change_pos_ok = false
        change_pos_y = "%.15g"%((@edit_target_pos_y.text.to_f * POS_ROT_ROUND).round.to_f / POS_ROT_ROUND)
        @edit_target_pos_y.text = change_pos_y unless @edit_target_pos_y.text == change_pos_y
        @change_pos_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def edit_target_pos_z_changed
        return unless @change_pos_ok
        @change_pos_ok = false
        change_pos_z = "%.15g"%((@edit_target_pos_z.text.to_f * POS_ROT_ROUND).round.to_f / POS_ROT_ROUND)
        @edit_target_pos_z.text = change_pos_z unless @edit_target_pos_z.text == change_pos_z
        @change_pos_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
      
      def edit_view_rect_x_changed
        return unless @change_view_ok
        @change_view_ok = false
        change_x = @edit_view_rect_x.text.to_f
        change_x = change_x.to_i if change_x > 0 || @edit_view_rect_x.text.strip == "0"
        @edit_view_rect_x.text = change_x.to_s unless @edit_view_rect_x.text == change_x.to_s
        @change_view_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def edit_view_rect_y_changed
        return unless @change_view_ok
        @change_view_ok = false
        change_y = @edit_view_rect_y.text.to_f
        change_y = change_y.to_i if change_y > 0 || @edit_view_rect_y.text.strip == "0"
        @edit_view_rect_y.text = change_y.to_s unless @edit_view_rect_y.text == change_y.to_s
        @change_view_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def edit_view_rect_width_changed
        return unless @change_view_ok
        @change_view_ok = false
        change_w = @edit_view_rect_width.text.to_f
        change_w = change_w.to_i if change_w > 0 || @edit_view_rect_width.text.strip == "0"
        @edit_view_rect_width.text = change_w.to_s unless @edit_view_rect_width.text == change_w.to_s
        @change_view_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def edit_view_rect_height_changed
        return unless @change_view_ok
        @change_view_ok = false
        change_h = @edit_view_rect_height.text.to_f
        change_h = change_h.to_i if change_h > 0 || @edit_view_rect_height.text.strip == "0"
        @edit_view_rect_height.text = change_h.to_s unless @edit_view_rect_height.text == change_h.to_s
        @change_view_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end

      def edit_pos_amount_changed
        amount_trackbar_set(@edit_pos_amount, @trackBar_pos_amount, 0.01, 2, @trackBar_pos_amount.rangeMax)
      end
    
      def button_view_rect_x_u_clicked
        if @edit_view_rect_x.text.to_i > 0 || @edit_view_rect_x.text.strip == "0"
          @edit_view_rect_x.text = @edit_view_rect_x.text.to_i + view_amount
        else
          new_rect = @edit_view_rect_x.text.to_f + view_amount.to_f / 1000.0
          if new_rect > 0.0
            @edit_view_rect_x.text = "0.0"
          else
            @edit_view_rect_x.text = new_rect.to_s
          end
        end
      end
    
      def button_view_rect_x_d_clicked
        if @edit_view_rect_x.text.to_i > 0 || @edit_view_rect_x.text.strip == "0"
          new_rect = @edit_view_rect_x.text.to_i - view_amount
          if new_rect < 0
            @edit_view_rect_x.text = "0"
          else
            @edit_view_rect_x.text = new_rect
          end
        else
          new_rect = @edit_view_rect_x.text.to_f - view_amount.to_f / 1000.0
          if new_rect < -1.0
            @edit_view_rect_x.text = "-1.0"
          else
            @edit_view_rect_x.text = new_rect
          end
        end
      end
    
      def button_view_rect_y_u_clicked
        if @edit_view_rect_y.text.to_i > 0 || @edit_view_rect_y.text.strip == "0"
          @edit_view_rect_y.text = @edit_view_rect_y.text.to_i + view_amount
        else
          new_rect = @edit_view_rect_y.text.to_f + view_amount.to_f / 1000.0
          if new_rect > 0.0
            @edit_view_rect_y.text = "0.0"
          else
            @edit_view_rect_y.text = new_rect.to_s
          end
        end
      end
    
      def button_view_rect_y_d_clicked
        if @edit_view_rect_y.text.to_i > 0 || @edit_view_rect_y.text.strip == "0"
          new_rect = @edit_view_rect_y.text.to_i - view_amount
          if new_rect < 0
            @edit_view_rect_y.text = "0"
          else
            @edit_view_rect_y.text = new_rect
          end
        else
          new_rect = @edit_view_rect_y.text.to_f - view_amount.to_f / 1000.0
          if new_rect < -1.0
            @edit_view_rect_y.text = "-1.0"
          else
            @edit_view_rect_y.text = new_rect
          end
        end
      end
    
      def button_view_rect_width_u_clicked
        if @edit_view_rect_width.text.to_i > 0 || @edit_view_rect_width.text.strip == "0"
          @edit_view_rect_width.text = @edit_view_rect_width.text.to_i + view_amount
        else
          new_rect = @edit_view_rect_width.text.to_f + view_amount.to_f / 1000.0
          if new_rect > 0.0
            @edit_view_rect_width.text = "0.0"
          else
            @edit_view_rect_width.text = new_rect.to_s
          end
        end
      end
    
      def button_view_rect_width_d_clicked
        if @edit_view_rect_width.text.to_i > 0 || @edit_view_rect_width.text.strip == "0"
          new_rect = @edit_view_rect_width.text.to_i - view_amount
          if new_rect < 0
            @edit_view_rect_width.text = "0"
          else
            @edit_view_rect_width.text = new_rect
          end
        else
          new_rect = @edit_view_rect_width.text.to_f - view_amount.to_f / 1000.0
          if new_rect < -1.0
            @edit_view_rect_width.text = "-1.0"
          else
            @edit_view_rect_width.text = new_rect
          end
        end
      end
    
      def button_view_rect_height_u_clicked
        if @edit_view_rect_height.text.to_i > 0 || @edit_view_rect_height.text.strip == "0"
          @edit_view_rect_height.text = @edit_view_rect_height.text.to_i + view_amount
        else
          new_rect = @edit_view_rect_height.text.to_f + view_amount.to_f / 1000.0
          if new_rect > 0.0
            @edit_view_rect_height.text = "0.0"
          else
            @edit_view_rect_height.text = new_rect.to_s
          end
        end
      end
    
      def button_view_rect_height_d_clicked
        if @edit_view_rect_height.text.to_i > 0 || @edit_view_rect_height.text.strip == "0"
          new_rect = @edit_view_rect_height.text.to_i - view_amount
          if new_rect < 0
            @edit_view_rect_height.text = "0"
          else
            @edit_view_rect_height.text = new_rect
          end
        else
          new_rect = @edit_view_rect_height.text.to_f - view_amount.to_f / 1000.0
          if new_rect < -1.0
            @edit_view_rect_height.text = "-1.0"
          else
            @edit_view_rect_height.text = new_rect
          end
        end
      end
    
      def button_target_pos_x_u_clicked
        @edit_target_pos_x.text = "%.15g"%(@edit_target_pos_x.text.to_f + pos_amount)
      end
    
      def button_target_pos_x_d_clicked
        @edit_target_pos_x.text = "%.15g"%(@edit_target_pos_x.text.to_f - pos_amount)
      end
    
      def button_target_pos_y_u_clicked
        @edit_target_pos_y.text = "%.15g"%(@edit_target_pos_y.text.to_f + pos_amount)
      end
    
      def button_target_pos_y_d_clicked
        @edit_target_pos_y.text = "%.15g"%(@edit_target_pos_y.text.to_f - pos_amount)
      end
    
      def button_target_pos_z_u_clicked
        @edit_target_pos_z.text = "%.15g"%(@edit_target_pos_z.text.to_f + pos_amount)
      end
    
      def button_target_pos_z_d_clicked
        @edit_target_pos_z.text = "%.15g"%(@edit_target_pos_z.text.to_f - pos_amount)
      end
    
      def button_target_rot_x_u_clicked
        @edit_target_rot_x.text = "%.15g"%(@edit_target_rot_x.text.to_f + rot_amount)
      end
    
      def button_target_rot_x_d_clicked
        @edit_target_rot_x.text = "%.15g"%(@edit_target_rot_x.text.to_f - rot_amount)
      end
    
      def button_target_rot_y_u_clicked
        @edit_target_rot_y.text = "%.15g"%(@edit_target_rot_y.text.to_f + rot_amount)
      end
    
      def button_target_rot_y_d_clicked
        @edit_target_rot_y.text = "%.15g"%(@edit_target_rot_y.text.to_f - rot_amount)
      end
    
      def button_target_rot_z_u_clicked
        @edit_target_rot_z.text = "%.15g"%(@edit_target_rot_z.text.to_f + rot_amount)
      end
    
      def button_target_rot_z_d_clicked
        @edit_target_rot_z.text = "%.15g"%(@edit_target_rot_z.text.to_f - rot_amount)
      end
    
      def button_reset_clicked
        $apply_ok = false
        change_pos_ok = false
        change_rot_ok = false
        @edit_target_pos_x.text = "0"
        @edit_target_pos_y.text = "0"
        @edit_target_pos_z.text = "0"
        @edit_target_rot_x.text = "0"
        @edit_target_rot_y.text = "0"
        @edit_target_rot_z.text = "0"
        $apply_ok = true
        change_pos_ok = true
        change_rot_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def button_yaw_left_clicked
        $apply_ok = false
        button_target_rot_y_d_clicked
        $apply_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def button_yaw_right_clicked
        $apply_ok = false
        button_target_rot_y_u_clicked
        $apply_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def button_roll_left_clicked
        $apply_ok = false
        button_target_rot_z_u_clicked
        $apply_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def button_roll_right_clicked
        $apply_ok = false
        button_target_rot_z_d_clicked
        $apply_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def button_pitch_up_clicked
        $apply_ok = false
        button_target_rot_x_d_clicked
        $apply_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def button_pitch_down_clicked
        $apply_ok = false
        button_target_rot_x_u_clicked
        $apply_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def button_front_clicked
        $apply_ok = false
        flying_move(0.0, 0.0, pos_amount)
        $apply_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def button_back_clicked
        $apply_ok = false
        flying_move(0.0, 0.0, -pos_amount)
        $apply_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def button_left_clicked
        $apply_ok = false
        flying_move(-pos_amount, 0.0, 0.0)
        $apply_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def button_right_clicked
        $apply_ok = false
        flying_move(pos_amount, 0.0, 0.0)
        $apply_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def button_up_clicked
        $apply_ok = false
        flying_move(0.0, pos_amount, 0.0)
        $apply_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    
      def button_down_clicked
        $apply_ok = false
        flying_move(0.0, -pos_amount, 0.0)
        $apply_ok = true
        $main_form.button_apply_clicked if @checkBox_auto_apply.checked? && $apply_ok
      end
    end                                                             ##__BY_FDVR

    class Panel6                                                    ##__BY_FDVR
      #MOVEMENT
    end                                                             ##__BY_FDVR
    
    class Panel7
      #MISC
      def edit_fps_limit_changed
        trackbar_set(@edit_fps_limit, @trackBar_fps_limit, $firstperson_default["FPSLimiter"]["fpsLimit"])
      end
      
    end
    
  end                                                               ##__BY_FDVR
  
end                                                                 ##__BY_FDVR
