#!/bin/bash
# Tool name: FileCrypt - Encrypt files and folders using GPG
# Written by: KsrvcO
# Version: 1.0.1
# Tested on: Debian based linux systems
# Contact me: flower.k2000[at]gmail.com
# This tool can decrypt files that encrypted by this tool.
reset
if ! command -v gpg &> /dev/null
then
    echo "You required GPG tool on linux and you have not this. Please install it."
    exit
fi
if ! command -v wipe &> /dev/null
then
    echo "You required wipe tool on linux and you have not this. Please install it."
    exit
fi
echo -e "
·▄▄▄▄   ▄▄▄· ▄▄▄▄▄ ▄▄▄·  ▄▄· ▄▄▄   ▄· ▄▌ ▄▄▄·▄▄▄▄▄
██▪ ██ ▐█ ▀█ •██  ▐█ ▀█ ▐█ ▌▪▀▄ █·▐█▪██▌▐█ ▄█•██
▐█· ▐█▌▄█▀▀█  ▐█.▪▄█▀▀█ ██ ▄▄▐▀▀▄ ▐█▌▐█▪ ██▀· ▐█.▪
██. ██ ▐█ ▪▐▌ ▐█▌·▐█ ▪▐▌▐███▌▐█•█▌ ▐█▀·.▐█▪·• ▐█▌·
▀▀▀▀▀•  ▀  ▀  ▀▀▀  ▀  ▀ ·▀▀▀ .▀  ▀  ▀ • .▀    ▀▀▀
                                         by KsrvcO
[+] Tool name: FileCrypt - Encrypt files and directories
[+] Written by: KsrvcO
[+] Version: 1.0.1
[+] Tested on: Debian based linux operation systems

1. Encrypt directory
2. Decrypt directory
3. ByeBye
"
read -p "[+] Choose an option: " option
if [[ $option == 1 ]]
	then
		read -p "[!] Give me your directory (ex: /home/user/docs): " files
		dirname_var=$(dirname "$files")
		foldername_var=$(basename "$files")
		tar czf $dirname_var/encrypted_data.tar.gz -C $dirname_var $foldername_var
		read -s -p "[!] Enter your strong password for encrypt your files: " encpass
		echo ""
		gpg --batch -c --passphrase "$encpass" $dirname_var/encrypted_data.tar.gz 2>/dev/null
		wipe -rf $dirname_var/archived_data.tar.gz 2>/dev/null
		echo "[!] File encrypted successfully with name $dirname_var/encrypted_data.tar.gz.gpg"
		read -p "[!] Do you want to delete files directory? (y/n): " question
			if [ $question == "y" ]
				then
					wipe -rf $dirname_var/encrypted_data.tar.gz 2>/dev/null
					wipe -rf $files 2>/dev/null
					echo "[!] $files removed successfully."
					exit
                elif [ $question == "n" ]
					then
						exit
                else
					exit
                fi
elif [[ $option == 2 ]]
	then
		read -p "[!] Give me your encrypted file: " encfile
		read -s -p "[!] Enter your password for decrypt your file: " encryptedpass
		echo ""
		dirname_var_ex=$(dirname "$encfile")
		foldername_var_ex=$(basename "$encfile")
		gpg --batch --yes --passphrase "$encryptedpass" --output "$dirname_var_ex/decrypted_data.tar.gz" --decrypt "$encfile" 2>/dev/null
			if [ $? -ne 0 ]
				then
					echo "Error: Incorrect password or corrupted file."
					exit 1
				else
					wipe -rf $encfile 2>/dev/null
					tar xvf $dirname_var_ex/decrypted_data.tar.gz -C $dirname_var_ex
					wipe -rf $dirname_var_ex/decrypted_data.tar.gz 2>/dev/null
			fi
elif [[ $option == 3 ]]
	then
		exit
fi
exit
