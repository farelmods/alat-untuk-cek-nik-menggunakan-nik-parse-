#!/data/data/com.termux/files/usr/bin/python3
# NIK Checker Tool - Python Version
# Simpan sebagai: nikchecker.py

import os
import json
import subprocess
import sys

def install_nik_parse():
    """Install nik-parse jika belum ada"""
    print("🔧 Menginstall nik-parse...")
    try:
        subprocess.run(["npm", "i", "nik-parse", "-g"], check=True)
        print("✅ nik-parse berhasil diinstall!")
        return True
    except subprocess.CalledProcessError:
        print("❌ Gagal menginstall nik-parse")
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

def clear_screen():
    """Clear terminal screen"""
    os.system('clear' if os.name == 'posix' else 'cls')

def main():
    clear_screen()
    
    print("╔══════════════════════════════════════╗")
    print("║        NIK CHECKER TOOL v1.0         ║")
    print("║      Termux Edition - by User        ║")
    print("╚══════════════════════════════════════╝")
    print()
    
    # Cek nik-parse
    if not check_nik_parse():
        print("📦 nik-parse belum terinstall!")
        if input("Install sekarang? (y/n): ").lower() == 'y':
            if not install_nik_parse():
                sys.exit(1)
        else:
            print("❌ Tool tidak dapat berjalan tanpa nik-parse")
            sys.exit(1)
    
    while True:
        clear_screen()
        print("""
    ╔══════════════════════════════════════╗
    ║          MENU UTAMA NIK CHECKER      ║
    ╠══════════════════════════════════════╣
    ║ 1. Cek NIK                           ║
    ║ 2. Multi Check (beberapa NIK)       ║
    ║ 3. Info Tool                         ║
    ║ 4. Keluar                            ║
    ╚══════════════════════════════════════╝
        """)
        
        choice = input("Pilih menu [1-4]: ")
        
        if choice == "1":
            check_single_nik()
        elif choice == "2":
            check_multiple_nik()
        elif choice == "3":
            show_info()
        elif choice == "4":
            print("\n👋 Terima kasih telah menggunakan NIK Checker!")
            break
        else:
            print("❌ Pilihan tidak valid!")
        
        input("\nTekan Enter untuk melanjutkan...")

def check_single_nik():
    """Check single NIK"""
    clear_screen()
    print("""
    ╔══════════════════════════════════════╗
    ║            CEK SINGLE NIK            ║
    ╚══════════════════════════════════════╝
    """)
    
    nik = input("Masukkan NIK (16 digit): ").strip()
    
    if not nik.isdigit() or len(nik) != 16:
        print("❌ Format NIK salah! Harus 16 digit angka")
        return
    
    print(f"\n🔍 Memproses NIK: {nik}")
    print("═" * 40)
    
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
            print(f"✅ {data['pesan']}")
            print(f"\n📋 HASIL ANALISIS:")
            print(f"   NIK        : {data['data']['nik']}")
            print(f"   Jenis Kelamin : {data['data']['kelamin']}")
            print(f"   Tanggal Lahir : {data['data']['lahir']}")
            print(f"   Provinsi      : {data['data']['provinsi']}")
            print(f"   Kabupaten     : {data['data']['kotakab']}")
            print(f"   Kecamatan     : {data['data']['kecamatan']}")
            
            print(f"\n📊 INFORMASI TAMBAHAN:")
            print(f"   Kode Pos      : {data['data']['tambahan']['kodepos']}")
            print(f"   Hari/Tanggal  : {data['data']['tambahan']['pasaran']}")
            print(f"   Usia          : {data['data']['tambahan']['usia']}")
            print(f"   Ultah         : {data['data']['tambahan']['ultah']}")
            print(f"   Zodiak        : {data['data']['tambahan']['zodiak']}")
        else:
            print(f"❌ {data['pesan']}")
            
    except subprocess.CalledProcessError as e:
        print(f"❌ Error: {e.stderr}")
    except json.JSONDecodeError:
        print("❌ Gagal memparse output")
    except Exception as e:
        print(f"❌ Terjadi error: {str(e)}")

def check_multiple_nik():
    """Check multiple NIKs"""
    clear_screen()
    print("""
    ╔══════════════════════════════════════╗
    ║           CEK MULTIPLE NIK           ║
    ╚══════════════════════════════════════╝
    """)
    
    print("Masukkan NIK (pisahkan dengan koma/spasi/baris baru)")
    print("Ketik 'selesai' di baris baru untuk mengakhiri")
    print("-" * 40)
    
    nik_list = []
    while True:
        nik = input().strip()
        if nik.lower() == 'selesai':
            break
        if nik:
            # Pisahkan NIK yang dipisahkan koma/spasi
            niks = nik.replace(',', ' ').split()
            for n in niks:
                if n.isdigit() and len(n) == 16:
                    nik_list.append(n)
                else:
                    print(f"⚠  NIK {n} tidak valid (dilewati)")
    
    if not nik_list:
        print("❌ Tidak ada NIK valid yang dimasukkan")
        return
    
    print(f"\n📊 Akan memproses {len(nik_list)} NIK...")
    print("═" * 40)
    
    for i, nik in enumerate(nik_list, 1):
        print(f"\n[{i}/{len(nik_list)}] NIK: {nik}")
        try:
            result = subprocess.run(
                ["nik-parse", "--nik", nik],
                capture_output=True,
                text=True,
                check=True
            )
            data = json.loads(result.stdout)
            if data['status'] == 'success':
                print(f"   ✅ {data['data']['kelamin']}, {data['data']['lahir']}")
                print(f"   📍 {data['data']['kecamatan']}, {data['data']['kotakab']}")
            else:
                print(f"   ❌ {data['pesan']}")
        except:
            print(f"   ❌ Gagal memproses")
    
    print("\n" + "═" * 40)
    print(f"✅ Selesai! Total diproses: {len(nik_list)} NIK")

def show_info():
    """Show tool information"""
    clear_screen()
    print("""
    ╔══════════════════════════════════════╗
    ║           INFORMASI TOOL             ║
    ╚══════════════════════════════════════╝
    
    📌 NIK CHECKER TOOL v1.0
    👨‍💻 Untuk Termux / Linux
    
    🔧 FITUR:
    - Cek NIK tunggal
    - Cek multiple NIK sekaligus
    - Validasi otomatis
    - Tampilan terstruktur
    - Informasi lengkap
    
    ⚠  PERHATIAN:
    - Tool ini hanya untuk informasi geografis
    - Tidak menampilkan nama pemilik NIK
    - Gunakan untuk keperluan legal saja
    
    📄 Data yang ditampilkan:
    • Jenis kelamin
    • Tanggal lahir
    • Lokasi (provinsi, kabupaten, kecamatan)
    • Usia & zodiak
    • Hari pasaran Jawa
    
    🔗 Dependency: nik-parse (npm package)
    """)

if __name__ == "__main__":
    main()