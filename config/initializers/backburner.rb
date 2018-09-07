require_relative '../../app/jobs/update_offers'
require_relative '../../app/jobs/update_company_job'
logger = Logger.new(STDOUT)
logger.level = Logger::WARN
Backburner.configure do |config|
  config.beanstalk_url       = "beanstalk://127.0.0.1"
  config.tube_namespace      = "key_g.test"
  config.namespace_separator = "."
  config.on_error            = lambda { |e| puts e }
  config.max_job_retries     = 3 # default 0 retries
  config.retry_delay         = 2 # default 5 seconds
  config.retry_delay_proc    = lambda { |min_retry_delay, num_retries| min_retry_delay + (num_retries ** 3) }
  config.default_priority    = 100
  config.respond_timeout     = 10000
  config.default_worker      = Backburner::Workers::ThreadsOnFork
  config.logger              = logger
  config.primary_queue       = "backburner-jobs"
  config.priority_labels     = { :custom => 50, :useless => 1000 }
  config.reserve_timeout     = nil
  config.job_serializer_proc = lambda { |body| JSON.dump(body) }
  config.job_parser_proc     = lambda { |body| JSON.parse(body) }

end