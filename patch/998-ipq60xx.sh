#!/bin/sh
#uci set luci.main.mediaurlbase='/luci-static/bootstrap'
#uci commit luci

sed -i '/passwall/d' /etc/apk/repositories.d/distfeeds.list
sed -i '/nss/d' /etc/apk/repositories.d/distfeeds.list
sed -i '/sqm/d' /etc/apk/repositories.d/distfeeds.list
sed -i '/video/d' /etc/apk/repositories.d/distfeeds.list
sed -i '/qualcommax/d' /etc/apk/repositories.d/distfeeds.list
sed -i 's#downloads.immortalwrt.org#mirrors.vsean.net/openwrt#g' /etc/apk/repositories.d/distfeeds.list
sed -i '$a https://mirrors.vsean.net/openwrt/releases/25.12.1/targets/qualcommax/ipq60xx/kmods/6.12.94-1-cc8a6bc694108a2afcd04d06958f056f/packages.adb' /etc/apk/repositories.d/distfeeds.list
sed -i '$a https://mirrors.vsean.net/openwrt/releases/25.12.1/targets/qualcommax/ipq60xx/packages/packages.adb' /etc/apk/repositories.d/distfeeds.list

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''


# wifi设置
uci set wireless.default_radio0.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')-5G
uci set wireless.default_radio1.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')
if uci -q get wireless.default_radio2 >/dev/null; then
    uci set wireless.default_radio2.ssid=WiFi-$(cat /sys/class/ieee80211/phy0/macaddress|awk -F ":" '{print $5""$6 }' | tr 'a-z' 'A-Z')-5G2
    uci set wireless.radio0.channel='149'
    uci set wireless.default_radio2.encryption='sae-mixed'
    uci set wireless.default_radio2.key='123456qwerty'
fi
#uci set wireless.radio0.txpower='20'
uci set wireless.default_radio0.encryption='sae-mixed'
uci set wireless.default_radio1.encryption='sae-mixed'
uci set wireless.default_radio0.key='123456qwerty'
uci set wireless.default_radio1.key='123456qwerty'
uci commit wireless
#uci set network.usbwan=interface
#uci set network.usbwan.proto='dhcp'
#uci set network.usbwan.device='eth0'


uci commit dhcp
uci commit network
uci commit wireless
uci commit
#不用重启network，源码自带
exit 0
