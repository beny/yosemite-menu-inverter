def sudo_needed?(filename)
  `ls -l #{filename} | awk '{ print $3 }'`.strip == "root"
end

def sudo(command)
  system "sudo #{command}"
end

def relaunch(app)
  system %{killall #{app} && open /Applications/#{app}.app}
end

# Dropbox
if File.directory? "/Applications/Dropbox.app"
  %w{busy-lep busy2-lep busy3-lep busy4-lep
     idle-lep
     pause-lep x-lep
     logo-lep}.each do |suffix|
    prefix = "/Applications/Dropbox.app/Contents/Resources/dropboxstatus"
    img = "#{prefix}-#{suffix}.tiff"
    system "convert -negate #{img} #{img}"

    if not $?.success?
      abort "    try: brew install imagemagick --with-libtiff"
    end

    inv = "#{prefix}-#{suffix}-inv.tiff"
    system "convert -negate #{inv} #{inv}"
  end
end
relaunch "Dropbox"

# Window Magnet
base_path = "/Applications/Window\\ Magnet.app/Contents/Resources/"
origin_dark = base_path + "StatusIcon.tiff"
origin_light = base_path + "StatusIconClicked.tiff"
tmp = base_path << "StatusIcon.tmp"

sudo "mv #{origin_dark} #{tmp}"
sudo "mv #{origin_light} #{origin_dark}"
sudo "mv #{tmp} #{origin_light}"
relaunch "Window\\ Magnet"

# BitTorrent Sync
`ls /Applications/BitTorrent\\ Sync.app/Contents/Resources/trayIcon_*`.split("\n").each do |filename|
  `convert -negate "#{filename}" "#{filename}"`
end
relaunch "BitTorrent\\ Sync"

# Radium
base_path = "/Applications/Radium.app/Contents/Resources/"
%w{menubar_icon_busy_1 menubar_icon_busy_2 menubar_icon_busy_3
  menubar_icon_busy_4 menubar_icon_busy_5 menubar_icon_busy_6
  menubar_icon_disabled menubar_icon_pressed menubar_icon_regular
  menubar_icon_success}.each do |filename|
  full_filename = base_path + filename + ".tiff"
  `convert -negate "#{full_filename}" "#{full_filename}"`
end
relaunch "Radium"

# 1Password

# App Store version requires sudo, please submit code to detect if sudo is
# needed
## root = "/Applications/1Password.app/Contents/Library/LoginItems/2BUA8C4S2C.com.agilebits.onepassword-osx-helper.app/Contents/Resources"
## img = "#{root}/menubar-icon.tiff"
## inv = "#{root}/menubar-selected-graphite.tiff"
## TODO copy graphite one over the default one as it looks correct
## system "sudo convert -negate #{img} #{img}"
