# -*- coding: UTF-8 -*-
begin
  require 'json'
  require_relative './utils/output'
  require_relative './src/github_action'
  require_relative './src/verify_pr_url'

  # Notice: 英文 ',' 来分隔参数
  # ARGV
  params = ARGV[0]
  polishedParams = params.gsub('，', ',')

  category, *args = polishedParams.split(',')

  if args
    if args && args.size != 0
      key, argParams = args
    end
  end

  case category
  when 'get_pr_info' then GithubAction.get_pr(key)
  when 'verify_pr_url' then VerifyPrUrl.verify(key)
  else
    item = {
      :title => 'Whoop! An unknow keyword.', 
    }
    Output.put(item)
  end
rescue Exception => e
  item = {
    :title => 'SOME ERROR HAPPENED.', 
    :subtitle => "#{e.to_s}",
    :autocomplete => "#{e.to_s}",
  }
  Output.put(item)
end