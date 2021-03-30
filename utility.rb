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
  $pos_amount = 0.01
  $view_amount = nil
  $rot_amount = nil
  $main_form_x = 200
  $main_form_y = 200
  $tooltip_enabled = true
  $json_update_check_time = 0
  $key_send_time = 100
  $autoit_wait_time = 0
  $fpfc_command = ""
  $setting_folder = ""
  if setting = json_read(SETTING_FILE)
    set = proc{|defalut, key| setting[key] == nil ? defalut : setting[key]}
    $bs_folder   = set.call($bs_folder, "bs_folder")
    $language    = set.call($language, "language")
    $pos_amount  = set.call($pos_amount, "pos_amount")
    $view_amount = set.call($view_amount, "view_amount")
    $rot_amount  = set.call($rot_amount, "rot_amount")
    $main_form_x = set.call($main_form_x, "main_form_x")
    $main_form_y = set.call($main_form_y, "main_form_y")
    $tooltip_enabled = set.call($tooltip_enabled, "tooltip_enabled")
    $json_update_check_time = set.call($json_update_check_time, "json_update_check_time")
    $key_send_time = set.call($key_send_time, "key_send_time")
    $autoit_wait_time = set.call($autoit_wait_time, "autoit_wait_time")
    $fpfc_command = set.call($fpfc_command, "fpfc_command")
    $setting_folder = set.call($setting_folder, "setting_folder")
    end
end

def setting_save
  setting = {} unless setting = json_read(SETTING_FILE)
  setting["bs_folder"] = $bs_folder
  setting["language"] = $language
  setting["pos_amount"] = $pos_amount
  setting["view_amount"] = $view_amount
  setting["rot_amount"] = $rot_amount
  setting['main_form_x'] = $main_windowrect[0]
  setting['main_form_y'] = $main_windowrect[1]
  setting['tooltip_enabled'] = $tooltip_enabled
  setting['json_update_check_time'] = $json_update_check_time
  setting['key_send_time'] = $key_send_time
  setting['autoit_wait_time'] = $autoit_wait_time
  setting['fpfc_command'] = $fpfc_command
  setting['setting_folder'] = $setting_folder
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
  scene_json_file = "#{$bs_folder}\\#{CAMERA2_SCENES_JSON}"
  $scene_json = json_read(scene_json_file)
  $scene_json_mtime =  File.stat(scene_json_file).mtime if $scene_json
  $scene_json_change = false
  cameras_dir = "#{$bs_folder}\\#{CAMERA2_CAMERAS_DIR}\\*.json".gsub(/\\/,"/")
  $cameras_json = []
  $cameras_json_mtime = {}
  Dir.glob(cameras_dir) do |json_file|
    $cameras_json.push [File.basename(json_file, ".*"), json_read(json_file), json_file, false]
    $cameras_json_mtime[json_file] = File.stat(json_file).mtime
  end
  return [false, SETTING_LOAD_ERROR_NO_SCENE] unless $scene_json
  return [false, SETTING_LOAD_ERROR_NO_CAMERA] if $cameras_json == []
  movement_dir_load
  return [true, nil]
end

def file_timestamp_check
  scene_json_file = "#{$bs_folder}\\#{CAMERA2_SCENES_JSON}"
  if File.exist? scene_json_file
    return false if $scene_json_mtime < File.stat(scene_json_file).mtime - $json_update_check_time
  end
  cameras_dir = "#{$bs_folder}\\#{CAMERA2_CAMERAS_DIR}\\*.json".gsub(/\\/,"/")
  Dir.glob(cameras_dir) do |json_file|
    if timestamp = $cameras_json_mtime[json_file]
      return false if timestamp < File.stat(json_file).mtime - $json_update_check_time
    else
      return false
    end
  end
  return true
end

def file_json_compare
  scene_json_file = "#{$bs_folder}\\#{CAMERA2_SCENES_JSON}"
  begin
    scene_json_data = json_read(scene_json_file)
    return false unless $scene_json == scene_json_data
  rescue
  end
  cameras_dir = "#{$bs_folder}\\#{CAMERA2_CAMERAS_DIR}\\*.json".gsub(/\\/,"/")
  cameras_json_data = []
  Dir.glob(cameras_dir) do |json_file|
    new_file = true
    $cameras_json.each do |camera|
      if camera[CAMERA_NAME] == File.basename(json_file, ".*")
        begin
          return false unless json_read(json_file) == camera[CAMERA_JSON]
        rescue
        end
        new_file = false
        break
      end
    end
    return false if new_file
  end
  return true
end

def file_timestamp_reset
  $scene_json_mtime = Time.now
  $cameras_json_mtime.each do |json_file, mtime|
    $cameras_json_mtime[json_file] = Time.now
  end
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

