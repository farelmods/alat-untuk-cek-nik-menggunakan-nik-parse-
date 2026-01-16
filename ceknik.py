#!/data/data/com.termux/files/usr/bin/python3
# NIK Checker Tool - Python Version
# Simpan sebagai: ceknik.py

import os
import json
import subprocess
import sys
import time

# --- CONFIGURATION & COLORS ---
class Col:
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    RESET = '\033[0m'
    BOLD = '\033[1m'

# --- UTILS ---

def clear_screen():
    """Clear terminal screen"""
    os.system('clear' if os.name == 'posix' else 'cls')

def typing(text, speed=0.01, color=Col.WHITE):
    """Effect mengetik"""
    sys.stdout.write(color)
    for char in text:
        sys.stdout.write(char)
        sys.stdout.flush()
        time.sleep(speed)
    sys.stdout.write(Col.RESET + "\n")

def print_center(text, width=50, color=Col.WHITE):
    """Print text centered"""
    print(color + text.center(width) + Col.RESET)

def loading_animation(text="Processing", duration=2):
    """Animasi loading simple"""
    symbols = ['⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷']
    end_time = time.time() + duration
    i = 0
    sys.stdout.write(f"\r{Col.CYAN}{text}   ")
    while time.time() < end_time:
        sys.stdout.write(f"\b\b{symbols[i % len(symbols)]} ")
        sys.stdout.flush()
        time.sleep(0.1)
        i += 1
    sys.stdout.write(f"\r{Col.GREEN}{text} [OK]      {Col.RESET}\n")

def get_banner():
    """Returns the Indonesia ASCII Art Banner"""
    # Simple ASCII representation of Indonesia Map & Title
    return f"""{Col.RED}
  ____  _  _  ____    ___  ____  __ _  ____  _  _
 (_  _)( \\( )(  _ \\  / __)(  __)(  ( \\(_  _)( )/ )
  _)(_  )  (  )(_) )( (__  ) _) /    / _)(_  )  (
 (____)(_)\\_)(____/  \\___)(____)\\_)__)(____)(_)\\_)
{Col.WHITE}          BHINNEKA TUNGGAL IKA
{Col.GREEN}
      ,.,   .                  .
     /   ` ,.,  SUMATRA       /`\\\\    PAPUA
    '     /   ` .  KALIMANTAN |   |  .
   /     '     /`\\\\    .      |   | /`\\\\
  '           |   |  /`\\\\     '   ' |   |
    JAVA      |   | |   | SULAWESI '   '
   .----.     '   ' '   '    .
  /      \\\\   BALI/NTB/NTT   / \\\\
 '        '       .        '   '
{Col.RESET}"""

# --- LOGIC ---

