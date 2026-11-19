# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as winscp_client with context %}

{%- set config = winscp_client.get('config') or {} %}
{%- set install_prefix = config.get(
      'install_root', 'C:\\Program Files (x86)\\WinSCP'
    ) %}
{%- set ini_path = [install_prefix, 'WinSCP.ini'] | join('\\') %}
{%- set desktop_lnk = 'C:\\Users\\Public\\Desktop\\WinSCP.lnk' %}
{%- set start_lnk = 'C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\WinSCP.lnk' %}

Remove WinSCP Desktop Shortcut:
  file.absent:
    - name: {{ desktop_lnk | json }}

Remove WinSCP Start Menu Shortcut:
  file.absent:
    - name: {{ start_lnk | json }}

Remove WinSCP INI Configuration File:
  file.absent:
    - name: {{ ini_path | json }}
