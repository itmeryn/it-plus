curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

yum makecache


cat >> ~/.wgetrc <<WGETRC
# @start ~/.wgetrc Create by ryn $(date +%F_%T)
Header=User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36 Marked by MrUse
Header=Referer: https://www.baidu.com/
#http_proxy=""
#ftp_proxy=""
# @end ~/.wgetrc
WGETRC

cat >> ~/.curlrc <<CURLRC
# @start ~/.curlrc Create by ryn $(date +%F_%T)
User-Agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36 Marked by MrUse"
Header="X-Forwarded-For: https://www.baidu.com/"
# @end ~/.curlrc
CURLRC

 cat >> /etc/environment <<ENVIRONMENT
# LC_ by ryn
LANG="en_US.UTF-8"
LC_CTYPE="en_US.UTF-8"
LC_NUMERIC="en_US.UTF-8"
LC_TIME="en_US.UTF-8"
LC_COLLATE="en_US.UTF-8"
LC_MONETARY="en_US.UTF-8"
LC_MESSAGES="en_US.UTF-8"
LC_PAPER="en_US.UTF-8"
LC_NAME="en_US.UTF-8"
LC_ADDRESS="en_US.UTF-8"
LC_TELEPHONE="en_US.UTF-8"
LC_MEASUREMENT="en_US.UTF-8"
LC_IDENTIFICATION="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
ENVIRONMENT

   # TimeZone & Clock
    yum -y --skip-broken --noplugins install ntpdate;
    mv /etc/localtime /etc/localtime.$(date +%F_%T);
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime;
    /usr/sbin/ntpdate s1a.time.edu.cn;
    grep ntpdate /var/spool/cron/root>/dev/null 2>&1||echo '55 23 * * * /usr/sbin/ntpdate s1a.time.edu.cn' >> /var/spool/cron/root;
    hwclock --systohc;
    
    
    # Update
    yum -y --skip-broken --noplugins update;
    # Install Basic and useful Tools
    ## Tools for hardware
    yum -y --skip-broken --noplugins install dmidecode dmesg parted gdisk e2fsprogs;
    ## Tools for recovery
    yum -y --skip-broken --noplugins install testdisk safecopy qphotorec;
    ## Tools for system
    yum -y --skip-broken --noplugins install bc tree lshw man at chkconfig vixie-cron crontabs screen dialog ntpdate ntsysv policycoreutils-python redhat-lsb-core;
    ## Tools for file
    yum -y --skip-broken --noplugins install curl wget lrzsz rsync mlocate tar bzip2 gzip zip unzip xz* dos2unix vim sed patch;
    ## Tools for compiler
    yum -y --skip-broken --noplugins install gcc gcc-c++ autoconf automake make cmake;
    ## Tools for network
    yum -y --skip-broken --noplugins install net-tools telnet nmap iptraf ifstat tcpdump wireshark;
    ## Tools for performance or strace
    yum -y --skip-broken --noplugins install lsof strace iotop hdparm sysstat sar nmon iftop htop;
    ## Tools for basic daemon
    yum -y --skip-broken --noplugins install sendmail crontabs cronie;
    ## Tools for version control
    yum -y --skip-broken --noplugins install git subversion;
    yum -y --skip-broken --noplugins install compat-db47 apr apr-util apr-devel neon-devel;

 # SElinux
    sed -i 's#^SELINUX.*#\#&#g' /etc/sysconfig/selinux
    echo 'SELINUX=disabled' >> /etc/sysconfig/selinux
    setenforce 0
    
       # File Descriptor
    ulimit -HSn 65535;
    grep '# File Descriptor Limits' /etc/security/limits.conf>/dev/null 2>&1||cat >> /etc/security/limits.conf <<LIMITS
# File Descriptor Limits $(date +%F_%T)
*   soft    core    0
*   soft    nofile  10240
*   hard    nofile  65535
*
LIMITS
    echo 1000000 > /proc/sys/fs/file-max;
    grep 'fs.file-max' /etc/sysctl.conf||echo 'fs.file-max=65535' >> /etc/securitysysctl.conf;
    grep pam_limits.so /etc/pam.d/sudo||echo 'session    required     pam_limits.so' >> /etc/pam.d/sudo;

    # Process & Threads
    grep '# Process Limits' /etc/security/limits.conf>/dev/null 2>&1||cat >> /etc/security/limits.conf <<LIMITS
# Process Limits $(date +%F_%T)
*   soft    nproc   65535
*   hard    nproc   65535
LIMITS
systemctl stop firewalld
systemctl mask firewalld
yum install iptables-services -y
systemctl enable iptables
