class Unifiswitch < Oxidized::Model
  using Refinements

  comment '!'
  prompt /^(?:\(UBNT\)\s*>|[A-Za-z0-9.\-]+[#>])\s*$/

  cmd 'show running-config' do |cfg|
    cfg.gsub! /^(SYSTEM CONFIG FILE).*$/, ''
    cfg.gsub! /^(!\s*System Up Time[\s:]+).*$/, '\\1 <removed>'
    cfg.cut_both
  end

  cfg :ssh do
    post_login do
      sleep 2
      cmd 'cli'
      if vars(:enable).to_s == 'true'
        cmd 'enable'
      end
      cmd 'terminal length 0'
    end

    pre_logout do
      cmd 'exit'
      cmd 'exit'
      cmd 'exit'
    end
  end
end
