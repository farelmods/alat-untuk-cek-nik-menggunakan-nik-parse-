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
BG_BLACK='\033[40m'

# --- UTILS ---

clear_screen() {
    clear
}

hide_cursor() {
    tput civis 2>/dev/null
}

show_cursor() {
    tput cnorm 2>/dev/null
}

typing() {
    text="$1"
    speed="${2:-0.02}"
    color="${3:-$GREEN}"
    echo -ne "$color"
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${text:$i:1}"
        sleep "$speed"
    done
    echo -e "$RESET"
}

loading_animation() {
    text="${1:-Processing}"
    duration="${2:-2}"
    symbols=("█▒▒▒▒▒▒▒▒▒" "███▒▒▒▒▒▒▒" "█████▒▒▒▒▒" "███████▒▒▒" "██████████")
    end=$((SECONDS + duration))

    echo -ne "\r${GREEN}[*] ${text}... "
    while [ $SECONDS -lt $end ]; do
        for s in "${symbols[@]}"; do
            echo -ne "\r${GREEN}[*] ${text}... $s"
            sleep 0.15
        done
    done
    echo -e "\r${GREEN}[*] ${text}... [ COMPLETE ]      ${RESET}"
}

cyber_intro() {
    clear_screen
    hide_cursor
    echo -e "${GREEN}"
    # Simulated Matrix/Data Stream
    chars="10101010101010101010101010101010"
    for i in {1..20}; do
        r=$((RANDOM % 32))
        echo -ne "${chars:$r} "
        if (( i % 5 == 0 )); then echo ""; fi
        sleep 0.05
    done
    echo ""

    typing "[*] SYSTEM BOOT SEQUENCE INITIATED..." 0.03 "$GREEN"
    sleep 0.2
    typing "[*] ESTABLISHING SECURE CONNECTION..." 0.03 "$GREEN"
    sleep 0.2
    typing "[*] ACCESSING DUKCAPIL GATEWAY..." 0.03 "$GREEN"
    sleep 0.2
    typing "[*] AUTHENTICATING USER: FARELMODS" 0.03 "$CYAN"
    sleep 0.5
    echo -e "\n${RED}[ ACCESS GRANTED ]${RESET}"
    sleep 0.8
    show_cursor
    clear_screen
}

get_banner() {
    echo -e "${RED}╔══════════════════════════════════════════════════════╗${RESET}"
    echo -e "${RED}║${WHITE}           INDONESIA CYBER OPERATIONS                 ${RED}║${RESET}"
    echo -e "${RED}╠══════════════════════════════════════════════════════╣${RESET}"
    echo -e "${GREEN}   ___ ___ _  __  _  _ ___ _  __${RESET}"
    echo -e "${GREEN}  / __| __| |/ / | \| |_ _| |/ /${RESET}"
    echo -e "${GREEN} | (__| _|| ' <  | .\` || || ' < ${RESET}"
    echo -e "${GREEN}  \___|___|_|\_\ |_|\_|___|_|\_\ ${RESET}"
    echo -e "${CYAN}       BY FARELMODS${RESET}"
    echo -e "${RED}╠══════════════════════════════════════════════════════╣${RESET}"
    echo -e "${WHITE}║${GREEN}  v2.0 • PROFESSIONAL TOOL • TERMUX EDITION           ${WHITE}║${RESET}"
    echo -e "${RED}╚══════════════════════════════════════════════════════╝${RESET}"
}

# --- LOGIC ---

