require_relative '../test_base'

class TestDate < TestBase
  def test_date
    fire( <<DATE1, {'published_at' => Time.gm(2024,5,20)})
{{ published_at | date: "%a, %b %d, %y" }}
DATE1
    fire( <<DATE2)
{{ "March 14, 2016" | date: "%b %d, %y" }}
DATE2
    fire( <<DATE3)
now {{ "now" | date: "%Y-%m-%d" }}
today {{ "today" | date: "%Y-%m-%d" }}
DATE3
  end
end
