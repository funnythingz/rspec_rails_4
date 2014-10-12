require 'spec_helper'

describe Contact do

  # 有効なファクトリを持つこと
  it "has a valid factory" do
    expect(build(:contact)).to be_valid
  end

  # 名がなければ無効な状態であること
  it "is invalid without a firstname" do
    expect(build(:contact, firstname: nil)).to have(1).errors_on(:firstname)
  end

  # 姓がなければ無効な状態であること
  it "is invalid without a lastname" do
    expect(build(:contact, lastname: nil)).to have(1).errors_on(:lastname)
  end

  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
    contact = build(:contact, email: nil)
    expect(contact).to have(1).errors_on(:email)
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    create(:contact, email: "aaron@example.com")
    contact = build(:contact, email: "aaron@example.com")
    expect(contact).to have(1).errors_on(:email)
  end

  # 連絡先のフルネームを文字列として返すこと
  it "returns a contact's full name as a string" do
    contact = build(:contact, firstname: 'John', lastname: 'Doe')
    expect(contact.name).to eq 'John Doe'
  end

  # 文字で姓をフィルタする
  describe 'filter last name by letter' do

    before :each do
      @smith = create(:contact, lastname: 'Smith')
      @jones = create(:contact, lastname: 'Jones')
      @johnson = create(:contact, lastname: 'Johnson')
    end

    # マッチする文字の場合
    context 'matching letters' do
      it 'returns a sorted array of results that match' do
        expect(Contact.by_letter('J')).to eq [@johnson, @jones]
      end
    end

    # マッチしない文字の場合
    context 'non matching letters' do
      it 'returns a sorted array of results that match' do
        expect(Contact.by_letter('J')).to_not include @smith
      end
    end

  end

  # 3つの電話番号をもっていること
  it 'has three phone numbers' do
    expect(create(:contact).phones.count).to eq 3
  end

end