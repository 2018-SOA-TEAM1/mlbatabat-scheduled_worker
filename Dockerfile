FROM s5078345/ruby-http:2.5.1

WORKDIR /worker

COPY / .

# update bundle
RUN gem install bundler -v 1.17.3

RUN bundle install

CMD rake worker

# LOCAL:
# Build local image with:
#   rake docker:build
# or:
#   docker build --rm --force-rm -t s5078345/mlbatbat-scheduler:0.1.0 .
#
# Run and test local container with:
#   rake docker:run
# or:
#   docker run -e --rm -it -v $(pwd)/config:/worker/config -w /worker soumyaray/codepraise-clone_notifier:0.1.0 ruby worker/clone_notifier.rb

# REMOTE:
# Make sure Heroku app exists:
#   heroku create mlbatbat-scheduled_worker
#
# Build and push to Heroku container registry with:
#   heroku container:push web
# (if first time, add scheduler addon to Heroku and have it run 'worker')
#
# Run and test remote container:
#   heroku run worker
# or:
#   heroku run ruby worker/clone_notifier.rb
