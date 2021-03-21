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

def json_read(json_file)
  if File.exist?(json_file)
    return JSON.parse(File.read(json_file))
  end
  return false
end

def setting_load
  $bs_folder = nil
  $language  = "english"
  if setting = json_read(SETTING_FILE)
    set = proc{|defalut, key| setting[key] ? setting[key] : defalut}
    $bs_folder = set.call($bs_folder, "bs_folder")
    $language  = set.call($language, "language")
  end
end

def setting_save
  setting = {} unless setting = json_read(SETTING_FILE)
  setting["bs_folder"] = $bs_folder
  File.open(SETTING_FILE,'w') do |file|
    JSON.pretty_generate(setting).each do |line|
      file.puts line
    end
  end
end

def camera2_setting_load
  return [false, SETTING_LOAD_ERROR_NO_DEFAULT] unless $firstperson_default  = json_read(FIRSTPERSON_DEFAULT)
  return [false, SETTING_LOAD_ERROR_NO_DEFAULT] unless $positionable_default = json_read(POSITIONABLE_DEFALUT)
  $scene_json = json_read("#{$bs_folder}\\#{CAMERA2_SCENES_JSON}")
  cameras_dir = "#{$bs_folder}\\#{CAMERA2_CAMERAS_DIR}\\*.json".gsub(/\\/,"/")
  $cameras_json = []
  Dir.glob(cameras_dir) do |json_file|
    $cameras_json.push [File.basename(json_file, ".*"), json_read(json_file), json_file]
  end
  return [false, SETTING_LOAD_ERROR_NO_SCENE] unless $scene_json
  return [false, SETTING_LOAD_ERROR_NO_CAMERA] if $cameras_json == []
  movement_dir_load
  return [true, nil]
end

def movement_dir_load
  movement_dir = "#{$bs_folder}\\#{CAMERA2_MOVEMENT_DIR}\\*.json".gsub(/\\/,"/")
  $movement_json = []
  Dir.glob(movement_dir) do |json_file|
    $movement_json.push File.basename(json_file, ".*")
  end
end

def trackbar_set(edit_control, trackBar_control)
  return if $change_flag
  $change_flag = true
  if edit_control.text.strip == ""
    trackBar_control.position = trackBar_control.rangeMin
  else
    if edit_control.text.to_f < trackBar_control.rangeMin.to_f / 10.0
      edit_control.text = "%.15g"%(trackBar_control.rangeMin.to_f / 10.0)
    elsif edit_control.text.to_f > trackBar_control.rangeMax.to_f / 10.0
      edit_control.text = "%.15g"%(trackBar_control.rangeMax.to_f / 10.0)
    elsif edit_control.text.to_f % (trackBar_control.linesize.to_f / 10.0) > 0.001
      edit_control.text = "%.15g"%(edit_control.text.to_f - (edit_control.text.to_f % (trackBar_control.linesize.to_f / 10.0)))
    end
    trackBar_control.position = (edit_control.text.to_f * 10.0).to_i
  end
  $track_bar_position[trackBar_control] = [trackBar_control.position,edit_control]
  $change_flag = false
end

def edit_set
  return if $change_flag
  $change_flag = true
  $track_bar_position.each do |control,value|
    position = value[0]
    edit_control = value[1]
    if control.position != position
      control.position = (control.position - (control.position % control.linesize))
      $track_bar_position[control] = [control.position,edit_control]
      edit_control.text = "%.15g"%(control.position.to_f / 10.0)
    end
  end
  $change_flag = false
end

def control_disable(control_list)
  control_list.each do |control|
    if control.class == VREdit
      control.readonly = true
    else
      control.style |= WStyle::WS_DISABLED
    end
  end
  refresh
end

def control_enable(control_list)
  control_list.each do |control|
    if control.class == VREdit
      control.readonly = false
    else
      control.style &= ~WStyle::WS_DISABLED
    end
  end
  refresh
end

def character_check(vr_ogj,regular,text)
  if text =~ Regexp.new(regular)
    vr_ogj.messageBox("'#{$&}' #{CHARACTER_CHECK_MES}", CHARACTER_CHECK_TITLE, WConst::MB_ICONWARNING | WConst::MB_OK)
    return text.gsub(regular,'')
  else
    return false
  end
end

def scenes_json_set(scene, scene_enabled, before_camera_name, after_camera_name)
  $scene_json.each do |key, value|
    if key == "scenes"
      value.each do |json_scene, json_camera|
        if json_scene == scene
          if idx = json_camera.index(before_camera_name)
            if scene_enabled
              json_camera[idx] = after_camera_name
            else
              json_camera.delete_at(idx)
            end
          else
            if scene_enabled
              json_camera.push after_camera_name
            end
          end
        end
      end
    end
  end
end