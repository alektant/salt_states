#=========================================================================================
# SaltStack State File
#
# NAME: fail2ban/init.sls
# WRITTEN BY: Alek Tant of SmartAlek Solutions
# DATE  : 201
#
# PURPOSE: Install and configure fail2ban
#
# EXAMPLE PILLAR:
#   fail2ban:
#     install: true
#     jail:
#       ssh_enabled: true
#       ignoreip: 127.0.0.1/8
#       bantime: 600
#       findtime: 600
#       maxretry: 5
#       backend: auto
#       usedns: warn
#       logencoding: auto
#       chain: INPUT
#       banaction: iptables-multiport
#


{% set fail2ban = salt.pillar.get('fail2ban') %}

# Install fail2ban packages
fail2ban/init.sls - install package:
  pkg.installed:
    - names:
      - fail2ban-server

fail2ban/init.sls - install jail config file:
  file.managed:
    - name: /etc/fail2ban/jail.conf
    - source: salt://fail2ban/files/jail.conf
    - template: jinja
    - defaults:
        jail: {{ fail2ban.jail }}
    - user: root
    - group: root
    - mode: 644
  require:
    - pkg: fail2ban/init.sls - install package

fail2ban_restart:
  service.running:
    - name: fail2ban
    - enable: True
    - watch:
      - file: fail2ban/init.sls - install jail config file