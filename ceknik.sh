#!/bin/bash
# NIK Checker Tool - Bash Version
# Simpan sebagai: ceknik.sh

# --- CONFIGURATION & COLORS ---
RED='\033[91m'
GREEN='\033[92m'
YELLOW='\033[93m'
BLUE='\033[94m'
MAGENTA='\033[95m'
CYAN='\033[96m'
WHITE='\033[97m'
RESET='\033[0m'
BOLD='\033[1m'

# --- UTILS ---

clear_screen() {
    clear
}

typing() {
    text="$1"
    speed="${2:-0.01}"
    echo -ne "$WHITE"
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${text:$i:1}"
        sleep "$speed"
    done
    echo -e "$RESET"
}

loading_animation() {
    text="${1:-Processing}"
    duration="${2:-2}"
    symbols=("⣾" "⣽" "⣻" "⢿" "⡿" "⣟" "⣯" "⣷")
    end=$((SECONDS + duration))

    echo -ne "\r${CYAN}${text}   "
    while [ $SECONDS -lt $end ]; do
        for s in "${symbols[@]}"; do
            echo -ne "\b\b$s "
            sleep 0.1
        done
    done
    echo -e "\r${GREEN}${text} [OK]      ${RESET}"
}

get_banner() {
    echo -e "${RED}"
    echo "  ____  _  _  ____    ___  ____  __ _  ____  _  _ "
    echo " (_  _)( \( )(  _ \  / __)(  __)(  ( \(_  _)( )/ )"
    echo "  _)(_  )  (  )(_) )( (__  ) _) /    / _)(_  )  ( "
    echo " (____)(_)\_)(____/  \___)(____)\_)__)(____)(_)\_)"
    echo -e "${WHITE}          BHINNEKA TUNGGAL IKA"
    echo -e "${GREEN}"
    echo "      ,.,   .                  ."
    echo "     /   \` ,.,  SUMATRA       /\`\\    PAPUA"
    echo "    '     /   \` .  KALIMANTAN |   |  ."
    echo "   /     '     /\`\\    .      |   | /\`\\"
    echo "  '           |   |  /\`\\     '   ' |   |"
    echo "    JAVA      |   | |   | SULAWESI '   '"
    echo "   .----.     '   ' '   '    ."
    echo "  /      \\   BALI/NTB/NTT   / \\"
    echo " '        '       .        '   '"
    echo -e "${RESET}"
}

# --- LOGIC ---

install_nik_parse() {
    echo -e "\n${YELLOW}🔧 Sedang menginstall nik-parse...${RESET}"
    loading_animation "Installing npm package" 5
    if npm install -g nik-parse > /dev/null 2>&1; then
        echo -e "${GREEN}✅ nik-parse berhasil diinstall!${RESET}"
        sleep 1
        return 0
    else
        echo -e "${RED}❌ Gagal menginstall nik-parse. Pastikan nodejs terinstall.${RESET}"
        return 1
    fi
}

