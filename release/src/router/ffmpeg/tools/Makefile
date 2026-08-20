# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
TOOLS = enum_options qt-faststart trasher uncoded_frame
TOOLS-$(CONFIG_LIBMYSOFA) += sofa2wavs
TOOLS-$(CONFIG_ZLIB) += cws2fws

tools/target_dec_%_fuzzer.o: tools/target_dec_fuzzer.c
	$(COMPILE_C) -DFFMPEG_DECODER=$*

tools/target_bsf_%_fuzzer.o: tools/target_bsf_fuzzer.c
	$(COMPILE_C) -DFFMPEG_BSF=$*

tools/target_dem_%_fuzzer.o: tools/target_dem_fuzzer.c
	$(COMPILE_C) -DFFMPEG_DEMUXER=$* -DIO_FLAT=0

tools/target_dem_fuzzer.o: tools/target_dem_fuzzer.c
	$(COMPILE_C) -DIO_FLAT=1

tools/target_io_dem_fuzzer.o: tools/target_dem_fuzzer.c
	$(COMPILE_C) -DIO_FLAT=0

OUTDIRS += tools

clean::
	$(RM) $(CLEANSUFFIXES:%=tools/%)

-include $(wildcard tools/*.d)