install_nik_parse() {
    echo -e "\n${YELLOW}[!] Installing Dependencies...${RESET}"
    loading_animation "Downloading Modules" 5
    if npm install -g nik-parse > /dev/null 2>&1; then
        echo -e "${GREEN}[+] Dependency Installed Successfully!${RESET}"
        sleep 1
        return 0
    else
        echo -e "${RED}[-] Installation Failed. Please install nodejs.${RESET}"
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
    echo -e "\n${RED}[ TARGET ACQUISITION ]${RESET}"
    echo -e "${CYAN}Enter Target Identity Number (NIK)${RESET}"
    echo -ne "${GREEN}root@farelmods${WHITE}:~/target# "
    read -r nik

    # Simple validation
    if [[ ! "$nik" =~ ^[0-9]{16}$ ]]; then
        echo -e "\n${RED}[!] INVALID NIK FORMAT. MUST BE 16 DIGITS.${RESET}"
        read -p "Press Enter to retry..."
        return
    fi

    echo ""
    loading_animation "Decrypting Identity" 2

    # Write the JS formatter to a temp file
    cat << 'EOF' > .formatter.js
const readline = require("readline");
const rl = readline.createInterface({ input: process.stdin, output: process.stdout, terminal: false });
let data = "";

// Helper for sleep
const sleep = ms => new Promise(r => setTimeout(r, ms));

rl.on("line", (line) => { data += line + "\n"; });

rl.on("close", async () => {
    try {
        const res = eval("(" + data + ")");

        // Colors
        const C = {
            CYAN: "\x1b[96m", YELLOW: "\x1b[93m", WHITE: "\x1b[97m",
            RED: "\x1b[91m", GREEN: "\x1b[92m", RESET: "\x1b[0m",
            BOLD: "\x1b[1m"
        };

        // Scramble Effect Function
        async function scramblePrint(label, value) {
            const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*";
            const width = 20; // Label width
            const steps = 8;  // Animation steps

            process.stdout.write(`${C.CYAN}║ ${C.GREEN}${label.padEnd(width)}: ${C.WHITE}`);

            // Initial random string
            let temp = "";
            for(let i=0; i<value.length; i++) temp += chars[Math.floor(Math.random() * chars.length)];

            // Animation
            for(let i=0; i<steps; i++) {
                process.stdout.write(temp);
                await sleep(40);
                process.stdout.write("\b".repeat(temp.length));

                // Regenerate temp mostly, but keep some chars? No, simple scramble
                temp = "";
                for(let j=0; j<value.length; j++) temp += chars[Math.floor(Math.random() * chars.length)];
            }

            console.log(`${value}${C.CYAN} ║`);
        }

        if (res.status === "success") {
            const d = res.data;
            const t = d.tambahan;
            const border = "═".repeat(60);

            console.log(`\n${C.CYAN}╔${border}╗`);
            console.log(`║${"TARGET INFORMATION EXTRACTED".padStart(44).padEnd(60)}║`);
            console.log(`╠${border}╣${C.RESET}`);

            await scramblePrint("NIK", d.nik);
            await scramblePrint("JENIS KELAMIN", d.kelamin);
            await scramblePrint("TANGGAL LAHIR", d.lahir);
            await scramblePrint("USIA", t.usia);
            await scramblePrint("ZODIAK", t.zodiak);

            console.log(`${C.CYAN}╠${border}╣${C.RESET}`);

            await scramblePrint("PROVINSI", d.provinsi);
            await scramblePrint("KABUPATEN/KOTA", d.kotakab);
            await scramblePrint("KECAMATAN", d.kecamatan);
            await scramblePrint("KODE POS", t.kodepos);

            console.log(`${C.CYAN}╠${border}╣${C.RESET}`);

            await scramblePrint("HARI LAHIR", t.pasaran);
            await scramblePrint("ULTAH", t.ultah);

            console.log(`${C.CYAN}╚${border}╝${C.RESET}`);

        } else {
            console.log(`\n${C.RED}[!] ERROR: ${res.pesan}${C.RESET}`);
        }
    } catch (e) {
        console.log(`\n\x1b[91m[!] PARSE ERROR: ${e.message}\x1b[0m`);
    }
});
EOF

    # Run nik-parse and pipe to node formatter
    # We pipe stdout to /dev/tty explicitly if needed, but node inherits stdio by default usually.
    # However, piping output from nik-parse | node usually buffers.
    # The animation might look jerky if fully buffered.
    # But for a small output it might be fast.

    if nik-parse --nik "$nik" | node .formatter.js; then
        :
    else
        echo -e "${RED}[!] SYSTEM ERROR EXECUTING PROBE.${RESET}"
    fi

    rm -f .formatter.js

    echo -e "\n${CYAN}[ INFORMATION RETRIEVED ]${RESET}"
    read -p "Press Enter to return to base..."
}

