#!/bin/bash

hostn=$(cat /etc/hostname)

change_hostname(){
    echo "Existing hostname is $hostn"

    sudo sed -i "s/$hostn/$1/g" /etc/hosts
    sudo sed -i "s/$hostn/$1/g" /etc/hostname

    echo "Your new hostname is $1"

}

change_ip_address(){
    echo "Existing IP address"
}

change_log_ip_address(){
    echo "Change log IP address"
}

hardening_script(){
    sudo bash utils/hardening.sh --audit-all
}

print_help()
{
    echo "Usage:"
    echo "  ${PROGNAME} [-h] [-q hostname] [-i ip_adress] [-l log_ip_address]"
    echo ""   
    echo "Configures the environment and joins the machine to the Active Directory domain."
    echo ""
    echo "Options:"
    echo "  -h                      Show this message."
    echo "  -q hostname             Specifies new hostname"
    echo "  -i ip_address           Specifies new ip adresse"
    echo "  -l log_ip_address       Specifies ip adresse of the logs server"
    echo "  -a                      Hardening script base on OVH-debian-cis project"

    return 0
}

main() {

    local ip_address=""
    local hostname=""
    local log_ip_address=""

    while getopts "hq:i:l:a" arg; do
        case "${arg}" in
            h)
                print_help
                exit 0
                ;;
            q)
                hostname="${OPTARG}"
                change_hostname $hostname
                ;;
            i)
                ip_address="${OPTARG}"
                change_ip_address $ip_address
                ;;
            l)
                log_ip_address="${OPTARG}"
                change_log_ip_address $log_ip_address    
                ;;
            a)
                hardening_script
                ;;
            *)
                echo "${E_ARGS_INVALID}"
                ;;
        esac
    done

    exit 0
}

main "${@}"