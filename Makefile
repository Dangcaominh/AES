# Makefile cho thư mục AES
# Trình biên dịch và phần mềm xem sóng
IV = iverilog
VVP = vvp
VIEW = gtkwave

# Sử dụng cờ -g2012 để support IEEE 1800-2012 SystemVerilog
FLAGS = -g2012 

# Cấu hình file
SRC = testbench/aes_testbench.sv aes_top.v
OUT = sim_aes.out
WAVE = aes_wave.vcd

.PHONY: all compile sim wave clean

# Mặc định chạy cả biên dịch, mô phỏng
all: compile sim

compile: $(OUT)

# Lệnh biên dịch mã RTL bằng Icarus Verilog
$(OUT): $(SRC)
	$(IV) $(FLAGS) -o $(OUT) $(SRC)

# Lệnh chạy mô phỏng bằng VVP (nó sẽ sinh ra $(WAVE) nếu testbench có $dumpvars)
sim: $(OUT)
	$(VVP) $(OUT)

# Mở biểu đồ sóng bằng GTKWave
wave: $(WAVE)
	$(VIEW) $(WAVE) &

# Xóa các file build tạm thời
clean:
	rm -f *.out *.vcd