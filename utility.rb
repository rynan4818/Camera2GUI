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
  setting["language"] = $language
  File.open(SETTING_FILE,'w') do |file|
    JSON.pretty_generate(setting).each do |line|
      file.puts line
    end
  end
end

def camera2_setting_load
  $delete_camera = []
  return [false, SETTING_LOAD_ERROR_NO_DEFAULT] unless $firstperson_default  = json_read(FIRSTPERSON_DEFAULT)
  return [false, SETTING_LOAD_ERROR_NO_DEFAULT] unless $positionable_default = json_read(POSITIONABLE_DEFALUT)
  $scene_json = json_read("#{$bs_folder}\\#{CAMERA2_SCENES_JSON}")
  $scene_json_change = false
  cameras_dir = "#{$bs_folder}\\#{CAMERA2_CAMERAS_DIR}\\*.json".gsub(/\\/,"/")
  $cameras_json = []
  Dir.glob(cameras_dir) do |json_file|
    $cameras_json.push [File.basename(json_file, ".*"), json_read(json_file), json_file, false]
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

def trackbar_set(edit_control, trackBar_control, default)
  return if $change_flag
  $change_flag = true
  if edit_control.text.strip == ""
    edit_control.text = "%.15g"%default.to_f
    trackBar_control.position = (default * 10.0).to_i
  else
    if (edit_control.text.to_f * 10.0).to_i < trackBar_control.rangeMin
      edit_control.text = "%.15g"%(trackBar_control.rangeMin.to_f / 10.0)
    elsif (edit_control.text.to_f * 10.0).to_i > trackBar_control.rangeMax
      edit_control.text = "%.15g"%(trackBar_control.rangeMax.to_f / 10.0)
    elsif (edit_control.text.to_f * 10.0).to_i % trackBar_control.linesize > 0
      edit_control.text = "%.15g"%(((edit_control.text.to_f * 10.0).to_i - ((edit_control.text.to_f * 10.0).to_i % trackBar_control.linesize)).to_f / 10.0)
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
              unless before_camera_name == after_camera_name
                json_camera[idx] = after_camera_name
                $scene_json_change = true
              end
            else
              json_camera.delete_at(idx)
              $scene_json_change = true
            end
          else
            if scene_enabled
              json_camera.push after_camera_name
              $scene_json_change = true
            end
          end
        end
      end
    end
  end
end

def json_file_save
  $cameras_json.each_with_index do |camera,idx|
    camera[CAMERA_JSON]["layer"] = idx + 1
  end
  fail_list = []
  $delete_camera.each do |camera|
    begin
      File.delete camera[CAMERA_ORG] if File.exist? camera[CAMERA_ORG]
    rescue
      fail_list.push camera
    end
  end
  $delete_camera = fail_list
  $cameras_json.each do |camera|
    next unless camera[CAMERA_CHANGE]
    all_ok = true
    if File.basename(camera[CAMERA_ORG], ".*") != camera[CAMERA_NAME]
      begin
        File.delete camera[CAMERA_ORG] if File.exist? camera[CAMERA_ORG]
      rescue
        all_ok = false
      end
    end
    camera_file = "#{$bs_folder}\\#{CAMERA2_CAMERAS_DIR}\\#{camera[CAMERA_NAME]}.json"
    begin
      File.open(camera_file, 'w') do |file|
        JSON.pretty_generate(camera[CAMERA_JSON]).each do |line|
          file.puts line
        end
      end
    rescue
      all_ok = false
    end
    camera[CAMERA_CHANGE] = false if all_ok
  end
  if $scene_json_change
    scenes_file = "#{$bs_folder}\\#{CAMERA2_SCENES_JSON}"
    begin
      File.open(scenes_file, 'w') do |file|
        JSON.pretty_generate($scene_json).each do |line|
          file.puts line
        end
      end
    rescue
    end
  end
  $scene_json_change = false
end

def cos(d)
  return Math.cos(d * Math::PI / 180.0)
end

def sin(d)
  return Math.sin(d * Math::PI / 180.0)
end

def rotation_matrix(rx,ry,rz)
  
  r11 = cos(ry) * cos(rz)
  r12 = sin(rx) * sin(ry) * cos(rz) - cos(rx) * sin(rz)
  r13 = cos(rx) * sin(ry) * cos(rz) + sin(rx) * sin(rz)

  r21 = cos(ry) * sin(rz)
  r22 = sin(rx) * sin(ry) * sin(rz) + cos(rx) * cos(rz)
  r23 = cos(rx) * sin(ry) * sin(rz) - sin(rx) * cos(rz)

  r31 = -sin(ry)
  r32 = sin(rx) * cos(ry)
  r33 = cos(rx) * cos(ry)
  
  return [[r11, r12, r13], [r21, r22, r23], [r31, r32, r33]]
end

def rotation_cal(x, y, z ,r)
  xx = x * r[0][0] + y * r[0][1] + z * r[0][2]
  yy = x * r[1][0] + y * r[1][1] + z * r[1][2]
  zz = x * r[2][0] + y * r[2][1] + z * r[2][2]
  return [xx, yy, zz]
end
