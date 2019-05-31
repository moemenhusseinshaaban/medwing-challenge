class SaveReadingWorker
  include Sidekiq::Worker

  def perform(reading_attributes)
    Reading.create(reading_attributes)
  end
end
