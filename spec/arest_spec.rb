require 'spec_helper'
describe ARest do
  describe "JSON request" do
    describe "without authentication" do
      before do
        @client = ARest.new 'http://jsonplaceholder.typicode.com'
      end
      it "should be able to get fake users list" do
        users_res = @client.get 'users'
        expect(users_res).to be_ok
        users = users_res.deserialize
        expect(users.count).to eq 10
      end
      it "should be able to GET fake user" do
        user = @client.get('users/1').deserialize
        expect(user["name"]).to eq "Leanne Graham"
      end
      it "should be able to POST fake post" do
        posts_res = @client.post('posts', form_data: { title: 'foo', body: 'bar', userId: 1 })
        expect(posts_res).to be_ok
        post = posts_res.deserialize
        expect(post['title']).to eq 'foo'
      end
      it "should be able to PUT fake post" do
        posts_res = @client.put('posts/1', form_data: { id: 1, title: 'foo', body: 'bar', userId: 1 })
        expect(posts_res).to be_ok
        post = posts_res.deserialize
        expect(post['title']).to eq 'foo'
      end
      it "should be able to DELETE fake post" do
        posts_res = @client.delete('posts/1')
        expect(posts_res).to be_ok
      end
    end

    describe "with HTTP authentication" do
      # to test authentication I use the demo of Tarkin, The Team Password Manager
      before do
        @arest = ARest.new 'http://tarkin.tg.pl/_api/v1', username: 'user@example.com', password: 'password0'
      end
      it "should be able to login with http authentication" do
        res = @arest.get '_authorize.json'
        expect(res).to be_ok
      end
      it "should be able to get password" do
        pass = @arest.get('/db/prod/oracle/scott').deserialize
        expect(pass).to eq 't1ger'
      end
    end

    describe "with form authentication" do
      before do
        @arest = ARest.new 'http://tarkin.tg.pl/_api/v1'
      end
      it "should be able to get password with form authentication" do
        pass = @arest.post('/db/prod/oracle/scott.json', form_data: { email: 'user@example.com', password: 'password0'}).deserialize
        expect(pass['password']).to eq 't1ger'
      end
    end

    describe "with token authentication" do
      before do
        auth = ARest.new 'http://tarkin.tg.pl/_api/v1', username: 'user@example.com', password: 'password0'
        token = auth.get('_authorize').deserialize
        @arest = ARest.new 'http://tarkin.tg.pl/_api/v1', token: token
      end
      it "should be able to get password" do
        pass = @arest.get('/db/prod/oracle/scott').deserialize
        expect(pass).to eq 't1ger'
      end
    end
  end

  describe "XML request" do
    describe "without authentication" do
      before do
        @client = ARest.new 'http://www.thomas-bayer.com/sqlrest'
      end
      it "should be able to get the fake customer" do 
        customer = @client.get('CUSTOMER/3').deserialize['CUSTOMER']
        expect(customer['FIRSTNAME']).to eq "Michael"
      end
    end
  end
end
