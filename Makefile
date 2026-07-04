# Makefile cho thư mục AES - Support nhiều testbench modules
IV = iverilog
VVP = vvp
VIEW = gtkwave

FLAGS = -g2012

# Source files chung
SRC_COMMON = aes_decipher_top.v

# Testbench riêng biệt
TB_CIPHER = testbench/tb_cipher.sv
TB_CIPHER_INV = testbench/tb_decipher.sv

# Output files
CIPHER_OUT = sim_cipher.out
CIPHER_INV_OUT = sim_cipher_inv.out

.PHONY: all compile sim sim_cipher sim_cipher_inv wave wave_cipher wave_cipher_inv clean help

help:
	@echo "Available targets:"
	@echo "  all              - Compile and run all tests"
	@echo "  sim              - Run all simulations"
	@echo "  sim_cipher       - Run cipher encryption test"
	@echo "  sim_cipher_inv   - Run cipher decryption test"
	@echo "  wave             - Open all waveforms"
	@echo "  wave_cipher      - Open waveform for cipher test"
	@echo "  wave_cipher_inv  - Open waveform for decryption test"
	@echo "  clean            - Remove generated files"

all: compile sim

compile: $(CIPHER_OUT) $(CIPHER_INV_OUT)

# Biên dịch cipher (encryption)
$(CIPHER_OUT): $(SRC_COMMON) $(TB_CIPHER)
	$(IV) $(FLAGS) -o $(CIPHER_OUT) $(SRC_COMMON) $(TB_CIPHER)

# Biên dịch cipher_inv (decryption)
$(CIPHER_INV_OUT): $(SRC_COMMON) $(TB_CIPHER_INV)
	$(IV) $(FLAGS) -o $(CIPHER_INV_OUT) $(SRC_COMMON) $(TB_CIPHER_INV)

# Chạy tất cả simulations
sim: sim_cipher sim_cipher_inv

# Chạy simulation cipher
sim_cipher: $(CIPHER_OUT)
	$(VVP) $(CIPHER_OUT)
	@echo "✓ Cipher test completed"

# Chạy simulation cipher_inv
sim_cipher_inv: $(CIPHER_INV_OUT)
	$(VVP) $(CIPHER_INV_OUT)
	@echo "✓ Cipher_inv test completed"

# Mở waveforms
wave: wave_cipher wave_cipher_inv

wave_cipher:
	@if [ -f "cipher_wave.vcd" ]; then $(VIEW) cipher_wave.vcd & else echo "File cipher_wave.vcd not found"; fi

wave_cipher_inv:
	@if [ -f "cipher_inv_wave.vcd" ]; then $(VIEW) cipher_inv_wave.vcd & else echo "File cipher_inv_wave.vcd not found"; fi

clean:
	rm -f *.out *.vcd
	@echo "Cleaned up generated files"