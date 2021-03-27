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

class Modaldlg_setting                                              ##__BY_FDVR

  def self_created
    @edit_bs_folder.text = $bs_folder if $bs_folder
    @checkBox_japanese.check(true) if $language == "japanese"
    @checkBox_tooltip.check($tooltip_enabled) if
    @edit_update_check.text = $json_update_check_time
    @edit_send_time.text = $key_send_time
    @edit_wait_time.text = $autoit_wait_time
    dlg_move(self)
    if $tooltip_enabled
      $main_form.tooltip.addTool(@edit_bs_folder, TOOLTIP_BS_FOLDER)
      $main_form.tooltip.addTool(@checkBox_tooltip, TOOLTIP_TOOLTIP)
      $main_form.tooltip.addTool(@checkBox_japanese, TOOLTIP_JAPANESE)
      $main_form.tooltip.addTool(@edit_update_check, TOOLTIP_UPDATE_CHECK)
      $main_form.tooltip.addTool(@edit_send_time, TOOLTIP_SEND_TIME)
      $main_form.tooltip.addTool(@edit_wait_time, TOOLTIP_WAIT_TIME)
    end
  end

  def button_bs_folder_open_clicked
    unless File.directory?(defalut = @edit_bs_folder.text.strip)
      defalut = nil
      DEFAULT_BS_FOLDER.each do |folder|
        if File.directory?(folder)
          defalut = folder
          break
        end
      end
    end
    folder = SWin::CommonDialog::selectDirectory(self,"BeatSaber Install Folder",defalut,1)
    return unless folder
    return unless File.exist?(folder)
    @edit_bs_folder.text = folder
  end

  def button_cancel_clicked
    close(false)
  end

  def button_ok_clicked
    if File.directory?(@edit_bs_folder.text.strip)
      $bs_folder = @edit_bs_folder.text.strip
    else
      if messageBox("'#{@edit_bs_folder.text.strip}' #{MODALDLG_SETTING_OK_BTN_NO_DIR_MES}",
        MODALDLG_SETTING_OK_BTN_NO_DIR_TITLE, WConst::MB_ICONQUESTION | WConst::MB_YESNO) == VRDialogComponent::IDYES
        return
      else
        close(false)
        return
      end
    end
    if @checkBox_japanese.checked?
      $language  = "japanese"
    else
      $language  = "english"
    end
    if @checkBox_tooltip.checked?
      $tooltip_enabled = true
    else
      $tooltip_enabled = false
    end
    $json_update_check_time = @edit_update_check.text.to_i
    $key_send_time = @edit_send_time.text.to_i
    $autoit_wait_time = @edit_wait_time.text.to_i
    setting_save
    close(true)
  end

end                                                                 ##__BY_FDVR

