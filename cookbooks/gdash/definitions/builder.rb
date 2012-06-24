
define :builtin_dashboards, :dashboards => [] do
  base_key = node[:fqdn].gsub('.', '_')
  builtins = {
    'Load' => {
      base_key => {
        :description => 'System Load',
        :graphs => {
          'System Load' => {
            :area => :stacked,
            :hide_legend => false,
            :fields => {
              :load => {
                :data => "substr(collectd.#{base_key}.load.load.*, 4,5)",
                :no_alias => true
              }
            }
          }
        }
      }
    },
    'CPU' => {
      base_key => {
        :description => 'CPU Usage',
        :graphs => {
          'System CPU' => {
            :area => :stacked,
            :description => 'System CPU Usage',
            :hide_legend => false,
            :fields => {
              :system => {
                :data => "substr(collectd.#{base_key}.cpu.*.cpu.system.value, 3,5)",
                :no_alias => true
              }
            }
          },
          'User CPU' => {
            :area => :stacked,
            :hide_legend => false,
            :description => 'User CPU Usage',
            :fields => {
              :user => {
                :data => "substr(collectd.#{base_key}.cpu.*.cpu.user.value, 1,3)",
                :no_alias => true
              }
            }
          },
          'Wait CPU' => {
            :area => :stacked,
            :hide_legend => false,
            :description => 'CPU Wait',
            :fields => {
              :wait => {
                :data => "substr(collectd.#{base_key}.cpu.*.cpu.wait.value, 1,3)",
                :no_alias => true
              }
            }
          }
        }
      }
    },
    'Disk Usage' => {
      base_key => {
        :description => 'Disk Usage',
        :graphs => {
          'Free Space' => {
            :area => :stacked,
            :hide_legend => false,
            :description => 'Free Disk Space',
            :fields => {
              :root => {
                :data => "substr(collectd.#{base_key}.df.df.root.free, 1,6)",
                :no_alias => true
              }
            }
          },
          'Used Space' => {
            :hide_legend => false,
            :description => 'Used Disk Space',
            :area => :stacked,
            :fields => {
              :root => {
                :data => "substr(collectd.#{base_key}.df.df.root.used, 1,6)",
                :no_alias => true
              }
            }
          }
        }
      }
    },
    'Disk Operations' => {
      base_key => {
        :description => 'Disk Operations',
        :graphs => {
          'Reads' => {
            :hide_legend => false,
            :description => 'Total Disk Reads',
            :area => :stacked,
            :fields => {
              :reads => {
                :data => "substr(collectd.#{base_key}.disk.*.disk_merged.read, 3,6)",
                :no_alias => true
              }
            }
          },
          'Writes' => {
            :hide_legend => false,
            :description => 'Total Disk Writes',
            :area => :stacked,
            :fields => {
              :writes => {
                :data => "substr(collectd.#{base_key}.disk.*.disk_merged.write, 3,6)",
                :no_alias => true
              }
            }
          }
        }
      }
    },
    'Network Interfaces' => {
      base_key => {
        :description => 'Network Interfaces',
        :graphs => {
          'Packets Sent' => {
            :hide_legend => false,
            :description => 'Total Packets Sent',
            :area => :stacked,
            :fields => {
              :sent => {
                :data => "substr(collectd.#{base_key}.interface.if_packets.*.tx, 4,6)",
                :no_alias => true
              }
            }
          },
          'Packets Received' => {
            :hide_legend => false,
            :description => 'Total Packets Received',
            :area => :stacked,
            :fields => {
              :received => {
                :data => "substr(collectd.#{base_key}.interface.if_packets.*.rx, 4,6)",
                :no_alias => true
              }
            }
          },
          'Receive Errors' => {
            :hide_legend => false,
            :description => 'Total Receive Errors',
            :area => :stacked,
            :fields => {
              :errors => {
                :data => "substr(collectd.#{base_key}.interface.if_errors.*.rx, 4,6)",
                :no_alias => true
              }
            }
          },
          'Send Errors' => {
            :hide_legend => false,
            :description => 'Total Send Errors',
            :area => :stacked,
            :fields => {
              :errors => {
                :data => "substr(collectd.#{base_key}.interface.if_errors.*.tx, 4,6)",
                :no_alias => true
              }
            }
          }
        }
      }
    },
    'Memory Usage' => {
      base_key => {
        :description => 'Memory Usage',
        :graphs => {
          'Used Memory' => {
            :hide_legend => false,
            :description => 'Used Memory',
            :area => :stacked,
            :fields => {
              :used => {
                :data => "substr(collectd.#{base_key}.memory.memory.used.value, 4,5)",
                :no_alias => true
              }
            }
          },
          'Free Memory' => {
            :hide_legend => false,
            :description => 'Free Memory',
            :area => :stacked,
            :fields => {
              :free => {
                :data => "substr(collectd.#{base_key}.memory.memory.free.value, 4,5)",
                :no_alias => true
              }
            }
          }
        }
      }
     },
    'Swap' => {
      base_key => {
        :description => 'Swap space usage',
        :graphs => {
          'Free Swap' => {
            :hide_legend => false,
            :description => 'Free Swap Space',
            :area => :stacked,
            :fields => {
              :free => {
                :data => "substr(collectd.#{base_key}.swap.swap.free.value, 4,5)",
                :no_alias => true
              }
            }
          },
          'Used Swap' => {
            :hide_legend => false,
            :description => 'Used Swap Space',
            :area => :stacked,
            :fields => {
              :used => {
                :data => "substr(collectd.#{base_key}.swap.swap.used.value, 4,5)",
                :no_alias => true
              }
            }
          },
          'Swap IO In' => {
            :hide_legend => false,
            :description => 'Swap IO In',
            :area => :stacked,
            :fields => {
              :io_in => {
                :data => "substr(collectd.#{base_key}.swap.swap_io.in.value, 4,5)",
                :no_alias => true
              }
            }
          },
          'Swap IO Out' => {
            :hide_legend => false,
            :description => 'Swap IO Out',
            :area => :stacked,
            :fields => {
              :io_out => {
                :data => "substr(collectd.#{base_key}.swap.swap_io.out.value, 4,5)",
                :no_alias => true
              }
            }
          }
        }
      }
    }
  }
  dashboards = Array(params[:dashboards]).map(&:to_sym)
  valid_boards = Hash[*builtins.keys.map{|k| [k,k.downcase.gsub(' ', '_').to_sym]}.flatten]
  unless(dashboards.include?(:all))
    valid_boards.each_pair do |key, value|
      builtins.delete(key) unless dashboards.include?(value)
    end
  end
  unless(builtins.empty?)
    node.set[:gdash][:builtin_dashboards] = Chef::Mixin::DeepMerge.merge(
      node[:gdash][:builtin_dashboards] || {},
      builtins
    ).to_hash
  end
end