def install_nik_parse():
    """Install nik-parse jika belum ada"""
    print(f"\n{Col.YELLOW}🔧 Sedang menginstall nik-parse...{Col.RESET}")
    try:
        loading_animation("Installing npm package")
        subprocess.run(["npm", "i", "nik-parse", "-g"], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print(f"{Col.GREEN}✅ nik-parse berhasil diinstall!{Col.RESET}")
        time.sleep(1)
        return True
    except subprocess.CalledProcessError:
        print(f"{Col.RED}❌ Gagal menginstall nik-parse. Pastikan nodejs terinstall.{Col.RESET}")
        return False

def check_nik_parse():
    """Cek apakah nik-parse sudah terinstall"""
    try:
        subprocess.run(["nik-parse", "--version"], 
                      stdout=subprocess.PIPE, 
                      stderr=subprocess.PIPE)
        return True
    except FileNotFoundError:
        return False

def print_boxed_result(title, data_dict):
    """Print dictionary data in a nice box"""
    width = 50
    print(f"\n{Col.CYAN}╔{'═'*width}╗")
    print(f"║{title.center(width)}║")
    print(f"╠{'═'*width}╣{Col.RESET}")
    
    for key, value in data_dict.items():
        # Handle formatting for specific keys if needed
        key_str = f" {key}"
        val_str = f"{value} "
        space = width - len(key_str) - len(val_str) - 2 # -2 for separator chars
        if space < 0: space = 0
        
        print(f"{Col.CYAN}║{Col.YELLOW}{key_str}{' ' * space}{Col.WHITE}: {val_str}{Col.CYAN}║")
        
    print(f"{Col.CYAN}╚{'═'*width}╝{Col.RESET}")

def check_single_nik():
    """Check single NIK"""
    clear_screen()
    print(get_banner())
    print(f"\n{Col.CYAN}[ MENU CEK SINGLE NIK ]{Col.RESET}")
    
    nik = input(f"{Col.YELLOW}➤ Masukkan NIK (16 digit) : {Col.WHITE}").strip()
    
    if not nik.isdigit() or len(nik) != 16:
        print(f"\n{Col.RED}❌ Format NIK salah! Harus 16 digit angka.{Col.RESET}")
        input("\nTekan Enter...")
        return
    
    loading_animation("Menganalisa Data NIK")
    
    try:
        # Jalankan nik-parse
        result = subprocess.run(
            ["nik-parse", "--nik", nik],
            capture_output=True,
            text=True,
            check=True
        )
        
        # Parse JSON output
        data = json.loads(result.stdout)
        
        if data['status'] == 'success':
            # Siapkan data untuk display
            main_info = {
                "NIK": data['data']['nik'],
                "Jenis Kelamin": data['data']['kelamin'],
                "Tanggal Lahir": data['data']['lahir'],
                "Usia": data['data']['tambahan']['usia'],
                "Zodiak": data['data']['tambahan']['zodiak']
            }

            loc_info = {
                "Provinsi": data['data']['provinsi'],
                "Kabupaten/Kota": data['data']['kotakab'],
                "Kecamatan": data['data']['kecamatan'],
                "Kode Pos": data['data']['tambahan']['kodepos']
            }

            other_info = {
                "Hari Lahir": data['data']['tambahan']['pasaran'],
                "Ulang Tahun": data['data']['tambahan']['ultah']
            }

            print_boxed_result("DATA PRIBADI", main_info)
            print_boxed_result("LOKASI", loc_info)
            print_boxed_result("LAIN-LAIN", other_info)
            
        else:
            print(f"\n{Col.RED}❌ {data['pesan']}{Col.RESET}")
            
    except subprocess.CalledProcessError as e:
        print(f"\n{Col.RED}❌ Error System: {e.stderr}{Col.RESET}")
    except json.JSONDecodeError:
        print(f"\n{Col.RED}❌ Gagal memparse output JSON{Col.RESET}")
    except Exception as e:
        print(f"\n{Col.RED}❌ Terjadi error: {str(e)}{Col.RESET}")

def check_multiple_nik():
    """Check multiple NIKs"""
    clear_screen()
    print(get_banner())
    print(f"\n{Col.CYAN}[ MENU CEK MULTIPLE NIK ]{Col.RESET}")
    
    print(f"{Col.WHITE}Masukkan NIK (pisahkan dengan koma/spasi/enter)")
    print(f"Ketik '{Col.RED}selesai{Col.WHITE}' untuk mulai memproses")
    print(f"{Col.CYAN}{'-'*40}{Col.RESET}")
    
    nik_list = []
    while True:
        try:
            line = input(f"{Col.GREEN}>> {Col.RESET}").strip()
            if line.lower() == 'selesai':
                break
            if line:
                # Pisahkan NIK
                items = line.replace(',', ' ').split()
                for n in items:
                    if n.isdigit() and len(n) == 16:
                        nik_list.append(n)
                    else:
                        print(f"{Col.YELLOW}⚠  NIK {n} invalid (skip){Col.RESET}")
        except KeyboardInterrupt:
            break

    if not nik_list:
        print(f"\n{Col.RED}❌ Tidak ada NIK valid.{Col.RESET}")
        time.sleep(1)
        return

    print(f"\n{Col.CYAN}📊 Memproses {len(nik_list)} NIK...{Col.RESET}")
    print(f"{Col.CYAN}═" * 50 + Col.RESET)
    
    for i, nik in enumerate(nik_list, 1):
        try:
            result = subprocess.run(
                ["nik-parse", "--nik", nik],
                capture_output=True, text=True, check=True
            )
            data = json.loads(result.stdout)

            prefix = f"{Col.CYAN}[{i}]{Col.RESET}"
            if data['status'] == 'success':
                d = data['data']
                usia = d.get('tambahan', {}).get('usia', '?')
                print(f"{prefix} {Col.GREEN}{nik}{Col.RESET} | {d['kelamin']} | {usia}")
                print(f"    └─ {Col.WHITE}{d['kotakab']}, {d['provinsi']}{Col.RESET}")
            else:
                print(f"{prefix} {Col.RED}{nik} - Invalid{Col.RESET}")

        except:
            print(f"{Col.RED}[{i}] {nik} - Error processing{Col.RESET}")

    print(f"{Col.CYAN}═" * 50 + Col.RESET)
    input("\nTekan Enter untuk kembali...")

def show_info():
    """Show tool information"""
    clear_screen()
    print(get_banner())
    
    info = f"""
    {Col.YELLOW}📌 INFORMASI TOOL{Col.RESET}
    {Col.WHITE}Dibuat untuk Termux (Android){Col.RESET}
    
    {Col.CYAN}FITUR:{Col.RESET}
    1. Parsing data KTP dari nomor NIK
    2. Mendeteksi Tanggal Lahir, Gender, Wilayah
    3. Cek Masal
    
    {Col.RED}DISCLAIMER:{Col.RESET}
    Tool ini hanya mengekstrak informasi yang terkandung
    dalam format NIK itu sendiri (Sesuai Rumus NIK).
    TIDAK mengambil data dari database Dukcapil/Pemerintah.
    Gunakan dengan bijak.
    """
    typing(info, speed=0.005)

def main():
    clear_screen()
    
    # Check dependencies
    if not check_nik_parse():
        print(get_banner())
        print(f"\n{Col.YELLOW}📦 Komponen 'nik-parse' belum terinstall!{Col.RESET}")
        ans = input(f"Install sekarang? ({Col.GREEN}y{Col.RESET}/{Col.RED}n{Col.RESET}): ").lower()
        if ans == 'y':
            if not install_nik_parse():
                sys.exit(1)
        else:
            print(f"{Col.RED}❌ Tool tidak dapat berjalan.{Col.RESET}")
            sys.exit(1)
    
    while True:
        clear_screen()
        print(get_banner())

        print(f"    {Col.CYAN}[1]{Col.WHITE} Cek NIK")
        print(f"    {Col.CYAN}[2]{Col.WHITE} Multi Check")
        print(f"    {Col.CYAN}[3]{Col.WHITE} Info")
        print(f"    {Col.CYAN}[4]{Col.WHITE} Keluar")
        print()

        choice = input(f"{Col.GREEN}root@termux{Col.WHITE}:~# ").strip()

        if choice == "1":
            check_single_nik()
            input(f"\n{Col.CYAN}Tekan Enter untuk kembali ke menu...{Col.RESET}")
        elif choice == "2":
            check_multiple_nik()
        elif choice == "3":
            show_info()
            input(f"\n{Col.CYAN}Tekan Enter untuk kembali ke menu...{Col.RESET}")
        elif choice == "4":
            print(f"\n{Col.YELLOW}👋 Sampai Jumpa!{Col.RESET}")
            break
        else:
            print(f"{Col.RED}❌ Pilihan tidak valid!{Col.RESET}")
            time.sleep(1)

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print(f"\n\n{Col.RED}✖ Program dihentikan paksa.{Col.RESET}")
        sys.exit(0)