check_multiple_nik() {
    clear_screen
    get_banner
    echo -e "\n${RED}[ MASS SURVEILLANCE MODE ]${RESET}"

    echo -e "${WHITE}Enter targets (Space separated). Type '${RED}exit${WHITE}' to cancel."
    echo -e "${CYAN}------------------------------------------------${RESET}"

    echo -ne "${GREEN}targets@farelmods${WHITE}:~# "
    read -r line

    if [[ "$line" == "exit" || -z "$line" ]]; then
        echo -e "\n${RED}[-] Operation Cancelled.${RESET}"
        sleep 1
        return
    fi

    # Replace commas with spaces
    nik_list=(${line//,/ })

    if [ ${#nik_list[@]} -eq 0 ]; then
        echo -e "\n${RED}[!] No valid targets found.${RESET}"
        return
    fi

    echo -e "\n${GREEN}[*] Scanning ${#nik_list[@]} targets...${RESET}"
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
    read -p $'\nPress Enter to return...'
}

show_info() {
    clear_screen
    get_banner

    # Typing effect for info
    echo -e ""
    typing "[ SYSTEM INFORMATION ]" 0.02 "$RED"
    echo -e "${CYAN}----------------------${RESET}"
    typing "NAME    : NIK PARSER TOOL" 0.01 "$GREEN"
    typing "VERSION : 2.0 (CYBER EDITION)" 0.01 "$GREEN"
    typing "AUTHOR  : FARELMODS" 0.01 "$GREEN"
    typing "PLATFORM: TERMUX / LINUX" 0.01 "$GREEN"
    echo ""
    typing "[ DISCLAIMER ]" 0.02 "$RED"
    echo -e "${CYAN}----------------------${RESET}"
    typing "This tool generates geographic and birth date" 0.01 "$WHITE"
    typing "information based on the Indonesian NIK formula." 0.01 "$WHITE"
    typing "It does NOT access government databases." 0.01 "$WHITE"
    typing "Use for educational/legal purposes only." 0.01 "$WHITE"

    echo ""
    read -p "Press Enter to return..."
}

main() {
    cyber_intro

    # Check dependencies
    if ! check_nik_parse; then
        echo -e "\n${RED}[!] CRITICAL ERROR: 'nik-parse' module not found.${RESET}"
        echo -ne "Attempt auto-install? (${GREEN}y${RESET}/${RED}n${RESET}): "
        read -r ans
        if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
            if ! install_nik_parse; then
                exit 1
            fi
        else
            echo -e "${RED}[-] SYSTEM HALTED.${RESET}"
            exit 1
        fi
    fi

    while true; do
        clear_screen
        get_banner

        # Menu with boxes
        echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${RESET}"
        echo -e "${CYAN}║${WHITE} [1] CHECK TARGET IDENTITY                            ${CYAN}║${RESET}"
        echo -e "${CYAN}║${WHITE} [2] MASS SURVEILLANCE (MULTI-CHECK)                  ${CYAN}║${RESET}"
        echo -e "${CYAN}║${WHITE} [3] SYSTEM INFORMATION                               ${CYAN}║${RESET}"
        echo -e "${CYAN}║${WHITE} [4] TERMINATE SESSION                                ${CYAN}║${RESET}"
        echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${RESET}"
        echo ""

        echo -ne "${RED}root@farelmods${WHITE}:~# "
        read -r choice

        case $choice in
            1) check_single_nik ;;
            2) check_multiple_nik ;;
            3) show_info ;;
            4) echo -e "\n${RED}[*] CONNECTION TERMINATED.${RESET}"; exit 0 ;;
            *) echo -e "${RED}[!] UNKNOWN COMMAND.${RESET}"; sleep 1 ;;
        esac
    done
}

# Handle Ctrl+C
trap 'echo -e "\n\n${RED}[!] FORCED SHUTDOWN.${RESET}"; show_cursor; exit 0' SIGINT

main
