require 'sneakers'
require 'bunny'
require 'sneakers/metrics/logging_metrics'

bunny = Bunny.new(vhost: '/',
                  user: 'guest',
                  pass: 'guest')

opts = {
  exchange: 'import',
  daemonize: Rails.env != 'development',
  start_worker_delay: 1,
  timeout_job_after: 5000,
  workers: 5,
  heartbeat: 5,
  metrics: Sneakers::Metrics::LoggingMetrics.new,
  pid_path: 'tmp/sneakers.pid',
  log: Rails.env == 'development' ? STDOUT : 'log/sneakers.log',
  exchange_options: {
    type: :direct
  },
  connection: bunny,
  ack: true
}

Sneakers.configure(opts)
Sneakers.logger.level = Logger::WARN