class Unifiswitch < Oxidized::Model
  using Refinements

  comment '!'
  prompt /^(?:\(UBNT\)\s*>|[A-Za-z0-9.\-]+[#>])\s*$/

  cmd 'show running-config' do |cfg|
    cfg.reject_lines ['System Up Time', 'SYSTEM CONFIG FILE', 'Current Configuration']
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
      cmd 'exit'
      cmd 'exit'
    end
  end
end
