FROM debian:bullseye

RUN apt-get update && apt-get install -y netbase
RUN apt-get update && apt-get install -y openjdk-11-jdk
RUN apt-get update && apt-get install -y libc6-dev make --no-install-recommends
RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash
RUN apt-get install nodejs -y
RUN apt-get update && apt-get install -y vim

RUN apt-get update && apt-get install -y python3-venv
RUN python3 -m venv python-env

COPY requirements.txt /tmp/requirements.txt
RUN python-env/bin/pip install -r /tmp/requirements.txt
RUN apt-get update


ENV JRUBY_VERSION 9.4.2.0
ENV JRUBY_SHA256 c2b065c5546d398343f86ddea68892bb4a4b4345e6c8875e964a97377733c3f1

RUN mkdir /opt/jruby \
  && curl -fSL https://repo1.maven.org/maven2/org/jruby/jruby-dist/${JRUBY_VERSION}/jruby-dist-${JRUBY_VERSION}-bin.tar.gz -o /tmp/jruby.tar.gz \
  && echo "$JRUBY_SHA256 /tmp/jruby.tar.gz" | sha256sum -c - \
  && tar -zx --strip-components=1 -f /tmp/jruby.tar.gz -C /opt/jruby \
  && rm /tmp/jruby.tar.gz \
  && update-alternatives --install /usr/local/bin/ruby ruby /opt/jruby/bin/jruby 1
ENV PATH /opt/jruby/bin:$PATH

RUN gem install bundler rake net-telnet xmlrpc

# don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_SILENCE_ROOT_WARNING=1 \
  BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $GEM_HOME/bin:$PATH
# adjust permissions of a few directories for running "gem install" as an arbitrary user
RUN mkdir -p "$GEM_HOME" && chmod 777 "$GEM_HOME"

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /opt/digital-twins

COPY . .
RUN cd src && npm install && npm run build && rm -r node_modules/ && cd ..
COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN gem install maven-require
COPY maven_require.rb ./
RUN ./maven_require.rb

RUN cp src/dist/javascript/bundle.js static/javascript/
RUN cp src/index.css static/css

EXPOSE 5000

CMD ["rackup", "--host", "0.0.0.0", "-p", "5000"]
