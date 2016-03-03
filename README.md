# OmniAuth Misoca Oauth2

[Misoca](http://doc.misoca.jp/v1/)のOauth2認証を行うOmniauthストラテジ

## Using omniauth-misoca-oauth2

### gemfile
```ruby
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth-misoca-oauth2'
```

### initializer
```ruby
provider :misoca_oauth2, <クライアントID>, <シークレットキー>, dev_mode: true, scope: 'read'
```
#### dev_mode
- true: devに対するキー取得
- false または 記述なし: 本番に対するキー取得

#### scope
- readまたはwrite

### アクセキー取得
- callbackで、``request.env["omniauth.auth"]``にアクセストークンが含まれます。
