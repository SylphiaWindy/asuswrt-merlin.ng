# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
romfs_dir = $(ROOTDIR)/romfs

romfs_dirs = etc/wifi
	
romfs:
	$(ROMFSINST) /etc/wapp_ap.conf
	$(ROMFSINST) /etc/wapp_ap_ra0_default.conf
	$(ROMFSINST) /etc/wapp_ap_ra0.conf
	$(ROMFSINST) /etc/wapp_ap_ra1.conf
	$(ROMFSINST) /etc/wapp_ap_rai0_default.conf
	$(ROMFSINST) /etc/wapp_ap_rai0.conf
	$(ROMFSINST) /etc/wapp_ap_rai1.conf
	 
#PF5
	$(ROMFSINST) /etc/wifi-abgn-logo_270x73.png  
	$(ROMFSINST) /etc/icon_blue_eng_default.png
	$(ROMFSINST) /etc/icon_blue_zxx_default.png
	$(ROMFSINST) /etc/icon_blue_eng.png
	$(ROMFSINST) /etc/icon_blue_zxx.png
	$(ROMFSINST) /etc/icon_green_eng_default.png
	$(ROMFSINST) /etc/icon_green_zxx_default.png
	$(ROMFSINST) /etc/icon_green_eng.png
	$(ROMFSINST) /etc/icon_green_zxx.png
	$(ROMFSINST) /etc/icon_orange_eng_default.png
	$(ROMFSINST) /etc/icon_orange_zxx_default.png
	$(ROMFSINST) /etc/icon_orange_eng.png
	$(ROMFSINST) /etc/icon_orange_zxx.png
	$(ROMFSINST) /etc/icon_red_eng_default.png
	$(ROMFSINST) /etc/icon_red_zxx_default.png
	$(ROMFSINST) /etc/icon_red_eng.png
	$(ROMFSINST) /etc/icon_red_zxx.png
