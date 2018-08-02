Basic: replace /bin/rm by remove.sh

Step:
1. mkdir ~/.trash
2. add 'alias rm="sh /home/username/tools/remove.sh"' to ~/.bashrc
3. source ~/.bashrc
4. crontab -e, add to crontab "0 0 * * * rm -rf /home/username/.trash/*"