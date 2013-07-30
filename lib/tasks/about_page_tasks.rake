namespace :about do
  desc "Get a full report in XML or JSON format"
  task :report, [:format, :section] => [:environment] do |t,args|
    args.with_defaults(:format => 'yaml')
    configuration = AboutPage.configuration
    configuration = configuration.select { |key, value| (args.section.split(/[\W\+]/) + ["app"]).include? key.to_s } if args.section
    response_method = "to_#{args.format.downcase}".to_sym
    puts configuration.send(response_method)
  end

  desc "Get a health report in XML or JSON format"
  task :health, [:format, :section] => [:environment] do |t,args|
    args.with_defaults(:format => 'yaml')
    configuration = AboutPage.configuration
    configuration = configuration.select { |key, value| (args.section.split(/[\W\+]/) + ["app"]).include? key.to_s } if args.section
    response_method = "to_#{args.format.downcase}".to_sym
    puts configuration.health_report.send(response_method)
  end
end