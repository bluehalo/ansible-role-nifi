nifi
====

TLS
------------
```
./bin/tls-toolkit.sh standalone \
-n <hostname> \
--subjectAlternativeNames <ip> \
-P {{ nifi_security_truststorePasswd }}\
-S {{ nifi_security_keystorePasswd }}\
-f {{ nifi_conf_dir }}/nifi.properties
```

And store `truststore.jks` and `keystore.jks` in `{{ nifi_conf_dir }}` on NiFi Node

Prior to executing this role, the NiFi distribution must be accssible on the target system at
```{{ nifi_base_dir }}/nifi-{{ nifi_version }}/```
  if tar.gz, it must be unarchived

Or specify these vars:
  `nifi_need_download: True`
  `nifi_repo: "<URL_for archive download>"`

Dependencies
------------

NiFi requires java, see `nifi_rh_packages` variable and do not forget change `nifi_java_home`, if required.

Also, see variables in OS settings section. There are OS config changes, recommended by [documentation](https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#configuration-best-practices).


Restart:

`ansible-playbook ansible/playbooks/nifi_node.yaml --limit 'nifi_nodes_group' -t restart_nifi`

Configure nodes:

`ansible-playbook ansible/playbooks/nifi_node.yaml --limit 'nifi_nodes_group' -t configure_nifi`

Role Variables
--------------

Currently *only* nifi_version 1.18.х supported
To add another version - create directory in `templates/` with config's templates.

### Variables that determine the nifi install location, and their default values:

    nifi_base_dir: /opt/nifi
    nifi_etc_dir: /etc/nifi
    nifi_log_dir: /var/log/nifi
    nifi_pid_dir: /var/run/nifi
    nifi_home_dir: /home/nifi
    
### Other Default variables are listed below:

    # Whether to create a home dir for the NiFi service user. Defaults to true to preserve prior functionality, but should be set to false for new instances.
    nifi_create_home_dir: true 

    # Sets the default shell for the NiFi service user. Only takes affect if nifi_create_home_dir is true.
    nifi_default_shell: /bin/bash

    # specify -Djava.io.tmpdir in bootstrap.conf, default is unspecified
    #nifi_tmp_dir: /tmp

    # Set this to true to enable remote debugging
    nifi_enable_remote_debugging: False
    nifi_remote_debugging_port: 8000

    # whether to restart nifi after making changes; default is True, for a cluster you may wish to disable
    nifi_perform_restart: True


    # A complete list of IP addresses for each nodes within the nifi cluster
    nifi_authorized_nodes_list: []
    
    # nifi_extra_args is a list of key/value pairs that are made available in NiFi, for example:
    nifi_extra_args:
      - file.encoding: "UTF-8"
      - environment: "{{ env }}"
    
    # List of directories for nifi to look in for additional nars.
    nifi_custom_nars: []
        
    nifi_node_jvm_memory: '1024m'
    nifi_java_command: 'java'
    
    # defaults file / directories for nifi
    nifi_database_repository: "{{ nifi_home }}/database_repository"
    nifi_flowfile_repository: "{{ nifi_home }}/flowfile_repository"
    nifi_content_repositories: [ "{{ nifi_home }}/content_repository" ]
    nifi_provenance_repositories: [ "{{ nifi_home }}/provenance_repository" ]
    
    # NiFi cluster settings
    nifi_single_node: True
    nifi_input_socket_host:
    nifi_input_socket_port:
    nifi_cluster_node_protocol_port:
    nifi_web_http_port: 8080
    
    # Queue swap settings
    nifi_queue_swap_threshold: 20000
    nifi_swap_in_threads: 1
    nifi_swap_out_threads: 4

    # Content Repository Settings
    nifi_content_claim_max_flow_files: 100
    nifi_content_claim_max_appendable_size: '10 MB'
    nifi_content_archive_max_retention_period: '12 hours'
    nifi_content_archive_max_usage_percentage: '50%'
    nifi_content_archive_enabled: 'false'
    nifi_content_always_sync: 'false'
     
    # Provenance settings: PersistentProvenanceRepository or VolatileProvenanceRepository
    nifi_provenance_implementation: PersistentProvenanceRepository
    nifi_provenance_max_storage_time: '24 hours'
    nifi_provenance_max_storage_size: '1 GB'
    nifi_provenance_rollover_time: '30 secs'
    nifi_provenance_rollover_size: '100 MB'
    nifi_provenance_query_threads: 2
    nifi_provenance_index_threads: 2
    nifi_provenance_repository_buffer_size: 100000
    nifi_provenance_indexed_fields: EventType, FlowFileUUID, Filename, ProcessorID, Relationship
    
    # Status repository settings
    nifi_components_status_repository_buffer_size: 1440
    nifi_components_status_snapshot_frequency: '1 min'
    
    # NiFi zookeeper settings
    nifi_zookeeper_servers: []
    nifi_zookeeper_dir: /data/zookeeper
    nifi_state_management_embedded_zookeeper_start: False
    nifi_zookeeper_root_node: '/nifi'
    nifi_zookeeper_session_timeout: '10 seconds'
    nifi_zookeeper_autopurge_purgeInterval: 24
    nifi_zookeeper_autopurge_snapRetainCount: 30
    
    # Security settings
    nifi_initial_admin:
    nifi_is_secure: False
    nifi_web_https_port: 8443
    nifi_security_keystore: "{{ nifi_conf_dir }}/keystore.jks"
    nifi_security_keystoreType: jks
    nifi_security_keystorePasswd: ''
    nifi_security_keyPasswd: "{{ nifi_security_keystorePasswd }}"
    nifi_security_truststore: "{{ nifi_conf_dir }}/truststore.jks"
    nifi_security_truststoreType: jks
    nifi_security_truststorePasswd: ''

    # Logback logging levels and settings
    nifi_log_app_file_retention: 10
    nifi_log_user_file_retention: 10
    nifi_log_boot_file_retention: 10
    nifi_log_level_root: INFO
    nifi_log_level_org_apache_nifi: INFO
    nifi_log_level_org_apache_nifi_processors: WARN
    nifi_log_level_org_apache_nifi_processors_standard_LogAttribute: INFO
    nifi_log_level_org_apache_nifi_controller_repository: WARN
    nifi_log_level_org_apache_nifi_controller_repository_StandardProcessSession: WARN
    nifi_log_level_org_apache_nifi_cluster: INFO
    nifi_log_level_org_apache_nifi_server_JettyServer: INFO
    nifi_log_level_org_eclipse_jetty: INFO
    nifi_log_level_org_apache_nifi_web_security: INFO
    nifi_log_level_org_apache_nifi_web_api_config: INFO
    nifi_log_level_org_apache_nifi_authorization: INFO
    nifi_log_level_org_apache_nifi_cluster_authorization: INFO
    nifi_log_level_org_apache_nifi_bootstrap: INFO
    nifi_log_level_org_apache_nifi_bootstrap_Command: INFO
    nifi_log_level_org_apache_nifi_web_filter_RequestLogger: INFO
    nifi_log_level_org_wali: WARN
    nifi_custom_log_levels: []

    # LDAP NiFI properties examples
    nifi_ldap:
      identity_strategy: USE_USERNAME
      url: ldaps://ldap.ru
      auth_strategy: LDAPS
      manager_dn: CN=service.nifi,OU=Services,DC=corp,DC=ru
      manager_password: changeit
      ldap_username_in_lower_case: true
      ldap_group_in_lower_case: true
      users_search_bases:
        - ou=Admins,dc=corp,dc=ru
        - ou=Branches,dc=corp,dc=ru
        - ou=Services,ou=TDP,dc=corp,dc=ru
        - ou=Partners,dc=corp,dc=ru
      groups_ou: ou=Access,ou=Groups,ou=TDP,dc=corp,dc=ru
      groups_cn:
        - SYS NiFi Admins
        - SYS NiFi Developers
        - SYS NiFi Users

    # Backup configs before replece them by template
    nifi_backup_congif: true

