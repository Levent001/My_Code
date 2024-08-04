.PHONY:com sim cov clean debug

OUTPUT = simv
ALL_DEFINE = +define+DUMP_VPD #加入一个宏定义：名字叫DUMP_VPD,但是没用到

#Code coverage command
CM = -cm line+cond+fsm+branch+tgl #导出语句覆盖率、条件覆盖率、状态机覆盖率、分支覆盖率、翻转覆盖率
CM_NAME = -cm_name $(OUTPUT)
CMDIR = -cm_dir ./$(OUTPUT).vbd

#vpd file name
VPD_NAME = +vpdfile+$(OUTPUT).vpd #因为此处不用是vpd文件查看波形，所以这一段也没用

#Compile command
#VCS = vcs +v2k -timescale=1ns/1ns
#v2k支持2001年之后的语法 对原本定义的timescale重新定义
#fsbd 支持fsdb导出（重点）
#debug_all 支持内部debug信息的打印
#sverilog（重点）支持system Verilog语法
VCS = vcs +v2k -override_timescale=1ns/100ps    \
  	  -full64									\
	  -fsdb    									\
	  -debug_all								\
	  -sverilog									\
	  +nospecify								\
	  +vcs+flush+all							\
	  $(CM)										\
	  $(CM_NAME)								\
	  $(CM_DIR)									\
	  $(ALL_DEFINE)								\
	  $(VPD_NAME)								\
	  -o $(OUTPUT)								\
	  -l compile.log

#simulation command
SIM = ./$(OUTPUT)			 	 \
	  +ntb_random_seed_automatic \
	  $(CM) $(CM_NAME) $(CM_DIR) \
	  $(VPD_NAME)                \
	  $(ALL_DEFINE)	\
	  -l $(OUTPUT).log

com:
	$(VCS) -f file_list.f

sim:
	$(SIM)

# Show the coverage
cov:
	dve -covdir *vdb &

debug:
	dve -vpd $(OUTPUT).vpd &

#Start clean
clean:
	rm -rf ./csrc *.daidir ./csrc \
	*.log *.vpd *.vdb simv* *.key \
	*race.out* novas* verdi* *fsdb apb2apb_async


 
