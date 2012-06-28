module SyndicationService
  class Config
    class << self
      attr_accessor :host, :hydra, :service, :password, :key
    end
  end
end
