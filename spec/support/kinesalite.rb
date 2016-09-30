class Kinesalite
  attr_reader :pid
  def initialize(command_line_options = "")
    @pid = Process.spawn("kinesalite --port 10501 #{command_line_options}")
    sleep 0.1 # Give it time to open its port
  end

  def kill
    Process.kill("HUP", pid)
    Process.wait(pid)
  end

  def self.available?
    canary = self.new
    true
  rescue Errno::ENOENT
    false
  ensure
    canary.kill if canary
  end

  def self.install
    return true if available?
    system("npm install kinesalite")
    available?
  rescue RuntimeError
    false
  end
end

shared_context 'local kinesis' do
  let(:local_kinesis) do
    Aws::Kinesis::Client.new(
      endpoint: 'http://localhost:10501',
      access_key_id: "no_access_checks",
      secret_access_key: "no_secret_known"
    )
  end

  around do |example|
    kinesalite = Kinesalite.new
    Grnds::Service.configuration.kinesis_config.poll_interval = 0.5
    example.run
    kinesalite.kill
  end
end