check_nik_parse() {
    if command -v nik-parse >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

check_single_nik() {
    clear_screen
    get_banner
    echo -e "\n${CYAN}[ MENU CEK SINGLE NIK ]${RESET}"

    echo -ne "${YELLOW}➤ Masukkan NIK (16 digit) : ${WHITE}"
    read -r nik

    # Simple validation
    if [[ ! "$nik" =~ ^[0-9]{16}$ ]]; then
        echo -e "\n${RED}❌ Format NIK salah! Harus 16 digit angka.${RESET}"
        read -p "Tekan Enter..."
        return
    fi

    loading_animation "Menganalisa Data NIK" 2

    # Write the JS formatter to a temp file using quoted heredoc
    cat << 'EOF' > .formatter.js
const readline = require("readline");
const rl = readline.createInterface({ input: process.stdin, output: process.stdout, terminal: false });
let data = "";

rl.on("line", (line) => { data += line + "\n"; });

rl.on("close", () => {
    try {
        const res = eval("(" + data + ")");

        // Colors
        const C = {
            CYAN: "\x1b[96m", YELLOW: "\x1b[93m", WHITE: "\x1b[97m",
            RED: "\x1b[91m", GREEN: "\x1b[92m", RESET: "\x1b[0m"
        };

        if (res.status === "success") {
            const d = res.data;
            const t = d.tambahan;
            const width = 50;

            function printBox(title, items) {
                console.log(`\n${C.CYAN}╔${"═".repeat(width)}╗`);
                console.log(`║${title.padEnd(width/2 + title.length/2).padStart(width)}║`);
                console.log(`╠${"═".repeat(width)}╣${C.RESET}`);

                for (const [key, val] of Object.entries(items)) {
                    const k = ` ${key}`;
                    const v = `${val} `;
                    const space = width - k.length - v.length - 2;
                    const padding = space > 0 ? " ".repeat(space) : "";
                    console.log(`${C.CYAN}║${C.YELLOW}${k}${padding}${C.WHITE}: ${v}${C.CYAN}║`);
                }
                console.log(`${C.CYAN}╚${"═".repeat(width)}╝${C.RESET}`);
            }

            printBox("DATA PRIBADI", {
                "NIK": d.nik,
                "Jenis Kelamin": d.kelamin,
                "Tanggal Lahir": d.lahir,
                "Usia": t.usia,
                "Zodiak": t.zodiak
            });

            printBox("LOKASI", {
                "Provinsi": d.provinsi,
                "Kabupaten/Kota": d.kotakab,
                "Kecamatan": d.kecamatan,
                "Kode Pos": t.kodepos
            });

            printBox("LAIN-LAIN", {
                "Hari Lahir": t.pasaran,
                "Ulang Tahun": t.ultah
            });

        } else {
            console.log(`\n${C.RED}❌ ${res.pesan}${C.RESET}`);
        }
    } catch (e) {
        console.log(`\n\x1b[91m❌ Error parsing output: ${e.message}\x1b[0m`);
    }
});
EOF

    # Run nik-parse and pipe to node formatter
    if nik-parse --nik "$nik" | node .formatter.js; then
        :
    else
        echo -e "${RED}❌ Terjadi kesalahan sistem.${RESET}"
    fi

    rm -f .formatter.js

    read -p $'\nTekan Enter untuk kembali...'
}

check_multiple_nik() {
    clear_screen
    get_banner
    echo -e "\n${CYAN}[ MENU CEK MULTIPLE NIK ]${RESET}"

    echo -e "${WHITE}Masukkan NIK (pisahkan dengan spasi)"
    echo -e "Ketik '${RED}selesai${WHITE}' lalu enter (atau langsung enter jika input satu baris)"
    echo -e "${CYAN}----------------------------------------${RESET}"

    echo -ne "${GREEN}>> ${RESET}"
    read -r line

    if [[ "$line" == "selesai" || -z "$line" ]]; then
        echo -e "\n${RED}❌ Tidak ada NIK dimasukkan.${RESET}"
        sleep 1
        return
    fi

    # Replace commas with spaces
    nik_list=(${line//,/ })

    if [ ${#nik_list[@]} -eq 0 ]; then
        echo -e "\n${RED}❌ Tidak ada NIK valid.${RESET}"
        return
    fi

    echo -e "\n${CYAN}📊 Memproses ${#nik_list[@]} NIK...${RESET}"
    echo -e "${CYAN}══════════════════════════════════════════════════${RESET}"

    # Create simple formatter script
    cat << 'EOF' > .simple_formatter.js
const readline = require("readline");
const rl = readline.createInterface({ input: process.stdin });
let data = "";
rl.on("line", l => data += l);
rl.on("close", () => {
    try {
        const res = eval("(" + data + ")");
        if (res.status === "success") {
            const d = res.data;
            const u = d.tambahan ? d.tambahan.usia : "?";
            console.log(`\x1b[92m${d.nik}\x1b[0m | ${d.kelamin} | ${u}`);
            console.log(`    └─ \x1b[97m${d.kotakab}, ${d.provinsi}\x1b[0m`);
        } else {
            console.log(`\x1b[91mInvalid NIK\x1b[0m`);
        }
    } catch (e) { console.log("\x1b[91mError\x1b[0m"); }
});
EOF

    count=1
    for nik in "${nik_list[@]}"; do
        echo -ne "${CYAN}[$count]${RESET} "
        if [[ ! "$nik" =~ ^[0-9]{16}$ ]]; then
             echo -e "${RED}$nik - Invalid Format${RESET}"
        else
             nik-parse --nik "$nik" | node .simple_formatter.js
        fi
        ((count++))
    done

    rm -f .simple_formatter.js

    echo -e "${CYAN}══════════════════════════════════════════════════${RESET}"
    read -p $'\nTekan Enter untuk kembali...'
}

show_info() {
    clear_screen
    get_banner

    info="\n${YELLOW}📌 INFORMASI TOOL${RESET}
${WHITE}Dibuat untuk Termux (Android) - Bash Version${RESET}

${CYAN}FITUR:${RESET}
1. Parsing data KTP dari nomor NIK
2. Mendeteksi Tanggal Lahir, Gender, Wilayah
3. Cek Masal

${RED}DISCLAIMER:${RESET}
Tool ini hanya mengekstrak informasi yang terkandung
dalam format NIK itu sendiri (Sesuai Rumus NIK).
TIDAK mengambil data dari database Dukcapil/Pemerintah.
Gunakan dengan bijak."

    echo -e "$info" | while IFS= read -r line; do
        echo -e "$line"
        sleep 0.05
    done

    read -p $'\nTekan Enter untuk kembali...'
}

main() {
    # Check dependencies
    if ! check_nik_parse; then
        clear_screen
        get_banner
        echo -e "\n${YELLOW}📦 Komponen 'nik-parse' belum terinstall!${RESET}"
        echo -ne "Install sekarang? (${GREEN}y${RESET}/${RED}n${RESET}): "
        read -r ans
        if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
            if ! install_nik_parse; then
                exit 1
            fi
        else
            echo -e "${RED}❌ Tool tidak dapat berjalan.${RESET}"
            exit 1
        fi
    fi

    while true; do
        clear_screen
        get_banner

        echo -e "    ${CYAN}[1]${WHITE} Cek NIK"
        echo -e "    ${CYAN}[2]${WHITE} Multi Check"
        echo -e "    ${CYAN}[3]${WHITE} Info"
        echo -e "    ${CYAN}[4]${WHITE} Keluar"
        echo ""

        echo -ne "${GREEN}root@termux${WHITE}:~# "
        read -r choice

        case $choice in
            1) check_single_nik ;;
            2) check_multiple_nik ;;
            3) show_info ;;
            4) echo -e "\n${YELLOW}👋 Sampai Jumpa!${RESET}"; exit 0 ;;
            *) echo -e "${RED}❌ Pilihan tidak valid!${RESET}"; sleep 1 ;;
        esac
    done
}

# Handle Ctrl+C
trap 'echo -e "\n\n${RED}✖ Program dihentikan paksa.${RESET}"; exit 0' SIGINT

main
