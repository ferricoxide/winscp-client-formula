# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as winscp_client with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

winscp-client-config-file-file-managed:
  file.managed:
    - name: {{ winscp_client.config }}
    - source: {{ files_switch(['example.tmpl'],
                              lookup='winscp-client-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ winscp_client.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        winscp_client: {{ winscp_client | json }}