class Modaldlg_custom_scenes                                              ##__BY_FDVR

  def self_created
    dlg_move(self)
    if $tooltip_enabled
      $main_form.tooltip.addTool(@listBox_custom_scenes, TOOLTIP_CUSTOM_SCENES_LIST)
      $main_form.tooltip.addTool(@edit_scene, TOOLTIP_CUSTOM_SCENES_SCENE)
      $main_form.tooltip.addTool(@edit_bind, TOOLTIP_CUSTOM_SCENES_KEY)
      $main_form.tooltip.addTool(@listBox_camera, TOOLTIP_CUSTOM_SCENES_CAMERA)
      $main_form.tooltip.addTool(@button_add, TOOLTIP_CUSTOM_SCENES_ADD)
      $main_form.tooltip.addTool(@button_del, TOOLTIP_CUSTOM_SCENES_DEL)
      $main_form.tooltip.addTool(@button_ok, TOOLTIP_CUSTOM_SCENES_OK)
      $main_form.tooltip.addTool(@button_cancel, TOOLTIP_CUSTOM_SCENES_CANCEL)
    end
    @select_idx = nil
    @listBox_custom_scenes.sendMessage(0x192, 1,[20].pack('l*'))
    @customScenes = []
    if scenes = $scene_json["customScenes"]
      scenes.each do |scene, cameras|
        key_bind = ""
        if bindings = $scene_json["customSceneBindings"]
          bindings.each do |bind_name, scene_name|
            key_bind = bind_name if scene_name == scene
          end
        end
        @customScenes.push [scene, cameras, key_bind]
      end
    end
    scene_listbox_set
    @camera_list = []
    $cameras_json.each do |camera|
      @camera_list.push camera[CAMERA_NAME]
    end
    @listBox_camera.setListStrings(@camera_list)
    scene_setting_set
  end

  def scene_listbox_set(idx = 0)
    scene_list = []
    @customScenes.each do |scene_setting|
      scene_list.push "#{scene_setting[2]}\t#{scene_setting[0]}"
    end
    @listBox_custom_scenes.setListStrings(scene_list)
    if scene_list.size > 0
      @listBox_custom_scenes.select(idx)
      @select_idx = idx
    end
  end

  def scene_setting_set
    control_list = [@edit_scene, @static_scene, @static_keybind, @edit_bind, @static_camera, @listBox_camera]
    if (idx = @listBox_custom_scenes.selectedString) > -1
      control_enable(control_list)
      scene, cameras, key_bind = @customScenes[idx]
      @edit_scene.text = scene
      @edit_bind.text = key_bind
      @camera_list.each_with_index do |camera_check, camera_idx|
        if cameras.index(camera_check)
          @listBox_camera.sendMessage(WMsg::LB_SETSEL, 1, camera_idx)
        else
          @listBox_camera.sendMessage(WMsg::LB_SETSEL, 0, camera_idx)
        end
      end
    else
      @edit_scene.text = ""
      @edit_bind.text = ""
      @camera_list.size.times do |camera_idx|
        @listBox_camera.sendMessage(WMsg::LB_SETSEL, 0, camera_idx)
      end
      control_disable(control_list)
    end
  end

  def setting_set
    if @select_idx
      err = nil
      @customScenes.each_with_index do |camera_setting, idx|
        next if idx == @select_idx
        if camera_setting[0] == @edit_scene.text.strip
          err = "Scene"
          break
        end
        if camera_setting[2] == @edit_bind.text.strip && @edit_bind.text.strip != ""
          err = "Key bind"
          break
        end
      end
      if err
        messageBox("#{err} #{MODALDLG_CUSTOM_SCENES_ERR_MES}", MODALDLG_CUSTOM_SCENES_ERR_TITLE, WConst::MB_ICONWARNING | WConst::MB_OK)
        return false
      end
      cameras = []
      @listBox_camera.countStrings.times do |camera_idx|
        cameras.push @listBox_camera.getTextOf(camera_idx) unless @listBox_camera.sendMessage(WMsg::LB_GETSEL,camera_idx,0) == 0
      end
      @customScenes[@select_idx] = [@edit_scene.text.strip, cameras, @edit_bind.text.strip]
    end
    return true
  end

  def edit_scene_changed
    if rename_text = character_check(self,/[^ -~]/,@edit_scene.text)
      @edit_scene.text = rename_text
    end
  end

  def edit_bind_changed
    if rename_text = character_check(self,/[^ -~]/,@edit_bind.text)
      @edit_bind.text = rename_text
    end
  end

  def listBox_custom_scenes_selchanged
    if (idx = @listBox_custom_scenes.selectedString) > -1
      unless setting_set
        @listBox_custom_scenes.select(@select_idx)
        return
      end
      @select_idx = idx
      scene_listbox_set(idx)
      scene_setting_set
    end
  end

  def button_add_clicked
    number = 1
    scene_name = ""
    ok = true
    while (ok) do
      scene_name = "NewScene#{number}"
      @customScenes.each do |scene_setting|
        ok = false if scene_setting[0] == scene_name
      end
      if ok
        break
      else
        number += 1
        ok = true
      end
    end
    @customScenes.push [scene_name, [], ""]
    scene_listbox_set(@customScenes.size - 1)
    scene_setting_set
  end

  def button_del_clicked
    if @select_idx
      @customScenes.delete_at(@select_idx)
      @select_idx = @customScenes.size - 1 if @select_idx >= @customScenes.size
      @select_idx = nil if @customScenes.size == 0
      scene_listbox_set(@select_idx)
      scene_setting_set
    end
  end

  def button_cancel_clicked
    close(false)
  end

  def button_ok_clicked
    return unless setting_set
    $scene_json["customScenes"] = {} unless $scene_json["customScenes"]
    $scene_json["customSceneBindings"] = {} unless $scene_json["customSceneBindings"]
    @customScenes.each do |scene_setting|
      $scene_json["customScenes"][scene_setting[0]] = scene_setting[1]
      if scene_setting[2] == ""
        $scene_json["customSceneBindings"].each do |bind, scene|
          $scene_json["customSceneBindings"].delete(bind) if scene == scene_setting[0]
        end
      else
        $scene_json["customSceneBindings"][scene_setting[2]] = scene_setting[0]
      end
    end
    $scene_json_change = true
    close(true)
  end

end