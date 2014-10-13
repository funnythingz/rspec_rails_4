require 'spec_helper'

describe ContactsController do

  shared_examples('public access to contacts') do
    describe 'GET #index' do
      # params[:letter] がある場合
      context 'with params[:letter]' do

        before :each do
          @smith = create(:contact, lastname: 'Smith')
          @jones = create(:contact, lastname: 'Jones')
        end

        # すべての連絡先を配列にまとめること
        it 'populates an array of all contacts' do
          get :index
          expect(assigns(:contacts)).to match_array([@smith, @jones])
        end

        # 指定された文字で始まる連絡先を配列にまとめること
        it 'populates an array of contacts starting with the letter' do
          get :index, letter: 'S'
          expect(assigns(:contacts)).to match_array([@smith])
        end

        # index テンプレートを表示すること
        it 'renders the :index template' do
          get :index, letter: 'S'
          expect(response).to render_template :index
        end
      end

      # params[:letter] がない場合
      context 'without params[:letter]' do
        # 全ての連絡先を配列にまとめること
        it 'populates an array of all contacts' do
          smith = create(:contact, lastname: 'Smith')
          jones = create(:contact, lastname: 'Jones')
          get :index
          expect(assigns(:contacts)).to match_array([smith, jones])
        end

        # index テンプレートを表示すること
        it 'renders the :index template' do
          get :index
          expect(response).to render_template :index
        end
      end
    end

    describe 'GET #show' do
      before :each do
        @contact = create(:contact)
      end

      # @contact に要求された連絡先を割り当てること
      it 'assigns the requested contact to @contact' do
        get :show, id: @contact
        expect(assigns(:contact)).to eq @contact
      end

      # :show テンプレートを表示すること
      it 'renders the :show template' do
        get :show, id: @contact
        expect(response).to render_template :show
      end
    end
  end

  shared_examples('full access to contacts') do
    describe 'GET #new' do

      before :each do
        get :new
      end
      # @contact に新しい連絡先を割り当てること
      it 'assigns a new Contact to @contact' do
        expect(assigns(:contact)).to be_a_new(Contact)
      end

      # :new テンプレートを表示すること
      it 'renders the :new template' do
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do

      before :each do
        @contact = create(:contact)
      end

      # @contact に要求された連絡先を割り当てること
      it 'assigns the requested contact to @contact' do
        get :edit, id: @contact
        expect(assigns(:contact)).to eq @contact
      end

      # :edit テンプレートを表示すること
      it 'renders the :edit template' do
        get :edit, id: @contact
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do

      before :each do
        @phones = [
            attributes_for(:phone),
            attributes_for(:phone),
            attributes_for(:phone)
        ]
      end

      # 有効な属性の場合
      context 'with valid attributes' do
        # データベースに新しい連絡先を保存すること
        it 'saves the new contact in the database' do
          expect{
            post :create, contact: attributes_for(:contact, phones_attributes: @phones)
          }.to change(Contact, :count).by(1)
        end

        # contacts"show" にリダイレクトすること
        it 'redirects to contacts#show' do
          post :create, contact: attributes_for(:contact, phones_attributes: @phones)
          expect(response).to redirect_to contact_path(assigns[:contact])
        end
      end

      # 無効な属性の場合
      context 'with invalid attributes' do
        # データベースに新しい連絡先を保存しないこと
        it 'does not save the new contact in the database' do
          expect{
            post :create, contact: attributes_for(:invalid_contact)
          }.to_not change(Contact, :count)
        end

        # :new テンプレートを再表示すること
        it 're-renders the :new template' do
          post :create, contact: attributes_for(:invalid_contact)
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do

      before :each do
        @contact = create(:contact, firstname: 'Large', lastname: 'Unko')
      end

      # 有効な属性の場合
      context 'with valid attributes' do
        # 要求された @contact を取得すること
        it 'locates the requested @contact' do
          patch :update, id: @contact, contact: attributes_for(:contact)
          expect(assigns(:contact)).to eq(@contact)
        end

        # @contact の属性を更新すること
        it 'updates the contact in the database' do
          patch :update, id: @contact, contact: attributes_for(:contact, firstname: 'Small')
          @contact.reload
          expect(@contact.firstname).to eq 'Small'
        end

        # 更新した連絡先のページへリダイレクトすること
        it 'redirects to the update contact' do
          patch :update, id: @contact, contact: attributes_for(:contact)
          expect(response).to redirect_to @contact
        end
      end

      # 無効な属性の場合
      context 'with invalid attributes' do
        # 連絡先を更新しないこと
        it "does not update the contact's attributes" do
          patch :update, id: @contact, contact: attributes_for(:contact, lastname: nil)
          @contact.reload
          expect(@contact.lastname).to eq 'Unko'
        end

        # :edit テンプレートを再表示すること
        it 're-renders the :edit template' do
          patch :update, id: @contact, contact: attributes_for(:invalid_contact)

          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do

      before :each do
        @contact = create(:contact)
      end

      # データベースから連絡先を削除すること
      it 'deletes the contact from the database' do
        expect{
          delete :destroy, id: @contact
        }.to change(Contact, :count).by(-1)
      end

      # contacts#index にリダイレクトすること
      it 'redirects to contacts#index' do
        delete :destroy, id: @contact
        expect(response).to redirect_to contacts_url
      end
    end
  end

  describe 'guest access' do
    it_behaves_like 'public access to contacts'

    describe 'GET #new' do
      # ログインを要求すること
      it 'requires login' do
        get :new
        expect(response).to require_login
      end
    end

    describe 'GET #edit' do
      # ログインを要求すること
      it 'requires login' do
        get :new, id: create(:contact)
        expect(response).to require_login
      end
    end

    describe 'POST #create' do
      # ログインを要求すること
      it 'requires login' do
        post :create, id: create(:contact), contact: attributes_for(:contact)
        expect(response).to require_login
      end
    end

    describe 'PATCH #update' do
      # ログインを要求すること
      it 'requires login' do
        patch :update, id: create(:contact), contact: attributes_for(:contact)
        expect(response).to require_login
      end
    end

    describe 'DELETE #destroy' do
      # ログインを要求すること
      it 'requires login' do
        delete :destroy, id: create(:contact)
        expect(response).to require_login
      end
    end
  end

  describe 'administrator access' do
    before :each do
      set_user_session(create(:admin))
    end

    it_behaves_like 'public access to contacts'
    it_behaves_like 'full access to contacts'
  end

  describe "user access" do
    before :each do
      set_user_session(create(:user))
    end

    it_behaves_like 'public access to contacts'
    it_behaves_like 'full access to contacts'
  end

