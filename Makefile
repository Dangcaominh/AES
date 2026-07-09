# Makefile cho thư mục AES - Support nhiều testbench modules
IV = iverilog
VVP = vvp
VIEW = gtkwave

FLAGS = -g2012

# Source files chung
SRC_COMMON = aes.v

# Testbench riêng biệt
TB_TOP = testbench/tb.sv
TB_CIPHER = testbench/tb_cipher.sv
TB_DECIPHER = testbench/tb_decipher.sv

# Output files
TOP_OUT = sim.out
CIPHER_OUT = sim_cipher.out
DECIPHER_OUT = sim_decipher.out

.PHONY: all compile sim sim_cipher sim_decipher wave wave_cipher wave_decipher clean help

help:
	@echo "Available targets:"
	@echo "  all              - Compile and run all tests"
	@echo "  sim              - Run all simulations"
	@echo "  sim_cipher       - Run cipher encryption test"
	@echo "  sim_decipher     - Run cipher decryption test"
	@echo "  wave             - Open all waveforms"
	@echo "  wave_cipher      - Open waveform for cipher test"
	@echo "  wave_decipher    - Open waveform for decryption test"
	@echo "  clean            - Remove generated files"

all: compile sim

compile: $(TOP_OUT) $(CIPHER_OUT) $(DECIPHER_OUT)

# Biên dịch cipher (encryption)
$(TOP_OUT): $(SRC_COMMON) $(TB_TOP)
	$(IV) $(FLAGS) -o $(TOP_OUT) $(SRC_COMMON) $(TB_TOP)

# Biên dịch cipher (encryption)
$(CIPHER_OUT): $(SRC_COMMON) $(TB_CIPHER)
	$(IV) $(FLAGS) -o $(CIPHER_OUT) $(SRC_COMMON) $(TB_CIPHER)

# Biên dịch cipher_inv (decryption)
$(DECIPHER_OUT): $(SRC_COMMON) $(TB_DECIPHER)
	$(IV) $(FLAGS) -o $(DECIPHER_OUT) $(SRC_COMMON) $(TB_DECIPHER)

# Chạy tất cả simulations
sim: sim_cipher sim_decipher sim_top

# Chạy simulation cipher
sim_cipher: $(CIPHER_OUT)
	$(VVP) $(CIPHER_OUT)
	@echo "✓ Cipher test completed"

# Chạy simulation cipher_inv
sim_decipher: $(DECIPHER_OUT)
	$(VVP) $(DECIPHER_OUT)
	@echo "✓ Deipher test completed"

sim_top: $(TOP_OUT)
	$(VVP) $(TOP_OUT)
	@echo "✓ Top test completed"

# Mở waveforms
wave: wave_cipher wave_decipher wave_top

wave_top:
	@if [ -f "wave.vcd" ]; then $(VIEW) wave.vcd & else echo "File wave.vcd not found"; fi

wave_cipher:
	@if [ -f "cipher_wave.vcd" ]; then $(VIEW) cipher_wave.vcd & else echo "File cipher_wave.vcd not found"; fi

wave_decipher:
	@if [ -f "decipher_wave.vcd" ]; then $(VIEW) decipher_wave.vcd & else echo "File decipher_wave.vcd not found"; fi

clean:
	rm -f *.out *.vcd
	@echo "Cleaned up generated files"