def amount_trackbar_set(edit_control, trackBar_control, min, max, split)
  return if $change_flag
  $change_flag = true
  base = base_cal(min, max, split)
  if edit_control.text.strip == ""
    edit_control.text = "%.15g"%rounding(base ** trackBar_control.rangeMin.to_f / 100.0, 3)
    trackBar_control.position = trackBar_control.rangeMin
  else
    if edit_control.text.to_f < base ** trackBar_control.rangeMin.to_f / 100.0
      edit_control.text = "%.15g"%rounding(base ** trackBar_control.rangeMin.to_f / 100.0, 3)
    elsif edit_control.text.to_f > base ** trackBar_control.rangeMax.to_f / 100.0
      edit_control.text = "%.15g"%rounding(base ** trackBar_control.rangeMax.to_f / 100.0, 3)
    end
    trackBar_control.position = (Math.log10(edit_control.text.to_f * 100.0) / Math.log10(base)).to_i
  end
  $amount_track_bar_position[trackBar_control] = [trackBar_control.position,edit_control]
  $change_flag = false
end

def amount_edit_set(min, max, split)
  return if $change_flag
  $change_flag = true
  base = base_cal(min, max, split)
  $amount_track_bar_position.each do |control,value|
    position = value[0]
    edit_control = value[1]
    if control.position != position
      control.position = (control.position - (control.position % control.linesize))
      $amount_track_bar_position[control] = [control.position,edit_control]
      edit_control.text = "%.15g"%rounding(base ** control.position.to_f / 100.0, 3)
    end
  end
  $change_flag = false
end

def base_cal(min, max, split)
#pos
#amount   = 0.01    - 1
#           (1/100) - (100/100)
#trackbar = 0       - 20 (21split)
#
#x^0  = 1(Fixed) =>  1*0.01 = 0.01
#x^20 = 100      =>  100*0.01 = 1
#logx(100) = 20
#log10(100)/log10(x) = 20
#log10(x) = log10(100)/20
#x = 10^(log10(100)/20)
#x = 1.258925412
return 10**(Math.log10(max / min) / (split))
end

def rounding(num, point)
  point = 10 ** point
  return (num * point).round.to_f / point.to_f
end

def control_disable(control_list, ref = true)
  control_list.each do |control|
    if control.class == VREdit
      control.readonly = true
    else
      control.style |= WStyle::WS_DISABLED
    end
  end
  refresh if ref
end

def control_enable(control_list, ref = true)
  control_list.each do |control|
    if control.class == VREdit
      control.readonly = false
    else
      control.style &= ~WStyle::WS_DISABLED
    end
  end
  refresh if ref
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
  cameras_dir = "#{$bs_folder}\\#{CAMERA2_CAMERAS_DIR}\\*.json".gsub(/\\/,"/")
  Dir.glob(cameras_dir) do |json_file|
    camera_file_name = File.basename(json_file, ".*")
    delete_flag = true
    $cameras_json.each do |camera|
      if camera[CAMERA_NAME] == camera_file_name
        delete_flag = false
        break
      end
    end
    if delete_flag
      begin
        File.delete json_file if File.exist? json_file
      rescue
        fail_list.push json_file
      end
    end
  end
  fail_list.each do |json_file|
    sleep 1
    begin
      File.delete json_file if File.exist? json_file
    rescue
      $main_form.messageBox("#{json_file}\r\n#{JSON_FILE_SAVE_DEL_ERR_MES}",
        JSON_FILE_SAVE_DEL_ERR_TITLE, WConst::MB_ICONERROR | WConst::MB_OK)
    end
  end
  $cameras_json.each do |camera|
    next unless camera[CAMERA_CHANGE]
    all_ok = true
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

def all_json_file_save
  ext_list = [["JSON(*.json)", "*.json"], ["all(*.*)", "*.*"]]
  fn = SWin::CommonDialog::saveFilename($main_form, ext_list, 0x2, ALL_JSON_FILE_SAVE_TITLE, '*.json', $setting_folder)
  return unless fn
  all_json = {}
  all_json["scene_json"] = $scene_json
  all_json["cameras_json"] = $cameras_json
  File.open(fn, 'w') do |file|
    JSON.pretty_generate(all_json).each do |line|
      file.puts line
    end
  end
end

def all_json_file_load
  ext_list = [["JSON(*.json)", "*.json"], ["all(*.*)", "*.*"]]
  fn = SWin::CommonDialog::openFilename($main_form, ext_list, 0x1004, ALL_JSON_FILE_LOAD_TITLE, '*.json', $setting_folder)
  return false unless fn
  all_json = {}
  begin
    all_json = json_read(fn)
  rescue
  end
  if all_json["scene_json"] && all_json["cameras_json"]
    $scene_json = all_json["scene_json"]
    $scene_json_change = true
    $cameras_json = all_json["cameras_json"]
    $cameras_json.each do |camera|
      camera[CAMERA_CHANGE] = true
    end
    return true
  end
  $main_form.messageBox(ALL_JSON_FILE_LOAD_ERR_MES, ALL_JSON_FILE_LOAD_ERR_TITLE, WConst::MB_ICONWARNING | WConst::MB_OK)
  return false
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

def dlg_move(dlg_self)
  m = $main_windowrect
  d = dlg_self.windowrect
  cx = m[0] + (m[2] / 2)
  cy = m[1] + (m[3] / 2)
  x = cx - (d[2] / 2)
  y = cy - (d[3] / 2)
  dlg_self.move(x, y, d[2], d[3])
end

def wsh_run(url)
  begin
    WINSHELL.Run(%Q!#{url}!)
  rescue Exception => e
    $main_form.messageBox("#{MAIN_WSH_ERR}\r\n#{e.inspect}", MAIN_WSH_ERR_TITLE, 16)
  end
end