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

class Modaldlg_setting                                              ##__BY_FDVR

  def self_created
    @edit_bs_folder.text = $bs_folder if $bs_folder
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
         MODALDLG_SETTING_OK_BTN_NO_DIR_TITLE, WConst::MB_ICONQUESTION | WConst::MB_YESNO) == VRDialogComponent::IDOK
        return
      else
        close(false)
        return
      end
    end
    setting_save
    close(true)
  end

end                                                                 ##__BY_FDVR
