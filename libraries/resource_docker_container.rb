class Chef
  class Resource
    class DockerContainer < Chef::Resource::LWRPBase
      self.resource_name = :docker_container

      actions :create, :start, :stop, :kill, :run, :pause, :unpause, :restart, :delete, :redeploy, :run_if_missing, :remove_link
      default_action :run_if_missing

      attribute :container_name, kind_of: String, name_attribute: true
      attribute :repo, kind_of: String, default: nil
      attribute :tag, kind_of: String, default: 'latest'
      attribute :command, kind_of: String, default: ''

      attribute :attach_stderr, kind_of: [TrueClass, FalseClass], default: true
      attribute :attach_stdin, kind_of: [TrueClass, FalseClass], default: false
      attribute :attach_stdout, kind_of: [TrueClass, FalseClass], default: true
      attribute :autoremove, kind_of: [TrueClass, FalseClass], default: false
      attribute :binds, kind_of: [String, Array, NilClass], default: nil # FIXME: add validate proc
      attribute :cap_add, kind_of: [String, Array, NilClass], default: nil # FIXME: add validate proc
      attribute :cap_drop, kind_of: [String, Array, NilClass], default: nil # FIXME: add validate proc
      attribute :cgroup_parent, kind_of: String, default: '' # FIXME: add validate proc
      attribute :cpu_shares, kind_of: [Fixnum, NilClass], default: nil # FIXME: add validate proc
      attribute :cpuset_cpus, kind_of: String, default: '' # FIXME: add validate proc
      attribute :devices, kind_of: [Hash, Array, NilClass], default: nil # FIXME: add validate proc
      attribute :dns, kind_of: [String, Array, NilClass], default: nil
      attribute :dns_search, kind_of: [String, Array, NilClass], default: nil
      attribute :domain_name, kind_of: String, default: ''
      attribute :entrypoint, kind_of: String, default: nil
      attribute :env, kind_of: [String, Array], default: nil
      attribute :extra_hosts, kind_of: [String, Array, NilClass], default: nil
      attribute :force, kind_of: [TrueClass, FalseClass], default: false
      attribute :host_name, kind_of: String, default: ''
      attribute :links, kind_of: [String, Array, NilClass], default: nil # FIXME: add validate proc
      attribute :log_config, kind_of: [Hash, NilClass], default: nil # FIXME: add validate proc and tests
      attribute :mac_address, kind_of: String, default: '' # FIXME: needs tests
      attribute :memory, kind_of: Fixnum, default: 0
      attribute :memory_swap, kind_of: Fixnum, default: 0
      attribute :network_disabled, kind_of: [TrueClass, FalseClass], default: false
      attribute :network_mode, kind_of: String, default: ''
      attribute :open_stdin, kind_of: [TrueClass, FalseClass], default: false
      attribute :outfile, kind_of: String, default: nil
      attribute :port, kind_of: [String, Array], default: ''
      attribute :privileged, kind_of: [TrueClass, FalseClass], default: false
      attribute :publish_all_ports, kind_of: [TrueClass, FalseClass], default: false
      attribute :remove_volumes, kind_of: [TrueClass, FalseClass], default: false
      attribute :restart_policy, equal_to: %w(no on-failure always), default: 'no'
      attribute :restart_maximum_retry_count, kind_of: Fixnum, default: 0
      attribute :retries, kind_of: Fixnum, default: 3
      attribute :security_opts, kind_of: [String, Array], default: ['']
      attribute :signal, kind_of: String, default: 'SIGKILL'
      attribute :stdin_once, kind_of: [TrueClass, FalseClass], default: false
      attribute :tty, kind_of: [TrueClass, FalseClass], default: false
      attribute :ulimits, kind_of: [Hash, Array, NilClass], default: nil
      attribute :user, kind_of: String, default: ''
      attribute :volumes, kind_of: [String, Array, NilClass], default: '' # FIXME: add validate proc
      attribute :volumes_from, kind_of: [String, Array, NilClass], default: nil # FIXME: add validate proc
      attribute :working_dir, kind_of: String, default: ''

      alias_method :cmd, :command
      alias_method :image, :repo
      alias_method :image_name, :repo
      alias_method :additional_host, :extra_hosts
      alias_method :rm, :autoremove
      alias_method :remove_automatically, :autoremove
      alias_method :hostname, :host_name
      alias_method :domainname, :domain_name
      alias_method :dnssearch, :dns_search
      alias_method :restart_maximum_retries, :restart_maximum_retry_count
      alias_method :retries, :restart_maximum_retry_count
      alias_method :volume_from, :volumes_from
      alias_method :destination, :outfile
      alias_method :ports, :port
    end
  end
end
