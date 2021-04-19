## Super simple bash scheduler

Schedule recurring tasks with one simple command.

Examples:

Ping a server every 30 seconds:

`./schedule.sh -n 30 ping -D -c 10 www.google.com`

Watch disk usage once a day at 0200:

`./schedule.sh -v -n 86400 -s 02:00 df -h`