=begin
  # TODO: CRUD以外のメソッドのテスト
  describe 'PATCH hide_contact' do
    before :each do
      @contact = create(:contact)
    end

    # 連絡先を hidden 状態にすること
    it 'marks the contact as hidden' do
      patch :hide_contact, id: @contact
      expect(@contact.reload.hidden?).to be_true
    end

    # contact#index にリダイレクトすること
    it 'redirects to contacts#index' do
      patch :hide_contact, id: @contact
      expect(response).to redirect_to contacts_url
    end
  end
=end

=begin
  # TODO: CSVのテスト
  describe 'CSV output' do
    # CSV ファイルを返すこと
    it 'returns a CSV file' do
      get :index, format: :csv
      expect(response.headers['Content-Type']).to have_content 'text/csv'
    end

    # 中身を返すこと
    it 'returns content' do
      create(:contact, firstname: 'Daisuki', lastname: 'Unko', email: 'unko@unko.unko')
      get :index, format: :csv
      expect(response.body).to have_content 'Daisuki Unko,unko@unko.unko'
    end

    # カンマ区切りの値を返すこと
    it 'returns comma separated values' do
      create(:contact, firstname: 'Daisuki', lastname: 'Unko', email: 'unko@unko.unko')
      expect(Contact.to_csv).to match /Daisuki Unko,unko@unko.unko/
    end
  end
=end

=begin
  # TODO: JSONのテスト
  it 'returns JSON-formatted content' do
    contact = create(:contact)
    get :index, format: :json
    expect(response.body).to have_content contact.to_json
  end
=end

end
