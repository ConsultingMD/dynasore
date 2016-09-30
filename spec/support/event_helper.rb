module PipelineEventSpecHelper
  def add_details(event)
    detail1 = Grnds::Service::Event::FileDetail.new(row: 1, column: 1, field: 'ssn', error: 'pattern')
    detail2 = Grnds::Service::Event::FileDetail.new(row: 2, column: 2, field: 'insurance_carrier', error: 'pattern')

    event.add_details([detail1, detail2])
  end

  def add_metrics(event)
    metric1 = Grnds::Service::Event::Metric.new(name: 'errors', unit: 'count', value: 100, type: 'integer')
    metric2 = Grnds::Service::Event::Metric.new(name: 'pattern', unit: 'count', value: 1000, type: 'integer')

    event.add_metrics([metric1, metric2])
  end

  def add_top_level(event)
    event.add_top_level('event_name', {'foo' => 'bar', 'input_file_mtime' => DateTime.new(2001, 1, 13).utc } )
  end

  def setup_pipeline_event(event)
    add_top_level(event)
    add_details(event)
    add_metrics(event)
  end
end
