##__BEGIN_OF_FORMDESIGNER__
## CAUTION!! ## This code was automagically ;-) created by FormDesigner.
## NEVER modify manualy -- otherwise, you'll have a terrible experience.

require 'vr/vruby'
require 'vr/vrcontrol'
require 'vr/vrcomctl'
require 'vr/vrmgdlayout'

class Form_main < VRForm
  include VRMenuUseable if defined? VRMenuUseable
  include VRMarginedFrameUseable if defined? VRMarginedFrameUseable
  include VRMenuUseable

  class TabPanel_main < VRTabbedPanel
    attr_reader :panel0
    attr_reader :panel1
    attr_reader :panel2
    attr_reader :panel3
    attr_reader :panel4
    attr_reader :panel5
    auto_panelresize(true)

    class Panel0 < VRPanel
      include VRStdControlContainer
      include VRComCtlContainer
      attr_reader :comboBox_camera_type
      attr_reader :comboBox_worldcam_visibility
      attr_reader :edit_anti_aliasing
      attr_reader :edit_camera_name
      attr_reader :edit_field_of_view
      attr_reader :edit_fps_limit
      attr_reader :edit_preview_size
      attr_reader :edit_render_scale
      attr_reader :edit_z_offset
      attr_reader :static_anti_aliasing
      attr_reader :static_camera_name
      attr_reader :static_camera_type
      attr_reader :static_field_of_view
      attr_reader :static_fps_limit
      attr_reader :static_preview_size
      attr_reader :static_render_scale
      attr_reader :static_warldcam_visibiity
      attr_reader :static_z_offset
      attr_reader :trackBar_field_of_view
      attr_reader :trackBar_fps_limit
      attr_reader :trackBar_preview_size
      attr_reader :trackBar_render_scale
      attr_reader :trackBar_z_offset
      attr_reader :updown_anti_aliasing

      def construct
        addControl(VRCombobox,'comboBox_camera_type',"",140,64,384,80)
        addControl(VRCombobox,'comboBox_worldcam_visibility',"",140,240,376,80)
        addControl(VREdit,'edit_anti_aliasing',"",140,200,64,24,0x800)
        addControl(VREdit,'edit_camera_name',"",140,24,384,24)
        addControl(VREdit,'edit_field_of_view',"",140,104,64,24)
        addControl(VREdit,'edit_fps_limit',"",140,136,64,24)
        addControl(VREdit,'edit_preview_size',"",140,280,72,24)
        addControl(VREdit,'edit_render_scale',"",140,168,64,24)
        addControl(VREdit,'edit_z_offset',"",140,320,72,24)
        addControl(VRStatic,'static_anti_aliasing',"Anti Aliasing",36,200,96,24)
        addControl(VRStatic,'static_camera_name',"Camera Name",28,24,104,24)
        addControl(VRStatic,'static_camera_type',"Camera Type",36,64,96,24)
        addControl(VRStatic,'static_field_of_view',"Field of View",36,104,96,24)
        addControl(VRStatic,'static_fps_limit',"FPS Limit (0=off)",12,136,120,24)
        addControl(VRStatic,'static_preview_size',"Preview Size",36,280,88,24)
        addControl(VRStatic,'static_render_scale',"Render Scale",28,168,96,24)
        addControl(VRStatic,'static_warldcam_visibiity',"Worldcam Visibility",4,240,128,24)
        addControl(VRStatic,'static_z_offset',"Z-Offset",60,320,72,24)
        addControl(VRTrackbar,'trackBar_field_of_view',"trackBar1",220,104,304,24)
        addControl(VRTrackbar,'trackBar_fps_limit',"trackBar1",220,136,304,24)
        addControl(VRTrackbar,'trackBar_preview_size',"trackBar2",220,280,304,24)
        addControl(VRTrackbar,'trackBar_render_scale',"trackBar1",220,168,304,24)
        addControl(VRTrackbar,'trackBar_z_offset',"trackBar1",220,320,304,24)
        addControl(VRUpdown,'updown_anti_aliasing',"updown1",228,200,80,24,0x40)
      end
    end

    class Panel1 < VRPanel
      include VRStdControlContainer
      attr_reader :checkBox_UI
      attr_reader :checkBox_avatar
      attr_reader :checkBox_cut_particles
      attr_reader :checkBox_debris
      attr_reader :checkBox_floor
      attr_reader :comboBox_notes
      attr_reader :comboBox_walls
      attr_reader :static_notes
      attr_reader :static_walls

      def construct
        addControl(VRCheckbox,'checkBox_UI',"UI",108,232,128,24)
        addControl(VRCheckbox,'checkBox_avatar',"Avatar",108,192,120,24)
        addControl(VRCheckbox,'checkBox_cut_particles',"Cut Particles",108,152,120,24)
        addControl(VRCheckbox,'checkBox_debris',"Debris",108,112,80,24)
        addControl(VRCheckbox,'checkBox_floor',"Floor",108,272,136,24)
        addControl(VRCombobox,'comboBox_notes',"",108,72,352,80)
        addControl(VRCombobox,'comboBox_walls',"",108,32,352,80)
        addControl(VRStatic,'static_notes',"Notes",52,72,48,24)
        addControl(VRStatic,'static_walls',"Walls",60,32,40,24)
      end
    end

    class Panel2 < VRPanel
      include VRStdControlContainer
      include VRComCtlContainer
      attr_reader :checkBox_enabled
      attr_reader :checkBox_follow_replay_position
      attr_reader :checkBox_force_upright
      attr_reader :edit_position_smoothing
      attr_reader :edit_rotation_smoothing
      attr_reader :static_follow360
      attr_reader :static_position_smoothing
      attr_reader :static_rotation_smoothing
      attr_reader :static_smooth_and_360
      attr_reader :static_smoothfollow
      attr_reader :static_smoothing_tips
      attr_reader :trackBar_position_smoothing
      attr_reader :trackBar_rotation_smoothing

      def construct
        addControl(VRCheckbox,'checkBox_enabled',"Enabled",60,184,96,32)
        addControl(VRCheckbox,'checkBox_follow_replay_position',"Follow Replay Position",60,72,208,24)
        addControl(VRCheckbox,'checkBox_force_upright',"Force Upright",60,32,200,32)
        addControl(VREdit,'edit_position_smoothing',"",172,112,72,24)
        addControl(VREdit,'edit_rotation_smoothing',"",172,272,72,24)
        addControl(VRStatic,'static_follow360',"=======FOLLOW360=======",60,160,256,24)
        addControl(VRStatic,'static_position_smoothing',"Position Smoothing*",20,112,144,24)
        addControl(VRStatic,'static_rotation_smoothing',"Rotation Smoothing*",20,272,144,24)
        addControl(VRStatic,'static_smooth_and_360',"=======360 and SMOOTH FOLLOW=======",52,232,336,24)
        addControl(VRStatic,'static_smoothfollow',"=======SMOOTHFOLLOW=======",60,8,320,24)
        addControl(VRStatic,'static_smoothing_tips',"*Lower value = More smoothing",148,320,240,24)
        addControl(VRTrackbar,'trackBar_position_smoothing',"trackBar1",252,112,272,24)
        addControl(VRTrackbar,'trackBar_rotation_smoothing',"trackBar1",252,272,272,24)
      end
    end

    class Panel3 < VRPanel
      include VRStdControlContainer
      attr_reader :checkBox_auto_hide_HUD
      attr_reader :checkBox_auto_visible_walls
      attr_reader :checkBox_move_with_map

      def construct
        addControl(VRCheckbox,'checkBox_auto_hide_HUD',"Auto-Hide HUD",60,104,208,24)
        addControl(VRCheckbox,'checkBox_auto_visible_walls',"Auto-Visible Walls",60,64,208,32)
        addControl(VRCheckbox,'checkBox_move_with_map',"Move with Map",60,24,208,32)
      end
    end

    class Panel4 < VRPanel
      include VRStdControlContainer
      attr_reader :checkBox_custom1
      attr_reader :checkBox_custom2
      attr_reader :checkBox_custom3
      attr_reader :checkBox_fpfc
      attr_reader :checkBox_menu
      attr_reader :checkBox_multiplayer_menu
      attr_reader :checkBox_playing
      attr_reader :checkBox_playing_360
      attr_reader :checkBox_playing_modmap
      attr_reader :checkBox_playing_multi
      attr_reader :checkBox_replay

      def construct
        addControl(VRCheckbox,'checkBox_custom1',"Custom1",36,184,88,24)
        addControl(VRCheckbox,'checkBox_custom2',"Custom2",284,184,96,32)
        addControl(VRCheckbox,'checkBox_custom3',"Custom3",36,224,96,32)
        addControl(VRCheckbox,'checkBox_fpfc',"FPFC",284,144,176,32)
        addControl(VRCheckbox,'checkBox_menu',"Menu",36,16,72,32)
        addControl(VRCheckbox,'checkBox_multiplayer_menu',"Multiplayer Menu",284,16,152,32)
        addControl(VRCheckbox,'checkBox_playing',"Playing",36,56,72,24)
        addControl(VRCheckbox,'checkBox_playing_360',"Playing360",284,56,104,32)
        addControl(VRCheckbox,'checkBox_playing_modmap',"Playing Modmap",36,96,136,32)
        addControl(VRCheckbox,'checkBox_playing_multi',"Playing Multi",284,96,120,40)
        addControl(VRCheckbox,'checkBox_replay',"Replay",36,136,80,32)
      end
    end

    class Panel5 < VRPanel
      include VRStdControlContainer
      attr_reader :edit_target_pos_x
      attr_reader :edit_target_pos_y
      attr_reader :edit_target_pos_z
      attr_reader :edit_target_rot_x
      attr_reader :edit_target_rot_y
      attr_reader :edit_target_rot_z
      attr_reader :edit_view_rect_height
      attr_reader :edit_view_rect_width
      attr_reader :edit_view_rect_x
      attr_reader :edit_view_rect_y
      attr_reader :static_target_pos
      attr_reader :static_target_pos_x
      attr_reader :static_target_pos_y
      attr_reader :static_target_pos_z
      attr_reader :static_target_rot
      attr_reader :static_target_rot_x
      attr_reader :static_target_rot_y
      attr_reader :static_target_rot_z
      attr_reader :static_view_rect
      attr_reader :static_view_rect_height
      attr_reader :static_view_rect_width
      attr_reader :static_view_rect_x
      attr_reader :static_view_rect_y

      def construct
        addControl(VREdit,'edit_target_pos_x',"",196,48,72,24)
        addControl(VREdit,'edit_target_pos_y',"",196,88,72,24)
        addControl(VREdit,'edit_target_pos_z',"",196,128,72,24)
        addControl(VREdit,'edit_target_rot_x',"",364,48,72,24)
        addControl(VREdit,'edit_target_rot_y',"",364,88,72,24)
        addControl(VREdit,'edit_target_rot_z',"",364,128,72,24)
        addControl(VREdit,'edit_view_rect_height',"",76,168,64,24)
        addControl(VREdit,'edit_view_rect_width',"",76,128,64,24)
        addControl(VREdit,'edit_view_rect_x',"",76,48,64,24)
        addControl(VREdit,'edit_view_rect_y',"",76,88,64,24)
        addControl(VRStatic,'static_target_pos',"Target Pos",188,16,88,24)
        addControl(VRStatic,'static_target_pos_x',"X",180,48,16,24)
        addControl(VRStatic,'static_target_pos_y',"Y",180,88,16,24)
        addControl(VRStatic,'static_target_pos_z',"Z",180,128,16,24)
        addControl(VRStatic,'static_target_rot',"Target Rot",356,16,80,24)
        addControl(VRStatic,'static_target_rot_x',"X",348,48,16,24)
        addControl(VRStatic,'static_target_rot_y',"Y",348,88,16,24)
        addControl(VRStatic,'static_target_rot_z',"Z",348,128,16,24)
        addControl(VRStatic,'static_view_rect',"View Rect",28,16,80,24)
        addControl(VRStatic,'static_view_rect_height',"HEIGHT",12,168,56,16)
        addControl(VRStatic,'static_view_rect_width',"WIDTH",20,128,48,16)
        addControl(VRStatic,'static_view_rect_x',"X",60,48,16,24)
        addControl(VRStatic,'static_view_rect_y',"Y",60,88,16,24)
      end
    end

    def construct
      setupPanels(*[
        ['GENERAL',Panel0,'panel0'],
        ['VISIBILITY',Panel1,'panel1'],
        ['FOLLOW',Panel2,'panel2'],
        ['MODMAPEXT',Panel3,'panel3'],
        ['SCENES',Panel4,'panel4'],
        ['OTHER',Panel5,'panel5']
      ])
    end
  end

  def construct
    self.caption = 'Camera2GUI'
    self.move(662,321,580,625)
    #$_addControl(VRMenu,'mainmenu1',"",512,72,24,24)
    @mainmenu1 = newMenu.set(
      [
        ["&File",[
          ["&New\tCtrl+N", "new"],
          ["&Open", "open"],
          ["&Save", "save"],
          ["Save&As", "saveas"],
          ["sep", "_vrmenusep", 2048],
          ["E&xit", "exit"]]
        ],
        ["&Edit",[
          ["&Delete", "doDelete"],
          ["Cu&t", "cut"],
          ["&Copy", "copy"],
          ["&Paste", "paste"]]
        ],
        ["&Help",[
          ["Versio&n", "version"]]
        ]
      ]
    )
    setMenu(@mainmenu1,true)
    addControl(TabPanel_main,'tabPanel_main',"tabPanel1",8,168,552,272)
    addControl(VRButton,'button_add',"ADD CAMERA",16,16,128,32)
    addControl(VRButton,'button_del',"DELETE CAMERA",16,56,128,32)
    addControl(VRButton,'button_down',"DOWN",480,112,64,32)
    addControl(VRButton,'button_reflection',"REFLECTION",16,96,128,32)
    addControl(VRButton,'button_up',"UP",480,16,64,32)
    addControl(VRCheckbox,'checkBox_auto_reflection',"Auto reflection",16,136,128,24)
    addControl(VRListbox,'listBox_camera',"listBox1",160,16,304,132)
    #$_addControl(VRMgdVertLayoutFrame,'vertFrame1',"",480,72,24,24)
    @vertFrame1=setMarginedFrame(VRMgdVertLayoutFrame)
    @vertFrame1.register(@tabPanel_main)
    @vertFrame1.setMargin(0,165,0,0)
    @tabPanel_main.setMargin(0,0,0,0)
  end 

end

##__END_OF_FORMDESIGNER__
