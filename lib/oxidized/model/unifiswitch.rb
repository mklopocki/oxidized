class Unifiswitch < Oxidized::Model
  using Refinements

  comment '!'

  # This regex matches the 3 distinct prompts:
  # 1. Initial shell:  NAME.0.0.0#
  # 2. Unprivileged:   (UBNT) >
  # 3. Privileged:     (UBNT) #
  prompt /^(?:[\w.-]+#|\(UBNT\)\s[>#])\s*$/

  # The command used to gather the configuration
  cmd 'show running-config' do |cfg|
    cfg.gsub! /(!System Up Time\s+-).*/, '\\1 <stripped>'
    cfg.each_line.to_a[4..-4].join
  end

  cfg :ssh do
    # Commands to run immediately after successful authentication
    post_login do
      sleep 2
      cmd 'cli'
      cmd 'enable'
      cmd 'terminal length 0'
    end

    # Commands to gracefully exit the sessions
    pre_logout do
      cmd 'exit' # Exits the (UBNT) #
      sleep 0.5
       cmd 'exit' # Exits the (UBNT) >
      sleep 0.5
      cmd 'exit' # Exits the initial shell
    end
  end
end
