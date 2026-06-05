class Unifiswitch < Oxidized::Model
  using Refinements

  comment '!'
  prompt /^(?:[\w.-]+#|\(UBNT\)\s[>#])\s*$/

  cmd 'show running-config' do |cfg|
    cfg.reject_lines ['System Up Time']
    cfg.each_line.to_a[4..-4].join
  end

  cfg :ssh do
    post_login do
      sleep 2
      cmd 'cli'
      cmd "enable" if vars :enable
      cmd 'terminal length 0'
    end

    pre_logout do
      cmd 'exit'
      cmd 'exit' if vars :enable
      cmd 'exit'
    end
  end
end
