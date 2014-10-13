require 'spec_helper'

describe NewsRelease, focus: true do
  it { should validate_presence_of :released_on }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  # フォーマットされた日付とタイトルの文字列を返すころ
  it 'returns the formatted date and title as a string' do
    news_release = NewsRelease.new(released_on: '2014-10-13', title: 'BigCo hires new CEO')
    expect(news_release.title_with_date).to eq '2014-10-13: BinCo hires new CEO'
  end
end
