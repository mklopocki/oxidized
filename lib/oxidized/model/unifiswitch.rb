class Unifiswitch < Oxidized::Model

  comment '!'

  # This regex matches the 3 distinct prompts:
  # 1. Initial shell:  NAME.0.0.0#
  # 2. Unprivileged:   (UBNT) >
  # 3. Privileged:     (UBNT) #
  prompt /^(?:\([\w\s.-]+\)\s[>#]|[\w\.-]+#)\s*$/

  # The command used to gather the configuration
  cmd 'show running-config' do |cfg|
    cfg.gsub! /^!System Up Time\s+.*$/, '\\1 <stripped>'
    cfg
  end

  cfg :ssh, :telnet do
    # Commands to run immediately after successful authentication
    post_login 'cli'
    post_login 'enable'
    post_login 'terminal length 0'
    
    # Commands to gracefully exit the sessions
    pre_logout 'exit' # Exits the (UBNT) CLI
    pre_logout 'exit' # Exits the initial shell
  end
end
