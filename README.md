# ARest Ruby Gem
Very simple REST client. Provides basic REST operations: get, post, put and delete

    >> client = ARest.new 'http://jsonplaceholder.typicode.com'
    => <ARest http://jsonplaceholder.typicode.com>
    >> res = client.post('posts', form_data: { title: 'foo', body: 'bar', userId: 1 })
    => #<Net::HTTPOK 200 OK readbody=true>
    >> res.ok?
    => true
    >> res.deserialize
    => {"title"=>"foo", "body"=>"bar", "userId"=>1, "id"=>101}

## Basic http authentication

    >> auth = ARest.new 'http://tarkin.tg.pl/_api/v1', username: 'user@example.com', password: 'password0'
    => <ARest http://tarkin.tg.pl/_api/v1, authenticating as user@example.com>
    >> token = auth.get('_authorize').deserialize
    => "jbYjX0_Ofx2Okoj9XVnOJvFD-PujbRFTleATUK..."

## Token authentication

    >> client = ARest.new 'http://tarkin.tg.pl/_api/v1', token: token
    => <ARest http://tarkin.tg.pl/_api/v1>
    >> pass = client.get('/db/prod/oracle/scott').deserialize
    => "t1ger"

# License
MIT

# Author
Tomek 'Grych' Gryszkiewicz
grych@tg.pl
http://www.tg.pl
