SCHEDULER.every '1d', first_in: 0 do |job|
  versions = RubyVersions.new.stable

  send_event('ruby_stable', { text: versions.join('<br/>') })
end
