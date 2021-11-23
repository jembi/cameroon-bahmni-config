# Refer to this link to understand below rules: https://wiki.centos.org/HowTos/Network/IPTables

# Set default input policy to ACCEPT
iptables -P INPUT ACCEPT

# Flush all current rules!
iptables -F

# Allow localhost interface
iptables -A INPUT -i lo -j ACCEPT

# Allow Established
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH access
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow Web Access to Bahmni Apps (http, https, openerp)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 8069 -j ACCEPT
iptables -A INPUT -p tcp --dport 3000 -j ACCEPT


# DROP ALL Incoming connections except those which are marked as ACCEPT (Policy change!)
iptables -P INPUT DROP

# DROP all Forwards (we are not a router)
iptables -P FORWARD DROP

# Allow all output
iptables -P OUTPUT ACCEPT

# Print Final Settings
iptables -L -n -v --line-numbers

# Make changes permanent
/sbin/service iptables save
