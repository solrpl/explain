FROM ubuntu

MAINTAINER tcnksm "https://github.com/tcnksm"

# Install packages for building ruby
RUN apt-get update
RUN apt-get install -y --force-yes build-essential curl git
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .bashrc

# Install ruby version 1.9.3-p545
ENV CONFIGURE_OPTS --disable-install-doc
RUN xargs -L 1 rbenv install 1.9.3-p545

# Install Bundler for ruby 
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN bash -l -c 'rbenv global 1.9.3-p545'
RUN bash -l -c 'gem install bundler'

# Update gems
RUN apt-get install -y libpq-dev
RUN apt-get install -y postgresql postgresql-contrib
RUN apt-get install -y sqlite3 libsqlite3-dev
RUN apt-get install -y rubygems-integration
RUN bash -l -c 'gem install bundler'

WORKDIR /home/
RUN git clone https://github.com/solrpl/explain.git
WORKDIR /home/explain/explainapp/

RUN bash -l -c 'bundle update rails'
RUN bash -l -c 'bundle install'
RUN bash -l -c 'bundle'
RUN bash -l -c 'rake db:migrate'
EXPOSE 3000

CMD bash -l -c 'bundle exec rails server'
