FROM ruby:3.1

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# 作業ディレクトリの設定
WORKDIR /myapp

# GemfileとGemfile.lockをコピー
COPY Gemfile Gemfile.lock ./

# ユーザーの作成
RUN groupadd -g 1000 rails && \
    useradd -u 1000 -g rails -m rails

# railsユーザーとグループの作成
# RUN groupadd --system --gid 1000 rails && \
#     useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash rails


# 作業ディレクトリの所有者を変更
RUN chown -R rails:rails /myapp
# アプリケーションディレクトリの所有権をrailsユーザーに変更
# RUN chown -R rails:rails /rails/db /rails/log /rails/storage /rails/tmp


# ユーザーを切り替え
USER rails

# Bundlerのインストール
RUN gem install bundler && bundle install

# アプリケーションのソースコードをコピー
COPY . ./

# ポートの公開
EXPOSE 3000

# サーバーの起動コマンド
CMD ["rails", "server", "-b", "0.0.0.0"]
