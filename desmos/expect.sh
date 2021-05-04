#! /usr/bin/expect
# 自动输入密码
# 请确认正确安装了expect ubuntu自带，也可以选择其他方式
set timeout 30
set passwd "<your password>"
spawn /root/withdraw-delegate-script.sh
# withdraw需要输入密码
expect "Enter keyring passphrase:"
send "$passwd\n"
# delegate需要输入密码
expect "Enter keyring passphrase:"
send "$passwd\n"
