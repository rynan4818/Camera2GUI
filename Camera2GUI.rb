#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'

#Set 'EXE_DIR' directly at runtime  直接実行時にEXE_DIRを設定する
EXE_DIR = (File.dirname(File.expand_path($0)).sub(/\/$/,'') + '/').gsub(/\//,'\\') unless defined?(EXE_DIR)

#Predefined Constants  設定済み定数
#EXE_DIR ****** Folder with EXE files[It ends with '\']  EXEファイルのあるディレクトリ[末尾は\]
#MAIN_RB ****** Main ruby script file name  メインのrubyスクリプトファイル名
#ERR_LOG ****** Error log file name  エラーログファイル名

SETTING_FILE = EXE_DIR + "setting.json"

require 'rubygems'
require 'json'
require 'utility'
require 'main_sub'

require 'vr/vruby'
require '_frm_Camera2GUI'

class Modaldlg_setting                                              ##__BY_FDVR

  def self_created

  end
end                                                                 ##__BY_FDVR

class Form_main                                                     ##__BY_FDVR

  class TabPanel_main                                               ##__BY_FDVR

    class Panel0                                                    ##__BY_FDVR

    end                                                             ##__BY_FDVR

    class Panel1                                                    ##__BY_FDVR
    
      def edit_camera_name_changed
      
      end
    
      def comboBox_camera_type_selchanged
      
      end

    end                                                             ##__BY_FDVR

    class Panel2                                                    ##__BY_FDVR

    end                                                             ##__BY_FDVR

    class Panel3                                                    ##__BY_FDVR

    end                                                             ##__BY_FDVR

    class Panel4                                                    ##__BY_FDVR

    end                                                             ##__BY_FDVR

    class Panel5                                                    ##__BY_FDVR

      class Panel_view_rect                                         ##__BY_FDVR

      end                                                           ##__BY_FDVR

      class Panel_target_rot                                        ##__BY_FDVR

      end                                                           ##__BY_FDVR

      class Panel_target_pos                                        ##__BY_FDVR

      end                                                           ##__BY_FDVR

    end                                                             ##__BY_FDVR

  end                                                               ##__BY_FDVR

  def self_created

  end
  
  def button_add_clicked
  
  end
  
  def button_del_clicked
  
  end

  def button_reflection_clicked
  
  end

  def button_up_clicked
  
  end

  def button_down_clicked
  
  end

  def listBox_camera_selchanged
  
  end

  
end                                                                 ##__BY_FDVR


VRLocalScreen.start Form_main
