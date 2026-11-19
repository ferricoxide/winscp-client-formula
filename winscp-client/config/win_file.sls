# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as winscp_client with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

{%- set config = winscp_client.get('config') or {} %}
{%- set install_prefix = config.get(
      'install_root', 'C:\\Program Files (x86)\\WinSCP'
    ) %}
{%- set rootgroup = config.get(
      'rootgroup', winscp_client.get('rootgroup', 'Administrators')
    ) %}
{%- set ini_path = [install_prefix, 'WinSCP.ini'] | join('\\') %}
{%- set binary_path = [install_prefix, 'WinSCP.exe'] | join('\\') %}
{%- set desktop_lnk = 'C:\\Users\\Public\\Desktop\\WinSCP.lnk' %}
{%- set start_lnk = 'C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\WinSCP.lnk' %}
{%- set ini_template = config.get('ini_template', true) %}
{%- set ini_settings = config.get('ini_settings') or {} %}
{%- set desktop_shortcut = config.get('desktop_shortcut', true) %}
{%- set start_menu_shortcut = config.get('start_menu_shortcut', true) %}

{%- if ini_template %}
Manage WinSCP INI Configuration File:
  file.managed:
    - context:
        winscp_client: {{ winscp_client | json }}
    - group: {{ rootgroup }}
    - makedirs: true
    - name: {{ ini_path | json }}
    - require:
      - sls: {{ sls_package_install }}
    - source: {{ files_switch(['WinSCP.ini.tmpl', 'WinSCP.ini'],
                              lookup='Manage WinSCP INI Configuration File'
                 )
              }}
    - template: jinja
{%- endif %}

{%- if ini_settings %}
Configure WinSCP INI Options:
  ini.options_present:
    - name: {{ ini_path | json }}
    - require:
{%- if ini_template %}
      - file: Manage WinSCP INI Configuration File
{%- else %}
      - sls: {{ sls_package_install }}
{%- endif %}
    - sections: {{ ini_settings | json }}
{%- endif %}

{%- if desktop_shortcut %}
Create WinSCP Desktop Shortcut:
  shortcut.present:
    - icon_index: 0
    - icon_location: {{ binary_path | json }}
    - name: {{ desktop_lnk | json }}
    - require:
      - sls: {{ sls_package_install }}
    - target: {{ binary_path | json }}
    - working_dir: {{ install_prefix | json }}
{%- endif %}

{%- if start_menu_shortcut %}
Create WinSCP Start Menu Shortcut:
  shortcut.present:
    - icon_index: 0
    - icon_location: {{ binary_path | json }}
    - name: {{ start_lnk | json }}
    - require:
      - sls: {{ sls_package_install }}
    - target: {{ binary_path | json }}
    - working_dir: {{ install_prefix | json }}
{%- endif %}
